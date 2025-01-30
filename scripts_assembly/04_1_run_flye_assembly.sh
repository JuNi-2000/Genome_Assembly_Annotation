#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=flye_assembly
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/output_flye_assembly_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/error_flye_assembly_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"

apptainer exec --bind $WORKDIR \
/containers/apptainer/flye_2.9.5.sif \
flye --pacbio-hifi $WORKDIR/raw_data/ERR11437313.fastq --out-dir $WORKDIR/flye_results