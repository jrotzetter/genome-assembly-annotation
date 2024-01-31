#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --partition=pall
#SBATCH --job-name=canu
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/04_output_canu_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/04_error_canu_%j.e

##-------------------------------------------------------------------------------
## Script will perform de novo whole genome assembly using Canu
##-------------------------------------------------------------------------------

READS_DIR=/data/users/jrotzetter/assembly_annotation_course/participant_5/

module load UHTS/Assembler/canu/2.1.1;

FILES=("$READS_DIR"/*.fastq.gz)

# function to run canu for kmer counting and histogram generation
run_canu() {
    INPUT_DIR="$1"
    OUTPUT_DIR="$2"

    FILES=(${INPUT_DIR}/*.fastq.gz)

# initialize loop counter at 0 and will run through the number "#" of items in the array FILES
# and access all elements in it with "@". Counter is incremented by 2 for the case where more than
# two files in folder and to keep forward and backward sequences together.
    for (( i=0; i < ${#FILES[@]}; i += 2 )); do
        FILE1="${FILES[i]}"
        FILE2="${FILES[i + 1]}"

        # Run Canu assembly for the current pair of files
        canu maxThreads=16 maxMemory=64 gridEngineResourceOption="--cpus-per-task=THREADS \
        --mem-per-cpu=MEMORY" gridOptions="--partition=pall --mail-user=jrotzetter@students.unibe.ch" \
        -p "pacbio_canu" genomeSize=126m -d "$OUTPUT_DIR" -pacbio "$FILE1" "$FILE2"
    done
}

# pacbio
PACBIO_IN="${READS_DIR}/pacbio"
PACBIO_OUT=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_canu/pacbio/

mkdir -p "$PACBIO_OUT"

run_canu "$PACBIO_IN" "$PACBIO_OUT"