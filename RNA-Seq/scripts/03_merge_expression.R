#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)
library(dplyr)
library(gtools)

# Merge per-sample RSEM gene-level results and append gene annotations.
#
# Required files:
#   - idlist_vM20.tsv
#   - *.genes.results
#
# Notes:
#   - idlist_vM20.tsv is used as the annotation table.
#   - Column names of merged expression values are derived from file names.

id <- read.table("../references/annotation/idlist_vM20.tsv",
                 sep = "\t", header = TRUE, check.names = FALSE)

List <- list.files(pattern = "\\.genes.results$") %>%
  mixedsort()

d <- do.call(
  cbind,
  lapply(
    List,
    FUN = function(x) {
      aColumn <- read.table(x, header = TRUE, check.names = TRUE)[, c("gene_id", "transcript_id.s.", "expected_count", "TPM", "FPKM")]

      sample <- gsub("_vM20.genes.results", "", x)
      sample <- gsub("\\.genes.results", "", sample)

      colnames(aColumn)[3] <- paste(sample, "expected_count", sep = "|")
      colnames(aColumn)[4] <- paste(sample, "TPM", sep = "|")
      colnames(aColumn)[5] <- paste(sample, "FPKM", sep = "|")

      aColumn
    }
  )
)

d <- d[, !duplicated(colnames(d))]
d <- d %>%
  select("gene_id", "transcript_id.s.", ends_with("expected_count"), ends_with("TPM"), ends_with("FPKM"))

d2 <- dplyr::left_join(id, d, by = c("ensembl_id" = "gene_id"))

write.table(d2, "merged.genes.results.txt", sep = "\t", quote = FALSE, row.names = FALSE)
