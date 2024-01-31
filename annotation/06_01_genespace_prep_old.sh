#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=30G
#SBATCH --time=08:00:00
#SBATCH --job-name=genespace_prep
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_01_output_genespace_prep_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_01_error_genespace_prep_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Formatting input data for comparative genomics to assess sequence homology to proteins of closely related species
## using R package GENESPACE.
##-------------------------------------------------------------------------------


# Script works fine, but later seems to cause synteny problems with accession Cvi_0 when running Genespace

INPUT_DIR=/data/courses/assembly-annotation-course/CDS_annotation/Genespace
OUT_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w9_comp_genomics
PEPTIDE_DIR=${OUT_DIR}/peptide
BED_DIR=${OUT_DIR}/bed

mkdir -p ${OUT_DIR}
mkdir -p ${PEPTIDE_DIR}
mkdir -p ${BED_DIR}

cd ${OUT_DIR}

# Loop over all files in the specified directory with that match the pattern *noseq*renamed*gff
for GFF_FILE in ${INPUT_DIR}/*noseq*renamed*gff; do
if [[ -f ${GFF_FILE} ]]; then # check if the file exists and is a regular file

    # Define the base name of the files (accession)
    GFF_FILENAME=$(basename ${GFF_FILE})
    BASE=${GFF_FILENAME%.all*} # assign the value of GFF_FILENAME to the variable base, but with the suffix .all* removed (with % operator)
    # Input gff
    GFF=${GFF_FILE}
    # Input fasta
    FASTA=${INPUT_DIR}/${base}*proteins*renamed*fasta

    OUT_BED=${BED_DIR}/${BASE}.bed
    OUT_PEPTIDE=${PEPTIDE_DIR}/${BASE}.fa

    # Extract the contig lengths from the GFF file
    # In GFF format, the start and end positions of a feature are inclusive. The + 1 is added to account
    # for the inclusive end position.
    awk '$3 == "contig" { print $1, $5 - $4 + 1 }' ${GFF} \
        | sort -k2nr \
        | head -n 10 > ${BASE}_longest_contigs.txt
        # sorts the contigs based on their numeric (-n) lengths in the second field of the output (-k2) in descending order (-r)
        # and selects the top 10 longest contigs from the sorted list

    # This command will output the 10 longest contigs from the GFF file, along with their lengths.

    # Create the bed file
    awk '$3 == "mRNA"' ${GFF} | cut -f 1,4,5,9 | sed 's/ID=//' | \
    sed 's/;.\+//' | grep -w -f <(cut -f 1 -d ' ' ${BASE}_longest_contigs.txt) > ${OUT_BED}

    # use process substitution <(...) to specify which column of longest_contigs.txt to use with grep

    # Create the fa file

    # Read the fourth column of the input file and store gene IDs in an array
    GENE_IDS=($(awk '{print $4}' ${OUT_BED}))

    # Iterate over the gene names and extract the corresponding protein sequences
    for GENE_ID in "${GENE_IDS[@]}"; do
        awk -v GENE_ID="${GENE_ID}" -v RS='>' '$1 == GENE_ID {print ">"$0}' ${FASTA}
    done | sed 's/ .\+//;/^$/d' > ${OUT_PEPTIDE}

    # The record separator RS is set to '>', indicating that each block of text starting with a > character should be treated as a separate record.
    # By default, awk treats each line as a record and uses the newline character (\n) as the record separator. The next part is the awk script that
    # is executed for each record. It checks if the first field ($1) is equal to the GENE_ID variable and if so, it prints the record with a > character prepended to it.

    # sed 's/ .\+//;/^$/d' > ${OUT_PEPTIDE} # substitutes any occurrence of a space followed by one or more characters (s/ .\+//),
    # effectively removing everything after this part until the end of the line, so be careful! It also deletes any lines in the
    # ${OUT_PEPTIDE} file that are empty (/^$/d). The changes are made directly to the file itself due to the -i option.
fi
done