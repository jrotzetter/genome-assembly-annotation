#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=merqury
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/10_output_merqury_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/10_error_merqury_%j.e

##-------------------------------------------------------------------------------
## Script will evaluate the specified genome assembly with the help of k-mers. Script needs to be run for each assembly separately.
##-------------------------------------------------------------------------------

WORK_DIR=/data/users/jrotzetter/assembly_annotation_course
OUTPUT_DIR=${WORK_DIR}/assembly/w3_merqury
MERYL_DIR=${OUTPUT_DIR}/genome.meryl

# # flye unpolished
# FILE=flye
# ASSEMBLY=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_flye/pacbio/assembly.fasta

# # flye polished
# FILE=flye_polished
# ASSEMBLY=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/flye_polished.fasta

# # canu unpolished
# FILE=canu
# ASSEMBLY=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_canu/pacbio/pacbio_canu.contigs.fasta

# # canu polished
FILE=canu_polished
ASSEMBLY=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_pilon_polishing/canu_polished.fasta

mkdir -p ${OUTPUT_DIR}/${FILE}
chmod a+rwx ${ASSEMBLY}
cd ${OUTPUT_DIR}/${FILE}

apptainer exec \
--bind "${WORK_DIR}" \
/software/singularity/containers/Merqury-1.3-1.ubuntu20.sif \
merqury.sh "${MERYL_DIR}" "${ASSEMBLY}" "${FILE}"

# merqury options
# merqury.sh <read-db.meryl> [<mat.meryl> <pat.meryl>] <asm1.fasta> [asm2.fasta] <out>
#   <read-db.meryl>	: k-mer counts of the read set
# 	<mat.meryl>		: k-mer counts of the maternal haplotype (ex. mat.only.meryl or mat.hapmer.meryl)
# 	<pat.meryl>		: k-mer counts of the paternal haplotype (ex. pat.only.meryl or pat.hapmer.meryl)
# 	<asm1.fasta>	: Assembly fasta file (ex. pri.fasta, hap1.fasta or maternal.fasta)
# 	[asm2.fasta]	: Additional fasta file (ex. alt.fasta, hap2.fasta or paternal.fasta)
# 	*asm1.meryl and asm2.meryl will be generated. Avoid using the same names as the hap-mer dbs
# 	<out>		: Output prefix

#   < > : required
#   [ ] : optional