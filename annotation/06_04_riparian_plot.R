##-------------------------------------------------------------------------------
## Create riparian plot
## based on: https://htmlpreview.github.io/?https://github.com/jtlovell/tutorials/blob/main/riparianGuide.html
##-------------------------------------------------------------------------------

library(GENESPACE)
library(ggplot2)

load('/data/users/jrotzetter/assembly_annotation_course/annotation/w9_comparative_genomics/results/gsParams.rda',
        verbose = TRUE)

png(paste0("rip_plot_position.png"), units = "in", height = 5, width = 10, res = 300)
plot_riparian(gsParam = gsParam,
 refGenome = "TAIR10",
 minChrLen2plot = 0, # to show even the tiny little scaffolds, no point here really as we ran Genespace on the 10 largest contigs anyway
#  inversionColor = "green", # highlight inversions, returns error: unknown function
#  forceRecalcBlocks = TRUE, returns error: unknown function
 useOrder = FALSE, # if FALSE use physical position instead of gene rank order
 pdfFile = "rip_plot_position.pdf")

dev.off()