#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=maker_ouput_prep
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/maker_output_prep%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/maker_output_prep%j.e
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
WORKDIR="/data/users/jniklaus2/genome_annotation_2/MAKER_output"
cd $WORKDIR

#preparing output by merging all the files 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"
$MAKERBIN/gff3_merge -s -d $WORKDIR/assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.gff
$MAKERBIN/gff3_merge -n -s -d $WORKDIR/assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.noseq.gff 
$MAKERBIN/fasta_merge -d $WORKDIR/assembly.maker.output/assembly_master_datastore_index.log -o assembly

##copy necessary files and rename them
mkdir -p final
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
prefix="Ms-0"
gff="assembly.all.maker.noseq.gff"
cp $gff final/${gff}.renamed.gff
cp $protein final/${protein}.renamed.fasta
cp $transcript final/${transcript}.renamed.fasta
cd final

#To assign clean, consistent IDs to the gene models, use MAKER’s ID mapping tools.
$MAKERBIN/maker_map_ids --prefix $prefix --justify 7 final/${gff}.renamed.gff > id.map
$MAKERBIN/map_gff_ids id.map final/${gff}.renamed.gff
$MAKERBIN/map_fasta_ids id.map final/${protein}.renamed.fasta
$MAKERBIN/map_fasta_ids id.map final/${transcript}.renamed.fasta