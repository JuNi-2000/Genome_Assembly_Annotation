#!/usr/bin/env bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=03:00:00
#SBATCH --job-name=nucmer
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/nucmer_results/nucmer_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/nucmer_results/nucmer_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"
REFERENCE="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
FLYE="/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/flye_assembly.fasta"
HIFIASM="/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/hifiasms_assembly.fasta"
LJA="/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/LJA_assembly.fasta"
OTHER_ACCESSION="/data/users/harribas/assembly_course/assembly/results_fly/assembly.fasta" #Other accession for comparison

#CHANGE DIRECTORY INTO CORRECT OUTPUT FOLDER
cd $WORKDIR/nucmer_results

#Run container with nucmer 
apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
nucmer -p flye_nucmer $REFERENCE $FLYE --mincluster 1000 --breaklen 1000
#Run container with nucmer 
apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
nucmer -p hifiasm $REFERENCE $HIFIASM --mincluster 1000 --breaklen 1000

#Run container with nucmer 
apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
nucmer -p LJA $REFERENCE $LJA --mincluster 1000 --breaklen 1000

#Run container with nucmer 
apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
nucmer -p FlYE_FLYE_comparison $FLYE $OTHER_ACCESSION --mincluster 1000 --breaklen 1000