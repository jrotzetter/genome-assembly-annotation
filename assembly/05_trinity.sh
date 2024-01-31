#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=12
#SBATCH --partition=pall
#SBATCH --job-name=trinity
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/05_output_trinity_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/05_error_trinity_%j.e

##-------------------------------------------------------------------------------
## Script will perform whole transcriptome assembly using Trinity
##-------------------------------------------------------------------------------

READS_DIR=/data/users/jrotzetter/assembly_annotation_course/participant_5/RNAseq
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_trinity/

mkdir -p "$OUTPUT_DIR"

module load UHTS/Assembler/trinityrnaseq/2.5.1;

FILES=(${READS_DIR}/*.fastq.gz)

# initialize loop counter at 0 and will run through the number "#" of items in the array FILES
# and access all elements in it with "@". Counter is incremented by 2 for the case where more than
# two files in folder and to keep forward and backward sequences together.
for (( i=0; i < ${#FILES[@]}; i += 2 )); do
    FILE1="${FILES[i]}"
    FILE2="${FILES[i + 1]}"
# --seqType option: FASTQ (fq) or FASTA (fa) file
# --SS_lib_type option: to specify strand-specificity (or strandedness) (RF or FR)
    Trinity --seqType fq --output $OUTPUT_DIR --left $FILE1 --right $FILE2 --CPU 12 --max_memory 48G
done
