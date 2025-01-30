#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=TE_divergence
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/TE_divergence%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/TE_divergence%j.e
#SBATCH --partition=pibu_el8

# Define paths
genome="/data/users/jniklaus2/genome_annotation_2/output/EDTA_annotation/assembly.fasta.mod.EDTA.anno/assembly.fasta.mod.out"
parser="/data/users/jniklaus2/genome_annotation_2/scripts/05-parseRM.pl"

# Changing working directory does not do anyting as the parser will write to source file location!
#WORKDIR="/data/users/jniklaus2/genome_annotation_2/TEsorter"
#cd $WORKDIR

# Load the module and run the parser
module add BioPerl/1.7.8-GCCcore-10.3.0
perl $parser -i $genome -l 50,1 -v