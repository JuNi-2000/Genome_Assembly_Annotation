#!/usr/bin/env bash
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --job-name=GENESPACE
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/GENESPACE%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/GENESPACE%j.e
#SBATCH --partition=pibu_el8

module load R-bundle-IBU/2023121400-foss-2021a-R-4.3.2 
module load UCSC-Utils/448-foss-2021a
module R-bundle-CRAN/2023.11-foss-2021a #the faSome does not work.. load mariadb to prevent problem
module load MariaDB/10.6.4-GCC-10.3.0

WORKDIR="/data/users/jniklaus2/genome_annotation_2/genespace"
Rscript /data/users/jniklaus2/genome_annotation_2/12-create_Genespace_folders.R
