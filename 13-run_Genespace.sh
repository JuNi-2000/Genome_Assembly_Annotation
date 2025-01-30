#!/bin/bash
#SBATCH --time=1-0
#SBATCH --mem=64G
#SBATCH -p pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=Genespace
#SBATCH --output=/data/users/jniklaus2/genome_annotation_2/GENESPACE%j.o
#SBATCH --error=/data/users/jniklaus2/genome_annotation_2/GENESPACE%j.e

module load R-bundle-IBU/2023121400-foss-2021a-R-4.3.2 
module load UCSC-Utils/448-foss-2021a
module R-bundle-CRAN/2023.11-foss-2021a #the faSome does not work.. load mariadb to prevent problem
module load MariaDB/10.6.4-GCC-10.3.0

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation/"
WORKDIR="/data/users/jniklaus2/genome_annotation_2/"
cd $WORKDIR

apptainer exec \
    --bind $COURSEDIR \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif \
    Rscript /data/users/jniklaus2/genome_annotation_2/scripts/14-Genespace.R genespace

# apptainer shell \
#     --bind $COURSEDIR \
#     --bind $WORKDIR \
#     --bind $SCRATCH:/temp \
#     $COURSEDIR/containers/genespace_latest.sif