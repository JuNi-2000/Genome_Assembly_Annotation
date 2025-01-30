#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --job-name=TE_phylogenetics
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/TE_phylogenetics%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/TE_phylogenetics%j.e
#SBATCH --partition=pibu_el8

cd /data/users/jniklaus2/genome_annotation_2/MAKER_output/

#get numebr of genes
grep -P "\tgene\t" assembly.all.maker.noseq.gff | wc -l > total_genes_count.txt

cd /data/users/jniklaus2/genome_annotation_2/MAKER_output/final

#get number of filtered genes
grep -P "\tgene\t" filtered.genes.renamed.final.gff3 | wc -l > filtered_genes_count.txt