#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=trinity_transcriptome
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/trinity_assembly_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/trinity_assembly_%j.e
#SBATCH --partition=pibu_el8

#load trinity
module load Trinity/2.15.1-foss-2021a

WORKDIR="/data/users/jniklaus2/genome_annotation"
mkdir trinity_results

#Assembling transcriptome
Trinity --seqType fq --left $WORKDIR/fastp_results/R1.fastq.gz \
--right $WORKDIR/fastp_results/R2.fastq.gz --CPU 16 --max_memory 64G \
--output $WORKDIR/trinity_results