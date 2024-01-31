#!/usr/bin/env bash

#SBATCH --time=00:15:00
#SBATCH --mem=6G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=nucmer
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/11_output_nucmer_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/11_error_nucmer_%j.e

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w4_comparison
OUTPUT_DIR=${WORK_DIR}/nucmer

FLYE=flye
CANU=canu

# load the module
module add UHTS/Analysis/mummer/4.0.0beta1

mkdir -p "$WORK_DIR"
mkdir -p "$OUTPUT_DIR"
mkdir -p ${OUTPUT_DIR}/$FLYE
mkdir -p ${OUTPUT_DIR}/$CANU
mkdir -p ${OUTPUT_DIR}/flye_canu

# reference genome
REF_GEN=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

ASSEMBLY_FLYE=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/flye_polished.fasta
ASSEMBLY_CANU=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/canu_polished.fasta

# Go to the directory where the results should be stored.
cd ${OUTPUT_DIR}/$FLYE

# Run nucmer to map the assembled genomes (flye) against the reference genome.
nucmer -b 1000 -c 1000 -p ${FLYE} ${REF_GEN} ${ASSEMBLY_FLYE}

# Go to the directory where the results should be stored.
cd ${OUTPUT_DIR}/$CANU

# Run nucmer to map the assembled genomes (flye) against the reference genome.
nucmer -b 1000 -c 1000 -p ${CANU} ${REF_GEN} ${ASSEMBLY_CANU}

# Go to the directory where the results should be stored.
cd ${OUTPUT_DIR}/flye_canu

# Run nucmer to map the assembled genomes against each other.
nucmer -b 1000 -c 1000 -p flye_canu ${ASSEMBLY_FLYE} ${ASSEMBLY_CANU}

# nucmer [options] <reference file> <query file>
# -b int / --breaklen: Distance an alignment extension will attempt to extend poor scoring regions before giving up (default 200)
# -c int / --mincluster: Minimum cluster length (default 65)
# -p string / --prefix: Set the output file prefix (default out)