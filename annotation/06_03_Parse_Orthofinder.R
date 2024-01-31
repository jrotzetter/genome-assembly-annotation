### 1) Summarize Orthofinder statistics per species

## load packages
library(tidyverse)
library(data.table)
library(cowplot)
library(RColorBrewer)

## Import dataset (Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv)

# ========== when calling this R script from a bash script these are the arguments provided within the script and represent paths
wd <- commandArgs(trailingOnly = TRUE)[1]
setwd(wd)
sps <- commandArgs(trailingOnly = TRUE)[2]
dat <- fread(sps, fill = TRUE)
ogc <- commandArgs(trailingOnly = TRUE)[3]

ogroups <- fread(ogc)

# uncomment part below if script is directly called within R and comment the part above
# ~~~~~~~~~~
# setwd("path/to/outputdirectory")
## setwd(dirname(rstudioapi::getSourceEditorContext()$path)) # in case the script is used in RStudio and you would like to set the wd to the script's location
# dat <- fread("path/to/Statistics_PerSpecies.tsv", fill=TRUE)
# ogroups <- fread("path/to/Orthogroups.GeneCount.tsv")
# ~~~~~~~~~~

ids <- paste(dat[1, 2:ncol(dat)])
names(dat)[-1] <- ids
# ==========

# ids=names(dat)
dat <- gather(dat, species, perc, ids[ids != "V1"], factor_key = TRUE)

# ========== own insert/ modification of original script
colnames(dat)[colnames(dat) == "species"] <- "Accession"
# Replace "species" with "accession" in the "V1" column
dat$V1 <- gsub("species", "accession", dat$V1)
# ==========

## Parse Dataset
o_ratio <- dat %>%
  filter(V1 %in% c(
    "Number of genes",
    "Number of genes in orthogroups",
    "Number of unassigned genes",
    "Number of orthogroups containing accession",
    "Number of accession-specific orthogroups",
    "Number of genes in accession-specific orthogroups"
  ))

o_percent <- dat %>%
  filter(V1 %in% c(
    "Percentage of genes in orthogroups",
    "Percentage of unassigned genes",
    "Percentage of orthogroups containing accession",
    "Percentage of genes in accession-specific orthogroups"
  ))

# ========== own insert/ modification of original script
# percent column is actually character, change to numeric
o_ratio$perc <- as.numeric(o_ratio$perc)
o_percent$perc <- as.numeric(o_percent$perc)
# ==========

## Plot

p <- ggplot(o_ratio, aes(x = V1, y = perc, fill = Accession)) +
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Paired") +
  theme_cowplot() +
  theme(
    axis.text.x = element_text(angle = 65, hjust = 1, size = 10),
    plot.margin = margin(t = 20, l = 10, r = 5, unit = "pt"),
    panel.grid.major.y = element_line(linetype = "dashed", linewidth = 0.3)
  ) +
  labs(y = "Count", x = "")
ggsave("orthogroup_number_plot.pdf")
ggsave("orthogroup_number_plot.png", bg = "white")

p <- ggplot(o_percent, aes(x = V1, y = perc, fill = Accession)) +
  geom_col(position = "dodge") +
  ylim(c(0, 100)) +
  scale_fill_brewer(palette = "Paired") +
  theme_cowplot() +
  theme(
    axis.text.x = element_text(angle = 65, hjust = 1, size = 10),
    plot.margin = margin(t = 20, l = 10, r = 5, unit = "pt"),
    panel.grid.major.y = element_line(linetype = "dashed", linewidth = 0.3)
  ) +
  labs(y = "Percent", x = "")
ggsave("orthogroup_percentage_plot.pdf")
ggsave("orthogroup_percentage_plot.png", bg = "white")



### 2) Plot co-occurrence of Orthogroups

# library(UpSetR) # depending on version of ComplexUpset comment or uncomment this if ComplexUpset does not work

## import dataset (Orthogroups/Orthogroups.GeneCount.tsv)


## parse dataset
ogroups <- ogroups %>% select(-Total)
ogroups_presence_absence <- ogroups
rownames(ogroups_presence_absence) <- ogroups_presence_absence$Orthogroup
ogroups_presence_absence[ogroups_presence_absence > 0] <- 1
ogroups_presence_absence$Orthogroup <- rownames(ogroups_presence_absence)

str(ogroups_presence_absence)
ogroups_presence_absence$Orthogroup

# ogroups_presence_absence <- ogroups_presence_absence %>%
#   rowwise() %>%
#   mutate(SUM = sum(c_across(ends_with("proteins")))) # no "proteins" anywhere in the files, ignore for current use of script


# genomes <- names(ogroups_presence_absence)[grepl("proteins",names(ogroups_presence_absence))]
ogroups_presence_absence <- data.frame(ogroups_presence_absence)
# ogroups_presence_absence[genomes] <- ogroups_presence_absence[genomes] == 1
ogroups_presence_absence[ids] <- ogroups_presence_absence[ids] == 1


## plot data using the ComplexUpset package
library(ComplexUpset)

pdf("one-to-one_orthogroups_plot.complexupset.pdf", height = 5, width = 10, useDingbats = FALSE)
# upset(ogroups_presence_absence, genomes, name = "genre", width_ratio = 0.1, wrap = TRUE, set_sizes = FALSE)
upset(ogroups_presence_absence,
  ids,
  base_annotations = list(
    "Intersection size" = intersection_size(
      text = list(
        vjust = 0.4,
        hjust = -0.075,
        angle = 90,
        size = 2.5
      ),
      text_mapping = aes(label = paste0(
        !!upset_text_percentage(),
        "(",
        !!get_size_mode("exclusive_intersection"),
        ")"
      )),
      text_colors = c(
        on_background = "black", on_bar = "black"
      )
    ) + annotate(
      geom = "text", x = Inf, y = Inf,
      label = paste("Total:", nrow(ogroups_presence_absence)),
      vjust = 1,
      hjust = 1,
      size = 3
    ) + ylim(c(NA, 17500))
  ),
  name = "Co-occurrence of Orthogroups",
  width_ratio = 0.1,
  wrap = TRUE,
  set_sizes = FALSE
)

png(paste0("one-to-one_orthogroups_plot.complexupset.png"), units = "in", height = 5, width = 10, res = 300)
upset(ogroups_presence_absence,
  ids,
  base_annotations = list(
    "Intersection size" = intersection_size(
      text = list(
        vjust = 0.4,
        hjust = -0.075,
        angle = 90,
        size = 2.5
      ),
      text_mapping = aes(label = paste0(
        !!upset_text_percentage(),
        "(",
        !!get_size_mode("exclusive_intersection"),
        ")"
      )),
      text_colors = c(
        on_background = "black", on_bar = "black"
      )
    ) + annotate(
      geom = "text", x = Inf, y = Inf,
      label = paste("Total:", nrow(ogroups_presence_absence)),
      vjust = 1,
      hjust = 1,
      size = 3
    ) + ylim(c(NA, 17500))
  ),
  name = "Co-occurrence of Orthogroups",
  width_ratio = 0.1,
  wrap = TRUE,
  set_sizes = FALSE
)
dev.off()
