#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=busco_plot
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_01b_busco_plot%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_01b_busco_plot%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## script will generate bar charts to summarise BUSCO runs for side-by-side comparisons
##-------------------------------------------------------------------------------

# WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation
WORK_DIR=/data/courses/assembly-annotation-course/CDS_annotation/busco
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w8_Annotation_QC/busco_comparison

mkdir -p ${OUTPUT_DIR}

cd ${WORK_DIR}

# ln -sf ${WORK_DIR}/w8_Annotation_QC/maker_annotation/short_summary.specific.brassicales_odb10.maker_annotation.txt ${OUTPUT_DIR}/.
# ln -sf /data/users/jrotzetter/assembly_annotation_course/assembly/w3_evaluation/flye_polished/short_summary.specific.brassicales_odb10.flye_polished.txt ${OUTPUT_DIR}/.

module load UHTS/Analysis/busco/4.1.4

# Generate plots and R script from BUSCO results
python3 /data/users/jrotzetter/assembly_annotation_course/assembly/scripts/08_generate_plot.py -wd ${WORK_DIR}

mv busco_figure.png busco_figure.R busco_*.log -t ${OUTPUT_DIR}