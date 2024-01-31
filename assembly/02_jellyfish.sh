#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=kmercount
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/02_output_kmercount_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/02_error_kmercount_%j.e

##-------------------------------------------------------------------------------
## Script will count k-mers and create a k-mer histogram
##-------------------------------------------------------------------------------

# define data and output directories
READS_DIR=/data/users/jrotzetter/assembly_annotation_course/participant_5/
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w1_QC/w1_kmer_counts/

# will create the directories only when not already existing, no error if they do
mkdir -p "$OUTPUT_DIR"

# load the needed module(s)
module load UHTS/Analysis/jellyfish/2.3.0

# function to run jellyfish for kmer counting and histogram generation
run_jellyfish() {
    INPUT_DIR="$1"
    SEQ_METHOD="$2"

    FILES=(${INPUT_DIR}/*.fastq.gz)
    OUTPUT_FILE="${SEQ_METHOD}_reads.jf"

# initialize loop counter at 0 and will run through the number "#" of items in the array FILES
# and access all elements in it with "@". Counter is incremented by 2 for the case where more than
# two files in folder and to keep forward and backward sequences together.
    for (( i=0; i < ${#FILES[@]}; i += 2 )); do
        FILE1="${FILES[i]}"
        FILE2="${FILES[i + 1]}"
    done
    # When not sure which k-mer size to use (-m), run 02_00_best_k.sh with genome_size in num. of bases first
    jellyfish count -C -m 19 -s 5G -t 4 -o "$OUTPUT_FILE" <(zcat "$FILE1") <(zcat "$FILE2")
    jellyfish histo -t 10 "$OUTPUT_FILE" > "${OUTPUT_FILE}.histo"
}

#Illumina
ILL_IN="${READS_DIR}/Illumina"
ILL_OUT="${OUTPUT_DIR}/Illumina"
run_jellyfish "$ILL_IN" "$ILL_OUT"

#pacbio
PACBIO_IN="${READS_DIR}/pacbio"
PACBIO_OUT="${OUTPUT_DIR}/pacbio"
run_jellyfish "$PACBIO_IN" "$PACBIO_OUT"

#RNAseq
RNASEQ_IN="${READS_DIR}/RNAseq"
RNASEQ_OUT="${OUTPUT_DIR}/RNAseq"
run_jellyfish "$RNASEQ_IN" "$RNASEQ_OUT"