#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=busco
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_01_busco%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_01_busco%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will run a BUSCO analysis on predicted MAKER proteins, with which you can check the
## completeness of your MAKER annotation.
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation
BASE="run_mpi"
FILE_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation2/run_mpi.maker.output
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w8_Annotation_QC

mkdir -p ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}/maker_annotation

# IMPORTANT: to run busco, you must first make a copy of the augustus config directory
#            to a location where you have write permission (e.g. your working dir).
#            You can use the following commands:
#            cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config <PATH>/augustus_config

module load UHTS/Analysis/busco/4.1.4
# export AUGUSTUS_CONFIG_PATH=${EVAL_DIR}/augustus_config

# run busco for maker annotation
busco -i ${FILE_DIR}/${BASE}.all.maker.proteins.renamed.fasta -l brassicales_odb10 -o maker_annotation -m proteins -c 4 -f --out_path ${WORK_DIR}
