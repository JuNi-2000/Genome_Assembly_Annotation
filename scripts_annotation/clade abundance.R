library(data.table)
library(tidyverse)

sum_file <- read.table("./assembly.fasta.mod.EDTA.TEanno.txt",header=T)
copia <- read_tsv("Gypsy_sequences.fa.rexdb-plant.cls.tsv")
gypsy <- read_tsv("Copia_sequences.fa.rexdb-plant.cls.tsv")

# create uniform TE names
copia$`#TE` <- sub("#.*", "", copia$`#TE`)
gypsy$`#TE` <- sub("#.*", "", gypsy$`#TE`)

#remove unnecessary infos (select only clade and TE)
copia <- copia[,c(1,4)]
gypsy <- gypsy[,c(1,4)]
names(copia) <- c("TE", "Clade")
names(gypsy) <- c("TE", "Clade")
names(sum_file)[1] <- "TE"

copia_counts <- right_join(sum_file, copia, by = "TE")
gypsy_counts <- right_join(sum_file, gypsy, by = "TE")

merged <- merge.data.frame(copia_counts, gypsy_counts, all = TRUE)
merged <- group_by(merged, Clade)


#plot 
# Assuming your dataframe is called 'df' and 'Clade' is the clade column
ggplot(merged, aes(x = Clade, y = Count, fill = Clade)) +
  geom_boxplot() +
  labs(
    title = "Distribution of Gypsy and Copia Counts per Clade (Ms_0)",
    x = "Clade",
    y = "Count"
  ) +
  ylim(0, 250) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  )


##### Same Process again for another accession #####

sum_file <- read.table("./assembly.fasta.mod.EDTA.TEanno_hector.sum",header=T)
copia <- read_tsv("Gypsy_sequences.fa.rexdb-plant_hector.cls.tsv")
gypsy <- read_tsv("Copia_sequences.fa.rexdb-plant_hector.cls.tsv")

# create uniform TE names
copia$`#TE` <- sub("#.*", "", copia$`#TE`)
gypsy$`#TE` <- sub("#.*", "", gypsy$`#TE`)

#remove unnecessary infos (select only clade and TE)
copia <- copia[,c(1,4)]
gypsy <- gypsy[,c(1,4)]
names(copia) <- c("TE", "Clade")
names(gypsy) <- c("TE", "Clade")
names(sum_file)[1] <- "TE"

copia_counts <- right_join(sum_file, copia, by = "TE")
gypsy_counts <- right_join(sum_file, gypsy, by = "TE")

merged <- merge.data.frame(copia_counts, gypsy_counts, all = TRUE)
merged <- group_by(merged, Clade)


#plot 
# Assuming your dataframe is called 'df' and 'Clade' is the clade column
ggplot(merged, aes(x = Clade, y = Count, fill = Clade)) +
  geom_boxplot() +
  labs(
    title = "Distribution of Gypsy and Copia Counts per Clade (Altai-5)",
    x = "Clade",
    y = "Count",
    ylim = c(0, 250)
  ) +
  ylim(0, 250) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  )
