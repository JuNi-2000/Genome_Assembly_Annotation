#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=hifiasm_assembly
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/hifiasm_assembly_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/hifiasm_assembly_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"

#Run container with hifiasm
apptainer exec --bind $WORKDIR \
/containers/apptainer/hifiasm_0.19.8.sif \
hifiasm -o DNA_hifiasm.gfa -t 16 $WORKDIR/raw_data/ERR11437313.fastq

#CHANGE data format to fasta file
awk '/^S/{print ">"$2;print $3}' DNA_hifiasm.gfa.bp.p_ctg.gfa > DNA_hifiasm.fa