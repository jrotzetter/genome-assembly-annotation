#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=blast_prot
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_02a_blast_prot%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_02a_blast_prot%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will align the MAKER annotated proteins against those found in the UniProt database
## (uniprot-plant_reviewed.fasta), containing sequences of functionally validated proteins with known functions.
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w8_Annotation_QC
UNIPROT_DB=/data/courses/assembly-annotation-course/CDS_annotation/uniprot-plant_reviewed.fasta
FILE_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation/run_mpi.maker.output
BASE="run_mpi"

cd ${WORK_DIR}

module load Blast/ncbi-blast/2.10.1+;

makeblastdb -in ${UNIPROT_DB} -dbtype prot -out uniprot-plant_reviewed
blastp -query ${FILE_DIR}/${BASE}.all.maker.proteins.renamed.fasta \
-db uniprot-plant_reviewed -num_threads 10 -outfmt 6 -evalue 1e-10 \
-out blastp_output