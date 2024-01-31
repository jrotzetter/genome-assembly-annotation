#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=iTOL_prep
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_output_iTOL_prep_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_error_iTOL_prep_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## This script will prepare a colored strip and simple bar chart dataset for iTOL annotation for a TE superfamily phylogenetic tree.
##-------------------------------------------------------------------------------

# In colored strip datasets, each tree node is associated to a color definition which is displayed as a filled rectangle outside the tree,
# and can have an optional label (shown in the popup when hovering over the colored rectangle). Similar to all other color definitions in iTOL,
# the color can be specified in hexadecimal, RGB or RGBA notation (if transparency is required). https://itol.embl.de/help.cgi#strip

# In simple bar chart datasets, each tree node is associated to a single numeric value which is displayed as a bar outside the tree. https://itol.embl.de/help.cgi#bar

WORKDIR=/data/users/jrotzetter/assembly_annotation_course/annotation
EDTA_SUMMARY=${WORKDIR}/w5_TE_annotation/EDTA/flye_polished.fasta.mod.EDTA.TEanno.sum # from EDTA
OUTDIR=${WORKDIR}/w6_TE_dynamics/phylogenetic_analysis

cd ${OUTDIR}

SUPERFAMILIES=("Copia" "Gypsy")

for SUPERFAMILY in "${SUPERFAMILIES[@]}"
do
        CLASS_FILE=${WORKDIR}/w5_TE_annotation/TEsorter/${SUPERFAMILY}.fa.rexdb-plant.cls.tsv # TEs/LTR-RTs classifications from TEsorter
        RT_PROT=${WORKDIR}/w6_TE_dynamics/phylogenetic_analysis/${SUPERFAMILY}_RT.fasta
        DATASET_COLORSTRIP=${WORKDIR}/w6_TE_dynamics/phylogenetic_analysis/${SUPERFAMILY}_dataset_color_strip.txt
        DATASET_SIMPLEBAR=${WORKDIR}/w6_TE_dynamics/phylogenetic_analysis/${SUPERFAMILY}_dataset_simplebar.txt


        # Preparation steps to highlight TE clades
        # =======================================================================================

        # DATASET_COLORSTRIP follows the pattern: TE_family                 hex_color_code  Clade
        #                                         TE_00000525_INT#LTR/Gypsy #FF0000         Reina

        declare -A clade_color # declare a dictionary variable (meaning "associative array")

        # The awk command 'BEGIN' is a special pattern that is executed before any input is read. It is typically used to perform initialization or setup tasks
        # before processing the input data. The code within the 'BEGIN' block is executed once at the beginning of the awk command. After the 'BEGIN' block,
        # there is a code block enclosed in curly braces with {print $1,clade_color[$4],$4} inside. This code block is executed for each line of input, i.e. CLASS_FILE.
        # $1, $4 are the column numbers in the CLASS_FILE. The idea is to give each clade a specific color and add each TE with its corresponding clade color to the DATASET_COLORSTRIP file.
        # The BEGIN block is divided into two parts: first Copia, then Gypsy (list obtained with 03_04_get_clades.sh).
        awk 'BEGIN{
                clade_color["Ale"]="#003f5c"
                clade_color["Alesia"]="#2f4b7c"
                clade_color["Angela"]="#665191"
                clade_color["Bianca"]="#a05195"
                clade_color["Ikeros"]="#d45087"
                clade_color["Ivana"]="#f95d6a"
                clade_color["SIRE"]="#ff7c43"
                clade_color["Tork"]="#ffa600"

                clade_color["Athila"]="#003f5c"
                clade_color["CRM"]="#444e86"
                clade_color["Reina"]="#955196"
                clade_color["Retand"]="#dd5182"
                clade_color["Tekay"]="#ff6e54"
                clade_color["unknown"]="#ffa600"
        }{
                print $1,clade_color[$4],$4
        }' ${CLASS_FILE} >> ${DATASET_COLORSTRIP} # append to DATASET_COLORSTRIP to not overwrite the settings.


        # Preparation steps to annotate the tree with the abundance (number of TE copies) of each TE families
        # =======================================================================================

        # Have to use ${SUPERFAMILY}_RT.fasta not ${SUPERFAMILY}.fa.rexdb-plant.cls.tsv, because that file contains all TEs/LTR-RTs classifications from TEsorter, not just
        # those with the target RT protein sequences (Ty1-RT in Copia and Ty3-RT in Gypsy), which is the case in ${SUPERFAMILY}_RT.fasta.

        # Will search the contents of the specified file ${RT_PROT} for lines that match the pattern "TE_" followed by at least 8 digits and ending with "_INT".
        # Only the matched parts of the lines will be saved to the file "TE_IDs.txt". This file then contains the superfamily-specific TE IDs which had the targeted
        # RT protein sequence (Ty1-RT in Copia and Ty3-RT in Gypsy).
        grep -Eo "TE_[0-9]{8,}_INT" ${RT_PROT} > ${SUPERFAMILY}_TE_IDs.txt

        # DATASET_SIMPLEBAR follows the pattern: TE_family,family_size
        #                                        TE_00000525_INT#LTR/Gypsy,11

        # Retrieve the count of each TE in TE_IDs.txt from the EDTA summary, then store the count of each TE in the DATASET_SIMPLEBAR for iTOL annotation
        awk 'NR==FNR{a[$1]; next} $1 in a {print $1, $2}' ${SUPERFAMILY}_TE_IDs.txt ${EDTA_SUMMARY} | \
        awk -v VAR=${SUPERFAMILY} '{print $1 "#LTR/" VAR "," $2}' \
        >> ${DATASET_SIMPLEBAR}
done
        # A few more details for the two awk commands above: The first part of this awk command reads data from two input files (${WORKDIR}/TE_IDs.txt
        # and ${EDTA_SUMMARY}). For the first file,it creates an associative array "a" using the first field of each line as the index. NR represents the
        # total number of records (lines) processed so far, and FNR represents the number of records processed in the current file. For the second file,
        # it checks if the first field exists in the array "a" and prints the first and second fields of the line if the condition is true. The second
        # awk command takes the output of the previous awk command as input, formats it by concatenating the first field, the string "#LTR/", the value of
        # the variable VAR, a comma, and the second field, and then appends the formatted output to the file ${DATASET_SIMPLEBAR}.