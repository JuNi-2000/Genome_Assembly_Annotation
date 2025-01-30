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
export MERQURY="/usr/local/share/merqury"
cd $WORKDIR/merqury_results

##Run container with merqury for flye assembly
apptainer exec --bind $WORKDIR \
/containers/apptainer/merqury_1.3.sif \
merqury.sh $WORKDIR/merqury_results/genome.meryl \
$WORKDIR/all_assemblies_fasta/flye_assembly.fasta \
flye_merq

#Run container with merqury for LJA assembly
apptainer exec --bind $WORKDIR \
/containers/apptainer/merqury_1.3.sif \
merqury.sh $WORKDIR/merqury_results/genome.meryl \
$WORKDIR/all_assemblies_fasta/LJA_assembly.fasta \
LJA_merq

#Run container with merqury for hifiasm assembly
apptainer exec --bind $WORKDIR \
/containers/apptainer/merqury_1.3.sif \
merqury.sh $WORKDIR/merqury_results/genome.meryl \
$WORKDIR/all_assemblies_fasta/hifiasms_assembly.fasta \
hifiasm_merq