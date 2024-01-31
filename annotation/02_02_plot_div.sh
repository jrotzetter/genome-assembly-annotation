#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=plot_div
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/02_output_plot_div_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/02_error_plot_div_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## Script to date the divergence and to generate a landscape graph for TE superfamilies.
##-------------------------------------------------------------------------------

SCRIPT=/data/users/jrotzetter/assembly_annotation_course/annotation/scripts/02_plot_div.R

module load R/latest # R version 3.6.1 (2019-07-05)

R CMD BATCH --no-save --no-restore ${SCRIPT}