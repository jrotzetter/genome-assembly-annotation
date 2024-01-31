#!/usr/bin/env bash

#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=8G
#SBATCH --time=12:00:00
#SBATCH --job-name=genespace
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_02_output_run_genespace_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_02_error_run_genespace_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Run GENESPACE (from a container) for the identification of syntenic regions and orthogroups.
##-------------------------------------------------------------------------------

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation
# GENESPACE_IMAGE=/data/users/grochat/genome_assembly_course/scripts/genespace_1.1.4.sif
GENESPACE_IMAGE=${WORKDIR}/scripts/genespace_1.1.4.sif
GENESPACE_SCRIPT=${WORKDIR}/scripts/06_02_genespace.R

apptainer exec \
--bind ${WORKDIR} \
${GENESPACE_IMAGE} Rscript ${GENESPACE_SCRIPT}