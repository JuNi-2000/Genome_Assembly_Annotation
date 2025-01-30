#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=TEsorter
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/TEsorter%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/TEsorter%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation_2/TEsorter"
module load SeqKit/2.6.1 

# Extract Copia sequences
seqkit grep -r -p "Copia" $genome.mod.EDTA.TElib.fa > Copia_sequences.fa
# Extract Gypsy sequences
seqkit grep -r -p "Gypsy" $genome.mod.EDTA.TElib.fa > Gypsy_sequences.fa

# Run TEsorter on Copia sequences
apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u /data/courses/assembly-annotation-\
course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter Copia_sequences.fa -db rexdb-plant

# Run TEsorter on Gypsy sequences
apptainer exec -C -H $WORKDIR -H ${pwd}:/work --writable-tmpfs -u /data/courses/assembly-annotation-\
course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter Gypsy_sequences.fa -db rexdb-plant