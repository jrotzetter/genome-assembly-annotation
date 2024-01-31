#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=fastTree
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_output_fastTree_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_error_fastTree_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## create a phylogenetic tree with FastTree (approximately-maximum-likelihood)
##-------------------------------------------------------------------------------

# define working, data and output directories
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w6_TE_dynamics/phylogenetic_analysis

mkdir -p $WORK_DIR
cd $WORK_DIR

module load Phylogeny/FastTree/2.1.10

# create a phylogenetic tree with FastTree (approximately-maximum-likelihood)
FastTree -out Copia_protein_alignment.tree Copia_protein_alignment.fasta
FastTree -out Gypsy_protein_alignment.tree Gypsy_protein_alignment.fasta