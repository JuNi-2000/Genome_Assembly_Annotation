#!/usr/bin/env bash
#SBATCH --cpus-per-task=40
#SBATCH --mem=64G
#SBATCH --time=20:00:00
#SBATCH --job-name=EDTA
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/EDTA%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/EDTA%j.e
#SBATCH --partition=pibu_el8

# Create working directories
WORKDIR="/data/users/jniklaus2/genome_annotation_2"
mkdir -p $WORKDIR/output/EDTA_annotation
cd $WORKDIR/output/EDTA_annotation

apptainer exec -C -H $WORKDIR -H ${pwd}:/work \
--writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
--genome /data/users/jniklaus2/genome_annotation/flye_results/assembly.fasta --species others --step all --cds "/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated" --anno 1 --threads 40

# extract the clades and LTRS:
#grep -oP 'Classification=[^;]+;.*ltr_identity=[0-9.]+' ./assembly.fasta.mod.LTR.intact.gff3 | awk -F'[=;]' '{print $2, $NF}' > extract_LTRS.txt
