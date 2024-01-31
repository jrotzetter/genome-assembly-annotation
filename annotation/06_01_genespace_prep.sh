#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00
#SBATCH --job-name=genespace_prep
#SBATCH --mail-user=jeremy.rotzetter@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --output=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_01_output_genespace_prep_%j.o
#SBATCH --error=/data/users/jrotzetter/assembly_annotation_course/annotation/logs/06_01_error_genespace_prep_%j.e
#SBATCH --partition=pall

##-------------------------------------------------------------------------------
## Formatting input data for comparative genomics to assess sequence homology to proteins of closely related species
## using R package GENESPACE.
##-------------------------------------------------------------------------------

# based on the script from rschwob (because mine caused synteny problems with accession Cvi_0 when running Genespace for some reason)
module add UHTS/Analysis/SeqKit/0.13.2

# Define output and input directories
work_dir=/data/users/jrotzetter/assembly_annotation_course/annotation

# Input dir
input_dir=/data/courses/assembly-annotation-course/CDS_annotation/Genespace

# Output dirs
out_dir=${work_dir}/w9_comparative_genomics
mkdir ${out_dir}
bed_dir=${out_dir}/bed
mkdir ${bed_dir}
peptide_dir=${out_dir}/peptide
mkdir ${peptide_dir}

# Loop over all datasets (only consider files, not folders)
for gff_file_path in ${input_dir}/*noseq*renamed*gff; do
if [[ -f ${gff_file_path} ]]; then

    # Define the base name of the files (accession/dataset)
    gff_file=$(basename ${gff_file_path})
    base=${gff_file%.all*}
    # Input gff
    gff=${gff_file_path}
    # gff=${input_dir}/${base}.all.maker.noseq*renamed.gff
    # Input fasta
    fasta=${input_dir}/${base}*proteins*renamed*fasta

    # Intermediate output files
    out_contigs=${out_dir}/${base}_longest_contigs.txt
    out_gene_IDs=${out_dir}/${base}_gene_IDs.txt
    # Output bed
    out_bed=${bed_dir}/${base}.bed
    # Output peptide
    out_peptide=${peptide_dir}/${base}.fa

    # Filter the gff for the third field ($3) "type" == "contig"; sort them in reverse order (-r) based on the fifth field ($5) "width" numerically (-n)
    # cat ${gff} | awk '$3=="contig"' | sort -t $'\t' -k5 -n -r | head -n 10 > ${out_contigs}
    cat ${gff} | awk '$3=="contig"' | sort -t $'\t' -k5 -n -r | cut -f 1,4,5,9 | sed 's/ID=//' | sed 's/;.\+//' | head -n 10 > ${out_contigs}

    # -t $'\t': Specifies the field separator as a tab character (\t).
    # -k5: Sorts based on the fifth field ($5)
    # -n: sorts numerically (not alphabetically).
    # -r: Sorts the lines in reverse order.

    #Create bed file
    cat ${gff} | awk '$3=="mRNA"' | cut -f 1,4,5,9 | sed 's/ID=//' | sed 's/;.\+//' | grep -w -f <(cut -f1 ${out_contigs}) > ${out_bed}

    #Get the gene IDs
    cut -f4 ${out_bed} > ${out_gene_IDs}

    #Create fasta file
    cat ${fasta} | seqkit grep -r -f ${out_gene_IDs} | seqkit seq -i > ${out_peptide}

fi
done

# Copy the reference files to the directory for genespace
cp ${input_dir}/TAIR10.bed ${bed_dir} 
cp ${input_dir}/TAIR10.fa ${peptide_dir}

# ALTERNATIVELY: Just copy all bed and peptide files to the genespace directory (can also run directly in the terminal)
# cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/*.bed ${bed_dir}
# cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/*.fa ${peptide_dir}