#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=kmer
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/output_kmer_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/error_kmer_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation/raw_data"
cd $WORKDIR

module load Jellyfish/2.3.0-GCC-10.3.0
# Get the Kmer counts
jellyfish count -C -m 21 -s 5G -t 4 ERR11437313.fastq -o reads.jf
# Create the Kmer histogram -> Upload to genomescope.org
jellyfish histo -t 4 reads.jf > reads.histo