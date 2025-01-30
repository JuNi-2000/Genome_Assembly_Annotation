#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=04:00:00
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/BUSCO_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/BUSCO_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"
cd $WORKDIR 

#Run container with BUSCO
#CONTAINTER VERSION HAS PROBLEM REACHING SERVER! TRYING WITH MODULE
#apptainer exec --bind $WORKDIR \
#/containers/apptainer/busco_5.7.1.sif \
module load BUSCO/5.4.2-foss-2021a 
busco -f -i $WORKDIR/all_assemblies_fasta/flye_assembly.fasta -l brassicales_odb10 -o flye_busco \
--out_path $WORKDIR/all_assemblies_fasta -m genome --cpu 16
busco -f -i $WORKDIR/all_assemblies_fasta/hifiasms_assembly.fasta -l brassicales_odb10 -o hifiasm_busco \
--out_path $WORKDIR/all_assemblies_fasta -m genome --cpu 16
busco -f -i $WORKDIR/all_assemblies_fasta/LJA_assembly.fasta -l brassicales_odb10 -o LJA_busco \
--out_path $WORKDIR/all_assemblies_fasta -m genome --cpu 16

#RUN BUSCO on transcriptome assembly
busco -f -i $WORKDIR/trinity_results/trinity_results.Trinity.fasta -l brassicales_odb10 -o trancriptome_busco \
--out_path $WORKDIR/all_assemblies_fasta -m transcriptome --cpu 16
