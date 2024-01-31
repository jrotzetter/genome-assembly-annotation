#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=25G
#SBATCH --cpus-per-task=12
#SBATCH --partition=pall
#SBATCH --job-name=samtools_indexing
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/07_samtools_indexing%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/07_samtools_indexing%j.e

##-------------------------------------------------------------------------------
## Script will prepare bam files for Pilon-based assembly polishing
##-------------------------------------------------------------------------------

module load UHTS/Analysis/samtools/1.10

INPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_bowtie2_alignment
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing

mkdir -p "$OUTPUT_DIR"

# Input BAM files for pilon must be sorted in coordinate order and indexed. This can be done with samtools
# Sorts alignments by leftmost coordinates
samtools sort -m 5G -@ 4 "$INPUT_DIR"/flye.bam -o "$OUTPUT_DIR"/flye_sorted.bam

samtools sort -m 5G -@ 4 "$INPUT_DIR"/canu.bam -o "$OUTPUT_DIR"/canu_sorted.bam
# samtools sort options:
# Sort alignments by leftmost coordinates
# -m <INT>: Approximately the maximum required memory per thread, specified either in bytes or with a K, M, or G suffix.
# -@ <INT>: Set number of sorting and compression threads. By default, operation is single-threaded.
# -o <FILE>: Write the final sorted output to FILE, rather than to standard output.

samtools index -b "$OUTPUT_DIR"/flye_sorted.bam > "$OUTPUT_DIR"/flye_sorted_indx.bam

samtools index -b "$OUTPUT_DIR"/canu_sorted.bam > "$OUTPUT_DIR"/canu_sorted_indx.bam
# samtools index options:
# -b, --bai: Create a BAI index. This is currently the default when no format options are used.
# The BAI index format can handle individual chromosomes up to 512 Mbp (2^29 bases) in length.
# The organism analysed here, Arabidopsis thaliana, has an approximate genome size of 134,634,692 bp
# with chromosome lenghts between 20 and 35Mbp.
# -o, --output <FILE>: Write the output index to FILE. (Currently may only be used when exactly one alignment file is being indexed.)
# When no output filename is specified, for a BAM file aln.bam, either aln.bam.bai or aln.bam.csi will be created.
# Crashes for some reason when -o is used.

# For some reason > "$OUTPUT_DIR"/<FILENAME>_indx.bam will create an empty file and the standard <FILENAME>.bam.bai will be created instead,
# which is not recognized by pilon as being indexed for some reason.