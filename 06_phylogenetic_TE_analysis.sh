#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=TE_phylogenetics
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/TE_phylogenetics%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/TE_phylogenetics%j.e
#SBATCH --partition=pibu_el8

module load SeqKit/2.6.1 

WORKDIR="/data/users/jniklaus2/genome_annotation_2/TE_phylogenetics"
gypsy="/data/users/jniklaus2/genome_annotation_2/TEsorter/Gypsy_sequences.fa.rexdb-plant.dom.faa"
copia="/data/users/jniklaus2/genome_annotation_2/TEsorter/Copia_sequences.fa.rexdb-plant.dom.faa"

cd $WORKDIR
grep -A1 Ty3-RT $gypsy > $WORKDIR/list_gypsy.txt #make a list of RT proteins to extract
sed -i 's/>//' list_gypsy.txt #remove ">" from the header
sed -i 's/ .\+//' list_gypsy.txt #remove all characters following "empty space" from the header
seqkit grep -f list_gypsy.txt $gypsy -o $WORKDIR/Gypsy_RT.fasta

grep -A1 Ty1-RT $copia > $WORKDIR/list_copia.txt #make a list of RT proteins to extract
sed -i 's/>//' list_copia.txt #remove ">" from the header
sed -i 's/ .\+//' list_copia.txt #remove all characters following "empty space" from the header
seqkit grep -f list_copia.txt $copia -o $WORKDIR/Copia_RT.fasta

#rerunning TE Sorter for the Brassicacea (other species)
apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u /data/courses/assembly-annotation-\
course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter $WORKDIR/Brassicaceae_repbase_all_march2019.fasta -db rexdb-plant
 
brassicaceae="$WORKDIR/Brassicaceae_repbase_all_march2019.fasta.rexdb-plant.dom.faa"
#seperate the two families:
grep -A1 Ty3_gypsy $brassicaceae > $WORKDIR/brassicaceae_gypsy.dom.faa
grep -A1 Ty1_copia $brassicaceae > $WORKDIR/brassicaceae_copia.dom.faa

brassicaceae_gypsy="$WORKDIR/brassicaceae_gypsy.dom.faa"
brassicaceae_copia="$WORKDIR/brassicaceae_copia.dom.faa"

#extract the RT proteins
grep -A1 Ty3-RT $brassicaceae_gypsy > $WORKDIR/brassicaceae_list_gypsy.txt #make a list of RT proteins to extract
sed -i 's/>//' brassicaceae_list_gypsy.txt #remove ">" from the header
sed -i 's/ .\+//' brassicaceae_list_gypsy.txt #remove all characters following "empty space" from the header
seqkit grep -f $WORKDIR/brassicaceae_list_gypsy.txt $brassicaceae -o $WORKDIR/brassicaceae_Gypsy_RT.fasta

grep -A1 Ty1-RT $brassicaceae_copia > $WORKDIR/brassicaceae_list_copia.txt #make a list of RT proteins to extract
sed -i 's/>//' brassicaceae_list_copia.txt #remove ">" from the header
sed -i 's/ .\+//' brassicaceae_list_copia.txt #remove all characters following "empty space" from the header
seqkit grep -f $WORKDIR/brassicaceae_list_copia.txt $brassicaceae -o $WORKDIR/brassicaceae_Copia_RT.fasta


# CONCATENATE brassicacea and arabidopsis
cat $WORKDIR/Gypsy_RT.fasta $WORKDIR/brassicaceae_Gypsy_RT.fasta > gypsy_concatenated.fasta
cat $WORKDIR/Copia_RT.fasta $WORKDIR/brassicaceae_Copia_RT.fasta > copia_concatenated.fasta

# Shorten identifiers of RT sequences
# For gypsy sequences:
sed -i 's/#.\+//' gypsy_concatenated.fasta
sed -i 's/:/_/g' gypsy_concatenated.fasta
sed -E -i 's/^>([^|]+)\|.*/>\1/' gypsy_concatenated.fasta 

# For copia sequences:
sed -i 's/#.\+//' copia_concatenated.fasta
sed -i 's/:/_/g' copia_concatenated.fasta
sed -E -i 's/^>([^|]+)\|.*/>\1/' copia_concatenated.fasta 

# Align sequences with Clustal Omega
module load Clustal-Omega/1.2.4-GCC-10.3.0
clustalo -i gypsy_concatenated.fasta -o gypsy_concatenated_aligned.fasta
clustalo -i copia_concatenated.fasta -o copia_concatenated_aligned.fasta

# Infer max likelihood tree using  FastTree
module load FastTree/2.1.11-GCCcore-10.3.0
FastTree -out gypsy_ML_tree ./gypsy_concatenated_aligned.fasta
FastTree -out copia_ML_tree ./copia_concatenated_aligned.fasta

# Extract main TE clades for Tree annotation
# We need to merge Informations from both tsv files (arabidopsis and brassicacea)

# Extract unique clade names from tsv files to find the most important ones
cut -f4 Brassicaceae_repbase_all_march2019.fasta.rexdb-plant.cls.tsv | sort | uniq > clades.txt

# Define a list of colors (add more if needed)
colors=("#FF0000" "#00FF00" "#0000FF" "#FFA500" "#800080" "#00FFFF" "#A52A2A" "#FFC0CB" "#808080" "#FFFF00")

# Index for cycling through colors
index=0

# Loop over each element in clades.txt
while read -r element; do
    # Assign a color (cycling through the list if it runs out)
    color=${colors[$index]}
    
    # Run the grep and formatting commands, appending to all_colours.txt
    grep -e "$element" ./*rexdb-plant.cls.tsv | cut -f 1 | sed 's/:/_/' | sed 's/#.*//' | \
    sed "s/$/ $color $element/" | sed 's/.*\.cls\.tsv_//' >> all_colours.txt

    # Increment the color index and reset if necessary
    index=$(( (index + 1) % ${#colors[@]} ))
done < clades.txt

# Color file can be used for tree annotation

# get the count numbers
# define path to EDTA. sum file
EDTA_SUM="/data/users/jniklaus2/genome_annotation_2/output/EDTA_annotation/assembly.fasta.mod.EDTA.TEanno.sum"
grep "^TE" $EDTA_SUM | awk '{print $1, $2}' > TE_counts.txt