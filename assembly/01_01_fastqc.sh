#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=03:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/01_output_fastqc_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/01_error_fastqc_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will run fastqc on the fastq files for pre-assembly quality control and basic read statistics
##-------------------------------------------------------------------------------

# load the needed module(s)
module load UHTS/Quality_control/fastqc/0.11.9

# define working, data and output directories
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course

READS_DIR=${WORK_DIR}/participant_5/
OUTPUT_DIR=${WORK_DIR}/assembly/w1_QC/w1_fastqc/

# will create the directories only when not already existing, no error if they do
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/Illumina/"
mkdir -p "$OUTPUT_DIR/pacbio/"
mkdir -p "$OUTPUT_DIR/RNAseq/"

# Perform fastqc on Illumina files
cd "$READS_DIR/Illumina/"
fastqc -o "$OUTPUT_DIR/Illumina/" *fastq.gz

# Perform fastqc on pacbio files
cd "$READS_DIR/pacbio/"
fastqc -o "$OUTPUT_DIR/pacbio/" *fastq.gz

# Perform fastqc on RNAseq files
cd "$READS_DIR/RNAseq/"
fastqc -o "$OUTPUT_DIR/RNAseq/" *fastq.gz