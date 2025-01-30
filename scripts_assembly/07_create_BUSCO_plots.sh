#!/usr/bin/env bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=BUSCO_plots
#SBATCH --output=/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/BUSCO_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/BUSCO_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation/BUSCO_summaries"
python3 /software/modules/bio/BUSCO/5.4.2-foss-2021a.lua/generate_plot.py –wd $WORKDIR
