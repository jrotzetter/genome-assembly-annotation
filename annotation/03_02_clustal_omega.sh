#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=clustal
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_output_clustal_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_error_clustal_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## Align sequences obtained in 03_01 with clustal omega
##-------------------------------------------------------------------------------

# define working, data and output directories
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w6_TE_dynamics/phylogenetic_analysis

mkdir -p $WORK_DIR
cd $WORK_DIR

module load SequenceAnalysis/MultipleSequenceAlignment/clustal-omega/1.2.4

# align the sequences with clustal omega
clustalo -i Copia_RT.fasta -o Copia_protein_alignment.fasta
clustalo -i Gypsy_RT.fasta -o Gypsy_protein_alignment.fasta