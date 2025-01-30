#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=5G
#SBATCH --time=00:05:00
#SBATCH --job-name=TE_sorter
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/MAKER%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/MAKER%j.e
#SBATCH --partition=pibu_el8


CLEANUP="/data/users/jniklaus2/genome_annotation_2/output/EDTA_annotation/assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.fa"
WORKDIR="/data/users/jniklaus2/genome_annotation_2/"

apptainer exec -C -H $WORKDIR -H ${pwd}:/work \
--writable-tmpfs -u /data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif \
TEsorter $CLEANUP -db rexdb-plant