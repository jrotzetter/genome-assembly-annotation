#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=busco
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/08_busco%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/08_busco%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Script will run BUSCO on specified genomes for quality and completeness assessment
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly
EVAL_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_evaluation

# for flye
mkdir -p $EVAL_DIR/flye

# for canu
mkdir -p $EVAL_DIR/canu

# for trinity
mkdir -p $EVAL_DIR/trinity

# IMPORTANT: to run busco, you must first make a copy of the augustus config directory
#            to a location where you have write permission (e.g. your working dir).
#            You can use the following commands:
#            cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config <PATH>/augustus_config

module load UHTS/Analysis/busco/4.1.4
export AUGUSTUS_CONFIG_PATH=${EVAL_DIR}/augustus_config

# run busco for flye assembly (unpolished and polished)
busco -i "$WORK_DIR"/w2_flye/pacbio/assembly.fasta -l brassicales_odb10 -o flye -m genome --cpu 4 -f --out_path ${EVAL_DIR}
busco -i "$WORK_DIR"/w3_pilon_polishing/flye_polished.fasta -l brassicales_odb10 -o flye_polished -m genome --cpu 4 -f --out_path ${EVAL_DIR}
# BUSCO version 4.1.4 options:
# -i or --in: defines the input file to analyse which is either a nucleotide fasta file or a protein fasta file, depending on the BUSCO mode.
# -o or --out: Give your analysis run a recognisable short name. Output folders and files will be labelled with this name. WARNING: do not provide a path
# -m or --mode: sets the assessment MODE: genome, proteins, transcriptome
# -l or --lineage_dataset
# --cpu <N>: Specify the number (N=integer) of threads/cores to use.
# -f, --force: Force rewriting of existing files. Must be used when output files with the provided name already exist.
#--out_path <OUTPUT_PATH>: Optional location for results folder, excluding results folder name. Default is current working directory.

# run busco for canu assembly (unpolished and polished)
busco -i "$WORK_DIR"/w2_canu/pacbio/pacbio_canu.contigs.fasta -l brassicales_odb10 -o canu -m genome --cpu 4 -f --out_path ${EVAL_DIR}
busco -i "$WORK_DIR"/w3_pilon_polishing/canu_polished.fasta -l brassicales_odb10 -o canu_polished -m genome --cpu 4 -f --out_path ${EVAL_DIR}

# run busco for unpolished trinity assembly
busco -i "$WORK_DIR"/w2_trinity/Trinity.fasta -l brassicales_odb10 -o trinity -m transcriptome --cpu 4 -f --out_path ${EVAL_DIR}