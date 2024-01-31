#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=mummerplot
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/12_output_mummerplot_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/12_error_mummerplot_%j.e

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w4_comparison
OUTPUT_DIR=${WORK_DIR}/mummerplot
INPUT_DIR=${WORK_DIR}/nucmer

FLYE_INPUT=${INPUT_DIR}/flye/flye.delta
CANU_INPUT=${INPUT_DIR}/canu/canu.delta
FLYE_CANU_INPUT=${INPUT_DIR}/flye_canu/flye_canu.delta

# import gnuplot otherwise mummerplot will not generate the png files
export PATH=/software/bin:$PATH
# load the module
module add UHTS/Analysis/mummer/4.0.0beta1

mkdir -p "$WORK_DIR"
mkdir -p "$OUTPUT_DIR"
mkdir -p ${OUTPUT_DIR}/flye
mkdir -p ${OUTPUT_DIR}/canu
mkdir -p ${OUTPUT_DIR}/flye_canu

# reference genome
REF_GEN=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

ASSEMBLY_FLYE=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/flye_polished.fasta
ASSEMBLY_CANU=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/canu_polished.fasta

# Go to the directory where the results should be stored.
cd ${OUTPUT_DIR}/flye

# Run mummerplot to create dotplot of the assembled genomes (flye) against the reference genome.
mummerplot -f -l -p flye -R ${REF_GEN} -Q ${ASSEMBLY_FLYE} --large -t png ${FLYE_INPUT}

# Go to the directory where the results should be stored.
cd ${OUTPUT_DIR}/canu

# Run mummerplot to create dotplot of the assembled genomes (canu) against the reference genome.
mummerplot -f -l -p canu -R ${REF_GEN} -Q ${ASSEMBLY_CANU} --large -t png ${CANU_INPUT}

# Go to the directory where the results should be stored.
cd ${OUTPUT_DIR}/flye_canu

# Run mummerplot to create dotplot of the assembled genomes against each other.
mummerplot -f -l -p flye_canu -R ${ASSEMBLY_FLYE} -Q ${ASSEMBLY_CANU} --large -t png ${FLYE_CANU_INPUT}

# mummerplot [options] <match file>
# -f / --filter: Only display alignments which represent the "best" one-to-one mapping of reference and query subsequences (requires delta formatted input)
# -l / --layout: Layout a multiplot by ordering and orienting sequences such that the largest hits cluster near the main diagonal (requires delta formatted input)
# -p string / --prefix: Set the output file prefix (default 'out')
# -R string / --Rfile: Generate a multiplot by using the order and length information contained in this file, either a FastA file of the desired reference sequences or
# a tab-delimited list of sequence IDs, lengths and orientations [ +-]
# -Q string / --Qfile: Generate a multiplot by using the order and length information contained in this file, either a FastA file of the desired query sequences or
# a tab-delimited list of sequence IDs, lengths and orientations [ +-]
# -s string / --size: Set the output size to small, medium or large
# --small --medium --large (default 'small')
# -S / --SNP: Highlight SNP locations in the alignment
# -t string / --terminal: Set the output terminal to x11, postscript or png
# --x11 --postscript --png