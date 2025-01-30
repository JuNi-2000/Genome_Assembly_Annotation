#!/usr/bin/env bash
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --job-name=OMArk
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/OMArk%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/OMArk%j.e
#SBATCH --partition=pibu_el8

module add Anaconda3/2022.05
# create the environment (do only once and then comment out)
#conda env create -f "/data/users/jniklaus2/genome_annotation_2/OMArk/OMArk.yaml"
# initialize and activate the conda environment
eval "$(conda shell.bash hook)"
conda activate OMArk

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/jniklaus2/genome_annotation_2/OMArk"
cd $WORKDIR

protein="/data/users/jniklaus2/genome_annotation_2/MAKER_output/final/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
splice="/data/users/jniklaus2/genome_annotation_2/MAKER_output/final/omark_input.txt"

OMArk="/data/courses/assembly-annotation-course/CDS_annotation/softwares/OMArk-0.3.0/"

#wget https://omabrowser.org/All/LUCA.h5
omamer search --db  LUCA.h5 --query ${protein} --out ${protein}.omamer

omark -f ${protein}.omamer -of ${protein} -i ${splice} -d LUCA.h5 -o omark_output