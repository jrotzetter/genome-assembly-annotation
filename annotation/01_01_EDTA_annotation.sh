#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=EDTA_annotation
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/01_output_EDTA_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/01_error_EDTA_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## EDTA - The Extensive de novo TE Annotator -
## EDTA is a pipeline that produces a filtered non-redundant TE library for annotation of structurally
## intact and fragmented elements.
## https://github.com/oushujun/EDTA
##-------------------------------------------------------------------------------

# Script was taken and adapted from group member qcoxon

#--- setting up directories
COURSEDIR=/data/courses/assembly-annotation-course
WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/EDTA
CDS=/data/courses/assembly-annotation-course/CDS_annotation/TAIR10_cds_20110103_representative_gene_model_updated 

mkdir -p /data/users/jrotzetter/assembly_annotation_course/annotation
mkdir -p ${WORKDIR}

#--- entering WORKDIR
cd $WORKDIR

#--- adding genome to WORKDIR 
cp /data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/flye_polished.fasta .
ASSEMBLY=${WORKDIR}/flye_polished.fasta

#--- running EDTA from Singularity container
singularity exec \
--bind $COURSEDIR \
--bind $WORKDIR \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
  --genome $ASSEMBLY  \
  --species others \
  --step all \
  --cds $CDS \
  --anno 1 \
  --threads 50   # Number of threads to run this script (default: 4)

# EDTA Options:
# --genome [File] # The genome FASTA \
# --species others \
# --step all \
# --cds [File] # The coding sequences FASTA \
# --anno 1 # perform whole-genome TE annotation after TE library construction \
# --threads|-t [int] # Number of threads to run this script (default: 4)