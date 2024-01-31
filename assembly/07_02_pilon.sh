#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=35G
#SBATCH --cpus-per-task=12
#SBATCH --partition=pall
#SBATCH --job-name=pilon
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/07_pilon%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/07_pilon%j.e

##-------------------------------------------------------------------------------
## Script will use Pilon identify inconsistencies between input genome and evidence in the short reads
##-------------------------------------------------------------------------------

INPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing

FLYE=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_flye/pacbio/assembly.fasta
CANU=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_canu/pacbio/pacbio_canu.contigs.fasta

mkdir -p "$OUTPUT_DIR"

# this will allocate 45GB to the Java Virtual Machine
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
--genome ${FLYE} --frags "$INPUT_DIR"/flye_sorted.bam --output flye_polished --outdir ${OUTPUT_DIR} --diploid --fix "all" --threads 4

java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
--genome ${CANU} --frags "$INPUT_DIR"/canu_sorted.bam --output canu_polished --outdir ${OUTPUT_DIR} --diploid --fix "all" --threads 4

# pilon options:
# --genome <genome.fasta>: The input genome we are trying to improve, which must be the reference used for the bam alignments.
# --frags <frags.bam>: A bam file consisting of fragment paired-end alignments, aligned to the --genome argument using bwa or bowtie2.
# --output <prefix>: Prefix for output files
# --outdir <directory>
# --diploid: Sample is from diploid organism; will eventually affect calling of heterozygous SNPs
# --fix "fixlist": A comma-separated list of categories of issues to try to fix; "all" is default
# --threads: Degree of parallelism to use for certain processing (default 1). Experimental.