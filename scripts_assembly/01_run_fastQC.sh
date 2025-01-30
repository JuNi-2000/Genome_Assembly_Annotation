#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/output_fastqc_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/error_fastqc_%j.e
#SBATCH --partition=pibu_el8


WORKDIR="/data/users/jniklaus2/genome_annotation"
module load FastQC/0.11.9-Java-11
# Fast qc for the RNA data
fastqc --extract $WORKDIR/raw_data/RNAseq_Sha/ERR754081_* -o $WORKDIR/fastqc_results/

# FastQC for the DNA data


fastqc --extract $WORKDIR/fastp_results/R*.gz -o $WORKDIR/fastqc_results/