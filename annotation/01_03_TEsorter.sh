#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=TEsorter
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/01_output_TEsorter_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/01_error_TEsorter_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## TEsorter performs clade-level classification of Class I TEs (or retrotransposons, RTs).
## https://github.com/zhangrengang/TEsorter
##-------------------------------------------------------------------------------

# Usage: <script_name>.sh <filename>

# run this script three times:
# once on Copia.fa, once on Gypsy.fa and once on 
# /data/courses/assembly-annotation-course/CDS_annotation/Brassicaceae_repbase_all_march2019.fasta

#--- setting up directories 
COURSE_DIR=/data/courses/assembly-annotation-course
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/TEsorter

mkdir -p ${WORK_DIR}
cd $WORK_DIR

#--- running TEsorter from Singularity container 
singularity exec \
--bind $COURSE_DIR \
--bind $WORK_DIR \
${COURSE_DIR}/containers2/TEsorter_1.3.0.sif \
TEsorter $1 -db rexdb-plant