#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=parseRM
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/02_output_parseRM_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/02_error_parseRM_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## parseRM
## https://github.com/4ureliek/Parsing-RepeatMasker-Outputs

## Script parses the raw alignment outputs from RepeatMasker. This process allows to use the
## corrected percentage of divergence of each copy to the consensus (accounting for the extremely
## high rate of mutations at CpG sites). Low-divergence sequences indicate recent insertions and
## higher divergence sequences suggest older insertions.
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w6_TE_dynamics/TE_dating
FILE=${WORK_DIR}/flye_polished.fasta.mod.out
parseRM=/data/users/jrotzetter/assembly_annotation_course/annotation/scripts/02_parseRM.pl

mkdir -p $WORK_DIR
cd $WORK_DIR
cp /data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/EDTA/flye_polished.fasta.mod.EDTA.anno/flye_polished.fasta.mod.out $WORK_DIR

module load Conda/miniconda/latest # load conda # conda version : 4.10.1
eval "$(conda shell.bash hook)" # Prepare the environment for Python # python version : 3.6.13.final.0

conda activate genomeAnnot # enter conda environment with perl-bioperl in it, which is needed for parseRM to run correctly

perl $parseRM -i $FILE -l 50,1 -v # uses -l <max,bin> to split the amount of DNA by bins of % divergence (or My) for each repeat
# name, family or class (one output for each). In this case: To get the numbers in bins of 1% of divergence
# to consensus, up to 50%.

OUTFILE=/data/users/jrotzetter/assembly_annotation_course/annotation/w6_TE_dynamics/flye_polished.fasta.mod.out.landscape.Div.Rname.tab

sed -i '1d;3d' $OUTFILE # remove line 1 and 3 from the output file