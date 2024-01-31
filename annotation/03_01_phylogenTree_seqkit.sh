#!/usr/bin/env bash

#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=seqkit
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_output_seqkit_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/03_error_seqkit_%j.e
#SBATCH --partition=pall
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=end

##-------------------------------------------------------------------------------
## Script will extract specified RT protein sequences from fasta files
##-------------------------------------------------------------------------------

# load the needed module(s)
module load UHTS/Analysis/SeqKit/0.13.2

# define working, data and output directories
WORK_DIR=/data/users/jrotzetter/assembly_annotation_course/annotation/w6_TE_dynamics/phylogenetic_analysis

COPIA=/data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/TEsorter/Copia.fa.rexdb-plant.dom.faa
GYPSY=/data/users/jrotzetter/assembly_annotation_course/annotation/w5_TE_annotation/TEsorter/Gypsy.fa.rexdb-plant.dom.faa

mkdir -p $WORK_DIR
cd $WORK_DIR

# Function for some reason creates empty files
# RT_extract(){
# # Extract RT protein sequences
# grep $1 $2 > $3 #make a list of RT proteins to extract
# sed -i 's/>//' $3 #remove ">" from the header
# sed -i 's/ .\+//' $3 #remove all characters following "empty space" from the header
# seqkit grep -f $3 $GYPSY -o $4

# # Shorten the identifiers of RT sequences
# sed -i 's/|.\+//' $4 #remove all characters following "|"
# }

# RT_extract Ty1-RT $COPIA copia_list Copia_RT.fasta
# RT_extract Ty3-RT $GYPSY gypsy_list Gypsy_RT.fasta


# Extract Copia-RT protein sequences
grep Ty1-RT $COPIA > copia_list #make a list of RT proteins to extract
sed -i 's/>//' copia_list #remove ">" from the header
sed -i 's/ .\+//' copia_list #remove all characters following "empty space" from the header
seqkit grep -f copia_list $COPIA -o Copia_RT.fasta

# Shorten the identifiers of RT sequences
sed -i 's/|.\+//' Copia_RT.fasta #remove all characters following "|"


# Extract Gypsy-RT protein sequences
grep Ty3-RT $GYPSY > gypsy_list #make a list of RT proteins to extract
sed -i 's/>//' gypsy_list #remove ">" from the header
sed -i 's/ .\+//' gypsy_list #remove all characters following "empty space" from the header
seqkit grep -f gypsy_list $GYPSY -o Gypsy_RT.fasta

# Shorten the identifiers of RT sequences
sed -i 's/|.\+//' Gypsy_RT.fasta #remove all characters following "|"
