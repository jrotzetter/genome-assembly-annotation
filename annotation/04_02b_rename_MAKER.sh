#!/usr/bin/env bash

#SBATCH --time=0-00:10:00
#SBATCH --mem-per-cpu=1G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=rename_MAKER
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_02b_output_rename_MAKER_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_02b_error_rename_MAKER_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end,fail

##-------------------------------------------------------------------------------
## This script will build shorter IDs and map them to MAKER fasta and gff files (because MAKER has really long IDs)
##-------------------------------------------------------------------------------

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation

module load SequenceAnalysis/GenePrediction/maker/2.31.9
BASE="run_mpi"

cd ${WORKDIR}/${BASE}.maker.output

protein=${BASE}.all.maker.proteins
transcript=${BASE}.all.maker.transcripts
gff=${BASE}.all.maker.noseq
prefix=${BASE}_

cp ${gff}.gff ${gff}.renamed.gff
cp ${protein}.fasta ${protein}.renamed.fasta
cp ${transcript}.fasta ${transcript}.renamed.fasta

maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > ${BASE}.id.map
map_gff_ids ${BASE}.id.map ${gff}.renamed.gff
map_fasta_ids ${BASE}.id.map ${protein}.renamed.fasta
map_fasta_ids ${BASE}.id.map ${transcript}.renamed.fasta
