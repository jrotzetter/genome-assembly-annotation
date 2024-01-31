#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=map_protfun
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_02b_map_protfun%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_02b_map_protfun%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will map the protein putative functions to the MAKER produced GFF3 and FASTA files
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w8_Annotation_QC
UNIPROT_DB=/data/courses/assembly-annotation-course/CDS_annotation/uniprot-plant_reviewed.fasta
FILE_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation/run_mpi.maker.output
BASE="run_mpi"

cd ${WORK_DIR}

module load SequenceAnalysis/GenePrediction/maker/2.31.9;

cp ${FILE_DIR}/${BASE}.all.maker.proteins.renamed.fasta ${WORK_DIR}/${BASE}.all.maker.proteins.renamed.fasta.Uniprot
cp ${FILE_DIR}/${BASE}.all.maker.noseq.renamed.gff ${WORK_DIR}/${BASE}.all.maker.noseq.renamed.gff.Uniprot

maker_functional_fasta ${UNIPROT_DB} blastp_output ${WORK_DIR}/${BASE}.all.maker.proteins.renamed.fasta.Uniprot
maker_functional_gff ${UNIPROT_DB} blastp_output ${WORK_DIR}/${BASE}.all.maker.noseq.renamed.gff.Uniprot