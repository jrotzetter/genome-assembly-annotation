#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=quast
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/09_quast%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/09_quast%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Script will evaluate genome assembly using QUAST (QUality Assessment Tool for genome assemblies)
##-------------------------------------------------------------------------------

EVAL_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_evaluation
OUTPUT_DIR="$EVAL_DIR"/quast
REF_GEN=/data/courses/assembly-annotation-course/references

FLYE=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_flye/pacbio/assembly.fasta
FLYE_P=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/flye_polished.fasta

CANU=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_canu/pacbio/pacbio_canu.contigs.fasta
CANU_P=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/canu_polished.fasta

# mkdir -p ${OUTPUT_DIR}/flye_ref
# mkdir -p ${OUTPUT_DIR}/flye_no_ref
# mkdir -p ${OUTPUT_DIR}/canu_ref
# mkdir -p ${OUTPUT_DIR}/canu_no_ref

# to run everything together
mkdir -p ${OUTPUT_DIR}/ref
mkdir -p ${OUTPUT_DIR}/no_ref

module load UHTS/Quality_control/quast/4.6.0

# Evaluate genome assembly using QUAST (version 4.6.0)
# with reference
python /software/UHTS/Quality_control/quast/4.6.0/quast.py -R ${REF_GEN}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
-o ${OUTPUT_DIR}/ref -l flye,flye_polished,canu,canu_polished $FLYE $FLYE_P $CANU $CANU_P --eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 4
#--features ${REF_GEN}/TAIR10_GFF3_genes.gff

# without reference
python /software/UHTS/Quality_control/quast/4.6.0/quast.py -o ${OUTPUT_DIR}/no_ref -l flye_no_ref,flye_polished_no_ref,canu_no_ref,canu_polished_no_ref $FLYE $FLYE_P $CANU $CANU_P \
--eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 4 --est-ref-size 133725193

# # with reference for flye only
# python /software/UHTS/Quality_control/quast/4.6.0/quast.py -R ${REF_GEN}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
# -o ${OUTPUT_DIR}/flye_ref -l flye,flye_polished $FLYE $FLYE_P --eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 4
# #--features ${REF_GEN}/TAIR10_GFF3_genes.gff

# # without reference for flye only
# python /software/UHTS/Quality_control/quast/4.6.0/quast.py -o ${OUTPUT_DIR}/flye_no_ref -l flye_no_ref,flye_polished_no_ref $FLYE $FLYE_P --eukaryote \
# --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 4 --est-ref-size 133725193
# Options:
# -o <output_dir>: Output directory. The default value is quast_results/results_<date_time>.
# -r <path>: Reference genome file. Optional.
# --labels (or -l) <label,label...>: Human-readable assembly names. Those names will be used in reports, plots and logs.
# -L: Take assembly names from their parent directory names.
# --features (or -g) <path>: File with genomic feature positions in the reference genome. GFF format, versions 2 and 3 => NOT SUPPORTED by Quast 4.6.0
# --eukaryote (or -e): Genome is eukaryotic.
# --large: Genome is large (typically > 100 Mbp). Imposes --eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 options => NOT SUPPORTED by Quast 4.6.0
# --threads (or -t) <int>: Maximum number of threads. The default value is 25% of all available CPUs but not less than 1.
# If QUAST fails to determine the number of CPUs, maximum threads number is set to 4.
# --est-ref-size <int>: Estimated reference genome size (in bp) for computing NGx statistics. This value will be used only if a reference genome file is not specified (see -r option).

# # with reference for canu only
# python /software/UHTS/Quality_control/quast/4.6.0/quast.py -R ${REF_GEN}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
# -o ${OUTPUT_DIR}/canu_ref -l canu,canu_polished $CANU $CANU_P --eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 4
# #--features ${REF_GEN}/TAIR10_GFF3_genes.gff

# # without reference for canu only
# python /software/UHTS/Quality_control/quast/4.6.0/quast.py -o ${OUTPUT_DIR}/canu_no_ref -l canu_no_ref,canu_polished_no_ref $CANU $CANU_P --eukaryote \
# --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 --threads 4 --est-ref-size 133725193
