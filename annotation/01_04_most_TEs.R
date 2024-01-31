library(rtracklayer)

# Script to quickly identify the 10 contigs with the most occurrences/entries
# to get an indication of which contigs have the most TEs.

gff_path <- "flye_polished.fasta.mod.EDTA.TEanno.gff3"

# Load GFF
gff <- rtracklayer::import(gff_path)
# Convert it to a data frame
gff_df <- as.data.frame(gff)

# Count the number of entries/occurrences for each contig
contig_counts <- table(gff_df$seqnames)

# Find the 10 contigs with the most entries
top_10_contigs <- names(head(sort(contig_counts, decreasing = TRUE), 10))

# Print the result
print("The 10 contigs with the most entries are:")
for (contig in top_10_contigs) {
  print(paste(contig, "with", contig_counts[contig], "entries."))
}
