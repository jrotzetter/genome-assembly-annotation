#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=48G
#SBATCH --cpus-per-task=12
#SBATCH --partition=pall
#SBATCH --job-name=bowtie2
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/06_bowtie2_alignment_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/assembly/logs/06_bowtie2_alignment_%j.e

##-------------------------------------------------------------------------------
## Script will align the Illumina short reads to the assemblies obtained with 03_flye.sh, 04_canu.sh and 05_trinity.sh
##-------------------------------------------------------------------------------

READS_DIR=/data/users/jrotzetter/assembly_annotation_course/participant_5
OUTPUT_DIR=/data/users/jrotzetter/assembly_annotation_course/assembly/w3_bowtie2_alignment

mkdir -p "$OUTPUT_DIR"/indices_flye/
mkdir -p "$OUTPUT_DIR"/indices_canu/

module add UHTS/Aligner/bowtie2/2.3.4.1
module load UHTS/Analysis/samtools/1.10

FLYE=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_flye/pacbio/assembly.fasta
CANU=/data/users/jrotzetter/assembly_annotation_course/assembly/w2_canu/pacbio/pacbio_canu.contigs.fasta

# potentially trim Illumina reads before alignment in case adapter contamination is present
READ1="$READS_DIR"/Illumina/ERR3624579_1.fastq.gz
READ2="$READS_DIR"/Illumina/ERR3624579_2.fastq.gz

# builds assembly index with high quality reads
bowtie2-build --threads 4 $FLYE "$OUTPUT_DIR"/indices_flye/flye

bowtie2-build --threads 4 $CANU "$OUTPUT_DIR"/indices_canu/canu

# align Illumina short reads to specified assembly with bowtie2
bowtie2 -p 4 --sensitive-local -x "$OUTPUT_DIR"/indices_flye/flye -1 $READ1 -2 $READ2 -S $SCRATCH/flye.sam

bowtie2 -p 4 --sensitive-local -x "$OUTPUT_DIR"/indices_canu/canu -1 $READ1 -2 $READ2 -S $SCRATCH/canu.sam
# bowtie2 options:
# -p/--threads: Launch NTHREADS parallel search threads (default: 1)
# --sensitive-local preset. Same as: -D 15 -R 2 -N 0 -L 20 -i S,1,0.75 (default in --local mode)
# -x <bt2-idx>: The basename of the index for the reference genome
# -1 <m1>: Comma-separated list of files containing mate 1s (filename usually includes _1)
# -2 <m2>: Comma-separated list of files containing mate 2s (filename usually includes _2)
# -S <sam>: File to write SAM alignments to.
# $SCRATCH: store output in temporary SCRATCH directory as to not store it directly on the data drive

# Convert SAM file to BAM file using samtools
samtools view -bS $SCRATCH/flye.sam > $SCRATCH/flye.bam

samtools view -bS $SCRATCH/canu.sam > $SCRATCH/canu.bam

# move bam files from SCRATCH to target directory
mv $SCRATCH/{flye.bam,canu.bam} -t $OUTPUT_DIR
