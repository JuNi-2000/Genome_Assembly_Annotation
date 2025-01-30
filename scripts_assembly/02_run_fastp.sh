#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastq
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/output_fastq_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/error_fastq_%j.e
#SBATCH --partition=pibu_el8


WORKDIR="/data/users/jniklaus2/genome_annotation"
module load fastp/0.23.4-GCC-10.3.0
#DNA trimming does not yield a result because quality is already super high
fastp -i $WORKDIR/raw_data/ERR11437313.fastq -o $WORKDIR/fastp_results/genome.gz

#TRIMMING RNA DATA with q threshold of 20
fastp -i $WORKDIR/raw_data/RNAseq_Sha/ERR754081_1.fastq.gz -I $WORKDIR/raw_data/RNAseq_Sha/ERR754081_2.fastq.gz -o $WORKDIR/fastp_results/R1.fastq.gz -O $WORKDIR/fastp_results/R2.fastq.gz \
-q 20 -f 10 -t 10 -F 10 -T 10