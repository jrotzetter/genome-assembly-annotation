#!/usr/bin/env bash

#SBATCH --time=01:00:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=busco_plots
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/08_busco_plots%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/08_busco_plots%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Script will generate bar charts to summarise BUSCO runs for side-by-side comparisons
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_evaluation

mkdir "$WORK_DIR"/BUSCO_summaries

cp ${WORK_DIR}/canu/short_summary.*.brassicales_odb10.canu.txt ${WORK_DIR}/BUSCO_summaries/.
cp ${WORK_DIR}/canu_polished/short_summary.*.brassicales_odb10.canu_polished.txt ${WORK_DIR}/BUSCO_summaries/.
cp ${WORK_DIR}/flye/short_summary.*.brassicales_odb10.flye.txt ${WORK_DIR}/BUSCO_summaries/.
cp ${WORK_DIR}/flye_polished/short_summary.*.brassicales_odb10.flye_polished.txt ${WORK_DIR}/BUSCO_summaries/.
cp ${WORK_DIR}/trinity/short_summary.specific.brassicales_odb10.trinity.txt ${WORK_DIR}/BUSCO_summaries/.

module load UHTS/Analysis/busco/4.1.4

# Generate plots and R script from BUSCO results
python3 /data/users/jrotzetter/assembly_annotation_course/assembly/scripts/08_generate_plot.py -wd ${WORK_DIR}/BUSCO_summaries