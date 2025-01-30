library(data.table)
library(tidyverse)


# Load the annotation
annotation <- fread("/data/users/jniklaus2/genome_annotation_2/MAKER_output/final2/filtered.genes.renamed.final.gff3", header = FALSE, sep = "\t")
bed_genes <- annotation %>%
    filter(V3 == "gene") %>%
    select(V1, V4, V5, V9) %>%
    mutate(gene_id = as.character(str_extract(V9, "ID=[^;]*"))) %>%
    mutate(gene_id = as.character(str_replace(gene_id, "ID=", ""))) %>%
    select(-V9)

top20_scaff <- fread("/data/users/jniklaus2/genome_annotation/flye_results/assembly.fasta.fai", header = FALSE, sep = "\t") %>%
    select(V1, V2) %>%
    arrange(desc(V2)) %>%
    head(20)

# Write the bed file
bed_genes <- bed_genes %>%
    filter(V1 %in% top20_scaff$V1)


# make a genespace specific directory
if (!dir.exists("genespace")) {
    dir.create("genespace")
}
if (!dir.exists("genespace/bed")) {
    dir.create("genespace/bed")
}
if (!dir.exists("genespace/peptide")) {
    dir.create("genespace/peptide")
}

gene_id <- bed_genes$gene_id
write.table(gene_id, "genespace/genespace_genes.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
# Load the longest protein sequences
longest_proteins <- "/data/users/jniklaus2/genome_annotation_2/MAKER_output/final2/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"


write.table(bed_genes, "genespace/bed/Ms_0.bed", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

# remove "-R.*" from fasta headers of proteins, to get only gene IDs
system(paste("sed 's/-R.*//' ", longest_proteins, " > genespace/Ms_0.fa", sep = ""))
# filter to select only proteins of the top 20 scaffolds
system("faSomeRecords genespace/Ms_0.fa genespace/genespace_genes.txt genespace/peptide/Ms_0.fa")


system("cp /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.bed genespace/bed/")
system("cp /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.fa genespace/peptide/")
