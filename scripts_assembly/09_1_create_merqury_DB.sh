#!/usr/bin/env bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=03:00:00
#SBATCH --job-name=merqury
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/merqury_results/merqury_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/merqury_results/merqury_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"
MERQURY="/usr/local/share/merqury"
cd $WORKDIR 

#Run container with merqury
apptainer exec --bind $WORKDIR \
/containers/apptainer/merqury_1.3.sif \
#Finding best k-mer size using genome size (see k mer coverage graph)
sh $MERQURY/best_k.sh 164416269
#best Kmer size in this case is 19

apptainer exec --bind $WORKDIR \
/containers/apptainer/merqury_1.3.sif \
meryl k=19 count $WORKDIR/raw_data/ERR11437313.fastq output $WORKDIR/merqury_results/genome.meryl \
memory=64g