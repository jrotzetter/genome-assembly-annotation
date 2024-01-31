#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=riparian_plot
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_04_riparian_plot_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_04_riparian_plot_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## Run GENESPACE (from a container) to create a riparian plot from GENESPACE output data through an R script
##-------------------------------------------------------------------------------

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation
# GENESPACE_IMAGE=/data/users/grochat/genome_assembly_course/scripts/genespace_1.1.4.sif
GENESPACE_IMAGE=${WORKDIR}/scripts/genespace_1.1.4.sif
SCRIPT=${WORKDIR}/scripts/06_04_riparian_plot.R
OUT_DIR=${WORKDIR}/w9_comparative_genomics/synteny_map

mkdir -p ${OUT_DIR}

cd ${OUT_DIR}

apptainer exec \
--bind ${WORKDIR} \
${GENESPACE_IMAGE} Rscript ${SCRIPT}