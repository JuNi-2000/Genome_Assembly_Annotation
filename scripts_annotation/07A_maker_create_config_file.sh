#!/usr/bin/env bash
#SBATCH --cpus-per-task=
#SBATCH --mem=5G
#SBATCH --time=00:05:00
#SBATCH --job-name=MAKER
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/MAKER%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/MAKER%j.e
#SBATCH --partition=pibu_el8

#create working directory
WORKDIR="/data/users/jniklaus2/genome_annotation_2"
mkdir -p $WORKDIR/MAKER_output
cd $WORKDIR/MAKER_output

#load the container with MAKER
apptainer exec --bind $WORKDIR \
/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif maker -CTL

