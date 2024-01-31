#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=6G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=blast_vis
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_02a_blast_vis%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/05_02a_blast_vis%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Script will get all BLAST+ annotated proteins, filter them for sequence percentage identity
## greater or equal to 98%, then run the specified R script to visualize the number of protein
## genes that were homologous with a Venn diagram.
##-------------------------------------------------------------------------------


# blastp was run with -outfmt 6, meaning the output file has the format:
# query_id	subject_id	per_identity	aln_length	mismatches	gap_openings	q_start	q_end	s_start	s_end	e-value	bit_score

# In this format…

# query_id is the FASTA header of the sequence being searched against the database (the query sequence).
# subject_id is the FASTA header of the sequence in the database that the query sequence has been aligned to (the subject sequence).
# per_identity is the percentage identity- the extent to which the query and subject sequences have the same residues at the same positions.
# aln_length is the alignment length.
# mismatches is the number of mismatches.
# gap_openings is the number of gap openings in the alignment.
# q_start is the start of the alignment in the query sequence.
# q_end is the end of the alignment in the query sequence.
# s_start is the start of the alignment in the subject sequence.
# s_end is the end of the alignment in the subject sequence.
# e_value is the expect value (E-value) for the alignment.
# bit_score is the bit-score of the alignment.
# from: https://rnnh.github.io/bioinfo-notebook/docs/blast.html

# cut -f 1 w8_Annotation_QC/blastp_output | sort -u | wc -l
# cut -f 1 w8_Annotation_QC/blastp_filtered.tsv | sort -u | wc -l

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w8_Annotation_QC
SCRIPT=/data/users/jrotzetter/assembly_annotation_course/annotation/scripts/05_02a_02_blast_visualisation.R
PROT=/data/users/jrotzetter/assembly_annotation_course/annotation/w7_annotation/run_mpi.maker.output/run_mpi.all.maker.proteins.renamed.fasta

cd ${WORKDIR}

grep -Eo "run_mpi_[0-9]{6,}-RA" ${PROT} > annotated_proteins.txt

# checks if the value in the third column (which represents the percentage identity) is greater than or equal to 98. If it is, the corresponding line is printed to the output file.
awk '$3 >= 98' blastp_output > blastp_filtered.tsv

module load R/latest

Rscript --no-save --no-restore ${SCRIPT}