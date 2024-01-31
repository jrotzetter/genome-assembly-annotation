#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=get_clades
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_error_get_clades_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## Script will extract all uniqe clades from the TEsorter file
##-------------------------------------------------------------------------------

# This command will use awk to specify the tab delimiter (-F '\t'), and then print the values from the specified column 'NR>1 {print $COLUMN_NUMBER}'.
# NR>1 specifies that the action {print $4} should only be performed for records (lines) where the line number (NR) is greater than 1.
# This effectively skips the first line, assuming it contains the column names, otherwise remove this part from the command.
# The extracted column is then sorted in ascending order and any duplicate values are removed,
# returning a list of unique values from that column.

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/
OUTDIR=${WORKDIR}/w6_TE_dynamics/phylogenetic_analysis
cd ${OUTDIR}

SUPERFAMILIES=("Copia" "Gypsy")

for SUPERFAMILY in "${SUPERFAMILIES[@]}"
do
    FILE_NAME=${WORKDIR}/w5_TE_annotation/TEsorter/${SUPERFAMILY}.fa.rexdb-plant.cls.tsv

    awk -F '\t' 'NR>1 {print $4}' $FILE_NAME | sort | uniq >> ${SUPERFAMILY}_uniq_clades.txt
done