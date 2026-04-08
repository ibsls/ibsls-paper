#!/usr/bin/env Rscript

library(DESeq2)

# Perform two-group differential expression analysis from a compact count table.
#
# Input format:
#   - tab-delimited file
#   - column 1: gene ID
#   - column 2: comma-separated counts for group B replicates
#   - column 3: comma-separated counts for group A replicates
#
# Output:
#   - tab-delimited DEG result table
#
# Example:
#   Rscript 04_deseq2_DEGanalysis.R \
#     count_table.tsv \
#     DEG_count_table_GCvsAG.tsv
#
# Notes:
#   - DESeq2 is run with design = ~ group
#   - results are extracted with contrast = c("group", "A", "B")

args <- commandArgs(trailingOnly = TRUE)

input_file <- args[1]
output_file <- ifelse(
  length(args) >= 2,
  args[2],
  paste0("DEG_", tools::file_path_sans_ext(basename(input_file)), ".tsv")
)

raw_data <- read.table(
  input_file,
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

gene_id <- raw_data[, 1]

nA <- length(unlist(strsplit(raw_data[1, 3], split = ",")))
nB <- length(unlist(strsplit(raw_data[1, 2], split = ",")))

count_mat <- t(sapply(seq_len(nrow(raw_data)), function(i) {
  groupA <- as.numeric(unlist(strsplit(raw_data[i, 3], split = ",")))
  groupB <- as.numeric(unlist(strsplit(raw_data[i, 2], split = ",")))
  c(groupA, groupB)
}))

count_mat <- round(count_mat)
rownames(count_mat) <- gene_id
colnames(count_mat) <- c(paste0("A", seq_len(nA)), paste0("B", seq_len(nB)))

group <- factor(c(rep("A", nA), rep("B", nB)), levels = c("B", "A"))
colData <- data.frame(group = group, row.names = colnames(count_mat))

dds <- DESeqDataSetFromMatrix(
  countData = count_mat,
  colData = colData,
  design = ~ group
)

dds <- DESeq(dds)
res <- results(dds, contrast = c("group", "A", "B"))

pval <- res$pvalue
qval <- res$padj
rank_val <- rank(pval, ties.method = "first", na.last = "keep")

meanA <- rowMeans(count_mat[, seq_len(nA), drop = FALSE])
meanB <- rowMeans(count_mat[, (nA + 1):(nA + nB), drop = FALSE])

log2_ratio <- log2((meanA + 1) / (meanB + 1))

col7 <- ifelse(log2_ratio > 0, 1, 0)
col8 <- ifelse(log2_ratio > 0, 0, 1)

pval[is.na(pval)] <- 1
qval[is.na(qval)] <- 1
rank_val[is.na(rank_val)] <- 0
log2_ratio[is.na(log2_ratio)] <- 0
col7[is.na(col7)] <- 0
col8[is.na(col8)] <- 0

out_df <- data.frame(
  geneID = gene_id,
  pvalue = pval,
  qvalue = qval,
  Rank = rank_val,
  log2_ratio = log2_ratio,
  col7 = col7,
  col8 = col8,
  stringsAsFactors = FALSE
)

write.table(
  out_df,
  file = output_file,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)
