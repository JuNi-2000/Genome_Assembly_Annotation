#!/usr/bin/env bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=03:00:00
#SBATCH --job-name=mummerplot
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation/mummerplot_results/mummerplot_%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation/mummerplot_results/mummerplot_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/jniklaus2/genome_annotation"
REFERENCE="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
FLYE="/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/flye_assembly.fasta"
HIFIASM="/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/hifiasms_assembly.fasta"
LJA="/data/users/jniklaus2/genome_annotation/all_assemblies_fasta/LJA_assembly.fasta"
OTHER_ACCESSION="/data/users/harribas/assembly_course/assembly/results_fly/assembly.fasta" #Other accession for comparison

FLYE_DELTA="/data/users/jniklaus2/genome_annotation/nucmer_results/flye_nucmer.delta"
HIFIASM_DELTA="/data/users/jniklaus2/genome_annotation/nucmer_results/hifiasm.delta"
LJA_DELTA="/data/users/jniklaus2/genome_annotation/nucmer_results/LJA.delta"
FLYE_FLYE_COMP_OTHER_ACCESSION="/data/users/jniklaus2/genome_annotation/nucmer_results/flye_flye_altai5_comp.delta"

#CHANGE DIRECTORY INTO CORRECT OUTPUT FOLDER
cd $WORKDIR/mummerplot_results

#Run container with mummerplot 
apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE -Q $FLYE --filter $FLYE_DELTA -t png --large --layout --fat -p flye_mummerplot

apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE -Q $HIFIASM --filter $HIFIASM_DELTA -t png --large --layout --fat -p hifiasm_mummerplot

apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE -Q $LJA --filter $LJA_DELTA -t png --large --layout --fat -p LJA_mummerplot

apptainer exec --bind $WORKDIR \
/containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $FLYE -Q $OTHER_ACCESSION --filter $FLYE_FLYE_COMP_OTHER_ACCESSION -t png --large --layout --fat -p FLYE_FLYE_comparison_altai5
