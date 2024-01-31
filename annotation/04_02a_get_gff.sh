#!/usr/bin/env bash

#SBATCH --time=0-00:10:00
#SBATCH --mem-per-cpu=1G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=get_gff
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_02a_output_get_gff_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_02a_error_get_gff_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end,fail

##-------------------------------------------------------------------------------
## This script will generate gff and fasta files from the MAKER output
##-------------------------------------------------------------------------------

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation

module load SequenceAnalysis/GenePrediction/maker/2.31.9

export TMPDIR=$SCRATCH
BASE="run_mpi"

cd ${WORKDIR}/${BASE}.maker.output

gff3_merge -d ${BASE}_master_datastore_index.log -o ${BASE}.all.maker.gff
gff3_merge -d ${BASE}_master_datastore_index.log -n -o ${BASE}.all.maker.noseq.gff
fasta_merge -d ${BASE}_master_datastore_index.log -o ${BASE}
