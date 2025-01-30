#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=LJA_assembly
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/output_LJA_assembly_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/error_LJA_assembly_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"
#create results folder
mkdir LJA_results

apptainer exec --bind $WORKDIR \
/containers/apptainer/lja-0.2.sif \
lja -o $WORKDIR/LJA_results --reads $WORKDIR/raw_data/ERR11437313.fastq -t 16