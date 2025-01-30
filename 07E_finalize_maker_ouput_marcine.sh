#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=40G
#SBATCH --cpus-per-task=20
#SBATCH --job-name=finalize_annotation
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/Finalize_maker%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/Finalize_maker%j.e

# Set up paths
WORKDIR="/data/users/jniklaus2/genome_annotation_2/MAKER_output"
GFF="${WORKDIR}/assembly.all.maker.noseq.gff"
PROTEIN="${WORKDIR}/assembly.all.maker.proteins.fasta"
TRANSCRIPT="${WORKDIR}/assembly.all.maker.transcripts.fasta"
PREFIX="Ms-0"

module load UCSC-Utils/448-foss-2021a
module load BioPerl/1.7.8-GCCcore-10.3.0
module load MariaDB/10.6.4-GCC-10.3.0

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

# Prepare final directory
mkdir -p ${WORKDIR}/final2
cp $GFF ${WORKDIR}/final2/$(basename $GFF).renamed.gff
cp $PROTEIN ${WORKDIR}/final2/$(basename $PROTEIN).renamed.fasta
cp $TRANSCRIPT ${WORKDIR}/final2/$(basename $TRANSCRIPT).renamed.fasta

cd ${WORKDIR}/final2

# Generate ID map and apply to files
$MAKERBIN/maker_map_ids --prefix $PREFIX --justify 7 $(basename $GFF).renamed.gff > id.map
$MAKERBIN/map_gff_ids id.map $(basename $GFF).renamed.gff
$MAKERBIN/map_fasta_ids id.map $(basename $PROTEIN).renamed.fasta
$MAKERBIN/map_fasta_ids id.map $(basename $TRANSCRIPT).renamed.fasta

# Run InterProScan
apptainer exec \
    --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
    --bind $WORKDIR \
    --bind $COURSEDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/interproscan_latest.sif \
    /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i $(basename $PROTEIN).renamed.fasta -o output.iprscan

# Update the GFF file with InterProScan results
$MAKERBIN/ipr_update_gff $(basename $GFF).renamed.gff output.iprscan > $(basename $GFF).renamed.iprscan.gff

# Generate AED values for quality control
perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 $(basename $GFF).renamed.gff > assembly.all.maker.renamed.gff.AED.txt

# Tighten AED and InterProScan filtering criteria
perl $MAKERBIN/quality_filter.pl -a 0.5 $(basename $GFF).renamed.iprscan.gff > $(basename $GFF)_iprscan_quality_filtered.gff

# Log unique feature types
cut -f3 $(basename $GFF)_iprscan_quality_filtered.gff | sort | uniq

# Filter for specific features
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" $(basename $GFF)_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# Add back the GFF3 header
grep "^#" $(basename $GFF)_iprscan_quality_filtered.gff > header.txt
cat header.txt filtered.genes.renamed.gff3 > filtered.genes.renamed.final.gff3

# Extract mRNA IDs for filtering transcripts and proteins
grep -P "\tmRNA\t" filtered.genes.renamed.final.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > mRNA_list.txt

# Filter transcript and protein FASTA files
faSomeRecords $(basename $TRANSCRIPT).renamed.fasta mRNA_list.txt $(basename $TRANSCRIPT).renamed.filtered.fasta
faSomeRecords $(basename $PROTEIN).renamed.fasta mRNA_list.txt $(basename $PROTEIN).renamed.filtered.fasta