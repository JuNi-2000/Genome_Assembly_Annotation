#!/usr/bin/env bash
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G
#SBATCH --time=04:00:00
#SBATCH --job-name=BLAST
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/BLAST%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/BLAST%j.e
#SBATCH --partition=pibu_el8


WORKDIR='/data/users/jniklaus2/genome_annotation_2/MAKER_output/final'
OUTDIR="/data/users/jniklaus2/genome_annotation_2/BLAST"
cd $WORKDIR

module load BLAST+/2.15.0-gompi-2021a
#makeblastdb -in /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa -dbtype prot
# this step is already done
blastp -query assembly.all.maker.proteins.fasta.renamed.filtered.fasta -db /data/courses/assembly-annotation-\
course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa -num_threads \
10 -outfmt 6 -evalue 1e-10 -out $OUTDIR/blast_out.txt

#find unique blast entries (number of gene matches to blast database)
cd $OUTDIR
awk '{print $1}' blast_output.txt | sort | uniq | wc -l > genes_with_blast_hits.txt
