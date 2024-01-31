#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pall
#SBATCH --job-name=flye
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/03_output_flye_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/03_error_flye_%j.e

##-------------------------------------------------------------------------------
## Script will perform de novo whole genome assembly using Flye
##-------------------------------------------------------------------------------

READS_DIR=/data/users/jrotzetter/assembly_annotation_course/participant_5/

module load UHTS/Assembler/flye/2.8.3;

FILES=("$READS_DIR"/*.fastq.gz)

# function to run flye for kmer counting and histogram generation
run_flye() {
    INPUT_DIR="$1"
    OUTPUT_DIR="$2"

    FILES=(${INPUT_DIR}/*.fastq.gz)

# initialize loop counter at 0 and will run through the number "#" of items in the array FILES
# and access all elements in it with "@". Counter is incremented by 2 for the case where more than
# two files in folder and to keep forward and backward sequences together.
    for (( i=0; i < ${#FILES[@]}; i += 2 )); do
        FILE1="${FILES[i]}"
        FILE2="${FILES[i + 1]}"
    done

    flye --pacbio-raw $FILE1 $FILE2 --out-dir ${OUTPUT_DIR} --threads 16
}

# pacbio
PACBIO_IN="${READS_DIR}/pacbio"
PACBIO_OUT=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_flye/pacbio/

mkdir -p "$PACBIO_OUT"

run_flye "$PACBIO_IN" "$PACBIO_OUT"