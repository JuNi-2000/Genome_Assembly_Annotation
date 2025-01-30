#!/usr/bin/env bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --time=04:00:00
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=julian.niklaus@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/BUSCO%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/BUSCO%j.e
#SBATCH --partition=pibu_el8


WORKDIR='/data/users/jniklaus2/genome_annotation_2/MAKER_output/final'
mkdir -p BUSCO

cd $WORKDIR
module load BUSCO/5.4.2-foss-2021a
busco -i assembly.all.maker.proteins.fasta.renamed.filtered.fasta -l brassicales_odb10 -o $WORKDIR/BUSCO/busco_output_proteins -m proteins
busco -i assembly.all.maker.transcripts.fasta.renamed.filtered.fasta -l brassicales_odb10 -o $WORKDIR/BUSCO/busco_output_transcriptome -m transcriptome