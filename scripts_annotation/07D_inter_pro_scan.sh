#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=inter_pro_scan
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/inter_pro_scan%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/inter_pro_scan%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation_2/MAKER_output"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"

#apptainer exec \
#--bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
#--bind $WORKDIR \
#--bind $COURSEDIR \
#--bind $SCRATCH:/temp \
#$COURSEDIR/containers/interproscan_latest.sif \
#/opt/interproscan/interproscan.sh \
#-appl pfam --disable-precalc -f TSV \
#--goterms --iprlookup --seqtype p \
#-i MAKER_output/final/${protein}.renamed.fasta -o output.iprscan

# update GFF with inter pro scan results
#$MAKERBIN/ipr_update_gff MAKER_output/final/${gff}.renamed.gff output.iprscan > MAKER_output/final/${gff}.renamed.iprscan.gff

# calculate AOD values
perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 MAKER_output/final/${gff}.renamed.gff > assembly.all.maker.renamed.gff.AED.txt


# Filter the gff file based on AED values and Pfam domains
cd MAKER_output/final
perl $MAKERBIN/quality_filter.pl -s ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff
# In the above command: -s  Prints transcripts with an AED <1 and/or Pfam domain if in gff3 
## Note: When you do QC of your gene models, you will see that AED <1 is not sufficient. We should rather have a script with AED <0.5

#do AGAIN with AED below 0.5
perl $MAKERBIN/quality_filter.pl -a 0.5 ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff

# The gff also contains other features like Repeats, and match hints from different sources of evidence
# Let's see what are the different types of features in the gff file
cut -f3 ${gff}_iprscan_quality_filtered.gff | sort | uniq

# We only want to keep gene features in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# We need to add back the gff3 header to the filtered gff file so that it can be used by other tools
grep "^#" ${gff}_iprscan_quality_filtered.gff > header.txt
cat header.txt filtered.genes.renamed.gff3 > filtered.genes.renamed.final.gff3

module load UCSC-Utils/448-foss-2021a
#the faSome does not work.. load mariadb to prevent problem
module load MariaDB/10.6.4-GCC-10.3.0
# Get the names of remaining mRNAs and extract them from the transcript and and their proteins from the protein files
grep -P "\tmRNA\t" filtered.genes.renamed.final.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' >mRNA_list.txt
faSomeRecords ${transcript}.renamed.fasta mRNA_list.txt ${transcript}.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta mRNA_list.txt ${protein}.renamed.filtered.fasta