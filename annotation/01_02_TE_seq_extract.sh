#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00
#SBATCH --job-name=seqkit_grep
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/01_output_seqkit_grep_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/01_error_seqkit_grep_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will filter a non-redundant TE library obtained from EDTA based on a query entry and store
## it in a new fasta file. Each sequence can be considered as a TE family.
##-------------------------------------------------------------------------------

# load the needed module(s)
module load UHTS/Analysis/SeqKit/0.13.2

# define working, data and output directories
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/TEsorter
# TElib=$genome.mod.EDTA.TElib.fa
FILE=/data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/EDTA/flye_polished.fasta.mod.EDTA.TElib.fa
QUERY_C=Copia
QUERY_G=Gypsy

mkdir -p $WORK_DIR
cd $WORK_DIR

# subset TElibrary into only the QUERY superfamily
seqkit grep -r -p $QUERY_C $FILE -o $QUERY_C.fa

seqkit grep -r -p $QUERY_G $FILE -o $QUERY_G.fa