#!/usr/bin/env bash

#SBATCH --time=0-00:10:00
#SBATCH --mem-per-cpu=1G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=MAKERprep
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_output_MAKERprep_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_error_MAKERprep_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end,fail

##-------------------------------------------------------------------------------
## Script to create MAKER control files
##-------------------------------------------------------------------------------

# run this script to create the control files with this specific MAKER version, then edit the control
# files as instructed (using the mounted paths from the container as specified in 04_01b_Maker.sh) and subsequently run the MAKER script afterwards

COURSEDIR=/data/courses/assembly-annotation-course
WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation
mkdir -p ${WORKDIR}
cd ${WORKDIR}

singularity exec \
--bind $SCRATCH \
--bind ${COURSEDIR} \
--bind ${WORKDIR} \
${COURSEDIR}/containers2/MAKER_3.01.03.sif \
maker -CTL