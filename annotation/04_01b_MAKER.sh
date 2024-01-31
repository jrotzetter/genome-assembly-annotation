#!/usr/bin/env bash

#SBATCH --time=2-12:00:00
#SBATCH --mem-per-cpu=12G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=MAKER
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_output_MAKER_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/04_error_MAKER_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## This script will perform homology-based genome annotation with MAKER.

## MAKER is a pipeline that allows to annotate eukaryotic genomes and create genome databases.
## It automatically compiles 1) ab initio prediction models (mathematical models describing patterns
## of intron/exon structure and consensus start/stop signals), 2) evidence of expression (RNA-Seq
## data) and 3) sequence homology to known proteins, into gene annotations.
##-------------------------------------------------------------------------------

COURSEDIR=/data/courses/assembly-annotation-course
HOMEDIR=/data/users/jrotzetter/assembly_annotation_course
WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation

cd ${WORKDIR}

# MAKER can't find the files that were specified in maker_opts.ctl even when specifying the full path.
# To avoid this problem, remember that you are running a container. To enable access to files or directories on the host system from the container
# mount a filesystem within the container. Give meaningful names to the path under which files from the host will be accessible within the container
# and use these paths in maker_opts.ctl to point MAKER in the right direction.

# export SLURM_EXPORT_ENV=ALL
# export LIBDIR=/software/SequenceAnalysis/Repeat/RepeatMasker/4.0.7/Libraries/
# export REPEATMASKER_DIR=/software/SequenceAnalysis/Repeat/RepeatMasker/4.0.7/RepeatMasker

module load SequenceAnalysis/GenePrediction/maker/2.31.9

mpiexec -n 16 singularity exec \
--bind $SCRATCH:/TMP \
--bind ${COURSEDIR} \
--bind ${COURSEDIR}/CDS_annotation:/CDS_annotation \
--bind ${HOMEDIR}:/home \
--bind /software:/software \
${COURSEDIR}/containers2/MAKER_3.01.03.sif \
maker -mpi -base run_mpi -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_exe.ctl

# mpiexec -n 16 singularity exec \
# --bind $SCRATCH:/TMP \
# --bind ${COURSEDIR}/CDS_annotation:/CDS_annotation \
# --bind ${HOMEDIR}:/home \
# --bind /software:/software \
# ${COURSEDIR}/containers2/MAKER_3.01.03.sif \
# maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_exe.ctl