#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=parse_orthofinder
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_03_output_parse_orthofinder_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_03_error_parse_orthofinder_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## This script will visualize Orthofinder summary statistics. Visualizing the percentage of genes in orthogroups is
## particularly useful for quality check, since one would usually expect a large percentage of genes in orthogroups,
## unless there is a very distant species in OrthoFinder’s input proteome data.
##-------------------------------------------------------------------------------


# =============================================================================
# NOTE: the first half of the R script generates the plots just fine, however the second part ### 2) Plot co-occurrence of Orthogroups does not execute correctly
# likely due to some package being outdated and upset() not finding the correct summary function, returning << Warning: Ignoring unknown parameters: fun
# No summary function supplied, defaulting to `mean_se() >>, resulting in a plot where the barcharts are missing

# ==>> execute the R script with all required files locally on a PC (don't forget to comment/ uncomment the corresponding lines and to specify the file paths!)
# ==============================================================================

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w9_comp_genomics
SCRIPT=/data/users/jrotzetter/assembly_annotation_course/annotation/scripts/06_03_Parse_Orthofinder.R
OUT_DIR=${WORKDIR}/parse_orthofinder

mkdir -p ${OUT_DIR}

cd ${OUT_DIR}

module load R/latest

STATS=${WORKDIR}/orthofinder/Results_Nov17/Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv
ORTHOGROUPS=${WORKDIR}/orthofinder/Results_Nov17/Orthogroups/Orthogroups.GeneCount.tsv

# apparently R CMD BATCH is no longer preferred but it will create an <script name>.Rout file includes both the commands and output (including errors) along with some runtime stats
# R CMD BATCH --no-save --no-restore "--args $OUT_DIR $STATS $ORTHOGROUPS" ${SCRIPT}

# Call the R script and pass the file paths as arguments, this way they do not have to be changed in the R script itself
Rscript --no-save --no-restore ${SCRIPT} "$OUT_DIR" "$STATS" "$ORTHOGROUPS"