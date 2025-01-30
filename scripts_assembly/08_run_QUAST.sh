#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=03:00:00
#SBATCH --job-name=QUAST
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/QUAST_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/QUAST_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"
cd $WORKDIR 
mkdir quast_results
REFERENCE="/data/courses/assembly-annotation-course/references"

#Run container with quast
apptainer exec --bind /data \
/containers/apptainer/quast_5.2.0.sif \
quast $WORKDIR/all_assemblies_fasta/flye_assembly.fasta \
$WORKDIR/all_assemblies_fasta/hifiasms_assembly.fasta \
$WORKDIR/all_assemblies_fasta/LJA_assembly.fasta \
-o $WORKDIR/quast_results \
-r $REFERENCE/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
-g $REFERENCE/TAIR10_GFF3_genes.gff \
-t 16 -e --labels "flye, hifiasm, LJA"
