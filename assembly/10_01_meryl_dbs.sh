#!/usr/bin/env bash

#SBATCH --time=6:00:00
#SBATCH --mem=25G
#SBATCH --cpus-per-task=4
#SBATCH --partition=pall
#SBATCH --job-name=meryl
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/10_output_meryl_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/10_error_meryl_%j.e

##-------------------------------------------------------------------------------
## Script will build kmer database from paired-end short reads with Meryl
##-------------------------------------------------------------------------------

# meryl is included in canu
module load UHTS/Assembler/canu/2.1.1

# READS_DIR=/data/users/jrotzetter/assembly_annotation_course/participant_5/Illumina
READS_DIR=/data/courses/assembly-annotation-course/raw_data/An-1/participant_5/Illumina
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_merqury

mkdir -p "$OUTPUT_DIR"

# When not sure which k-mer size to use (-m), run 02_00_best_k.sh with genome_size in num. of bases first

# build kmer database from paired-end short reads with Meryl

# One-step counting
# meryl k=19 count "$READS_DIR"/*.fastq.gz output "$OUTPUT_DIR"/kmer_dbs.meryl

# Two-step counting: Build meryl dbs on each input, then merge
meryl k=19 count output $SCRATCH/read_1.meryl ${READS_DIR}/*1.fastq.gz
meryl k=19 count output $SCRATCH/read_2.meryl ${READS_DIR}/*2.fastq.gz
meryl union-sum output ${OUTPUT_DIR}/genome.meryl $SCRATCH/read*.meryl