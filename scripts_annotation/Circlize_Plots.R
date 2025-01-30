# Load the circlize package
library(circlize)
library(tidyverse)
library(ComplexHeatmap)

# Load the TE annotation GFF3 file
gff_file <- "assembly.fasta.mod.EDTA.TEanno.gff3"
gff_data <- read.table(gff_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE)

# Check the superfamilies present in the GFF3 file, and their counts
gff_data$V3 %>% table()

top_super_families <- gff_data %>% count(V3, sort = TRUE) %>% slice_head(n=5) %>% pull(V3)

# Filter the GFF3 data to select one Superfamily (You need one track per Superfamily)

# custom ideogram data
## To make the ideogram data, you need to know the lengths of the scaffolds.
## There is an index file that has the lengths of the scaffolds, the .fai file.
## To generate this file you need to run the following command in bash:
## samtools faidx assembly.fasta
## This will generate a file named assembly.fasta.fai
## You can then read this file in R and prepare the custom ideogram data

custom_ideogram <- read.table("assembly.fasta.fai", header = FALSE, stringsAsFactors = FALSE) # I use the fly assembly
custom_ideogram$chr <- custom_ideogram$V1
custom_ideogram$start <- 1
custom_ideogram$end <- custom_ideogram$V2
custom_ideogram <- custom_ideogram[, c("chr", "start", "end")]
custom_ideogram <- custom_ideogram[order(custom_ideogram$end, decreasing = T), ]
sum(custom_ideogram$end[1:20])

# Select only the first 20 longest scaffolds, You can reduce this number if you have longer chromosome scale scaffolds
custom_ideogram <- custom_ideogram[1:20, ]
custom_ideogram$chr <- paste0("chr", custom_ideogram$chr)

gff_data$V1 <- paste0("chr", gff_data$V1)
# Function to filter GFF3 data based on Superfamily (You need one track per Superfamily)
filter_superfamily <- function(gff_data, superfamily, custom_ideogram) {
  filtered_data <- gff_data[gff_data$V3 == superfamily, ] %>%
    as.data.frame() %>%
    mutate(chrom = V1, start = V4, end = V5, strand = V6) %>%
    select(chrom, start, end, strand) %>%
    filter(chrom %in% custom_ideogram$chr)
  return(filtered_data)
}

filtered_data <- filter_superfamily(gff_data, "Gypsy_LTR_retrotransposon", custom_ideogram)


pdf("02-TE_density.pdf", width = 10, height = 10)
gaps <- c(rep(1, length(custom_ideogram$chr) - 1), 5) # Add a gap between scaffolds, more gap for the last scaffold
circos.par(start.degree = 90, gap.after = 1, track.margin = c(0, 0), gap.degree = gaps)
# Initialize the circos plot with the custom ideogram
circos.genomicInitialize(custom_ideogram)

# Plot te density
circos.genomicDensity(filter_superfamily(gff_data, "Gypsy_LTR_retrotransposon", custom_ideogram), count_by = "number", col = "darkgreen", track.height = 0.07, window.size = 1e5)
circos.genomicDensity(filter_superfamily(gff_data, "Copia_LTR_retrotransposon", custom_ideogram), count_by = "number", col = "darkred", track.height = 0.07, window.size = 1e5)
circos.clear()

lgd <- Legend(
  title = "Superfamily", at = c("Gypsy_LTR_retrotransposon", "Copia_LTR_retrotransposon"),
  legend_gp = gpar(fill = c("darkgreen", "darkred"))
)
draw(lgd, x = unit(8, "cm"), y = unit(10, "cm"), just = c("center"))

dev.off()


# Now plot all your most abundant TE superfamilies in one plot

# Plot the distribution of Athila and CRM clades (known centromeric TEs in Brassicaceae).


# Initialize PDF output
pdf("02-TE_density_top5_superfamilies.pdf", width = 10, height = 10)

# Set up circos plot parameters
circos.par(start.degree = 90, gap.after = 1, track.margin = c(0, 0), 
           gap.degree = c(rep(1, nrow(custom_ideogram) - 1), 5))

# Initialize circos plot
circos.genomicInitialize(custom_ideogram)

# Define colors for superfamilies
colors <- c("darkgreen", "darkred", "blue", "purple", "orange")
names(colors) <- top_super_families

# Plot density tracks for each top superfamily with debug checks
for (i in seq_along(top_super_families)) {
  superfamily <- top_super_families[i]
  data <- filter_superfamily(gff_data, superfamily, custom_ideogram)
  
  # Debug: Check if data is a data frame and has the correct structure
  if (!is.data.frame(data) || ncol(data) != 4) {
    stop(paste("Data structure issue with superfamily:", superfamily))
  }
  
  circos.genomicDensity(
    data,
    count_by = "number",
    col = colors[superfamily],
    track.height = 0.07,
    window.size = 1e5
  )
}

# Clear circos plot parameters
circos.clear()

# Create and draw legend
lgd <- Legend(
  title = "Superfamily",
  at = top_super_families,
  legend_gp = gpar(fill = colors[top_super_families])
)
draw(lgd, x = unit(10, "cm"), y = unit(10, "cm"), just = c("center"))

# Close PDF output
dev.off()

