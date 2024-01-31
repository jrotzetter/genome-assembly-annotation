#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=03:00:00
#SBATCH --job-name=seqkit
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/01_output_seqkit_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/01_error_seqkit_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will extract basic read statistics
##-------------------------------------------------------------------------------

# load the needed module(s)
module load UHTS/Analysis/SeqKit/0.13.2

# define working, data and output directories
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w1_QC

READS_DIR=/data/courses/assembly-annotation-course/raw_data/An-1/participant_5
ILLUMINA=/data/courses/assembly-annotation-course/raw_data/An-1/participant_5/Illumina
PACBIO=/data/courses/assembly-annotation-course/raw_data/An-1/participant_5/pacbio
RNASEQ=/data/courses/assembly-annotation-course/raw_data/An-1/participant_5/RNAseq

# output in machine-friendly tabular format
seqkit stats $ILLUMINA/*.fastq.gz $PACBIO/*.fastq.gz $RNASEQ/*.fastq.gz -b -T -o ${WORK_DIR}/fastq_stats.txt