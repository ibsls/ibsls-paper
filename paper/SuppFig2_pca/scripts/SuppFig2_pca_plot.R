#!/usr/bin/env Rscript

library(tidyverse)
library(stringr)
library(dplyr)
library(gtools)
library(ggsci)

# Generate all-sample PCA plots from per-sample RSEM gene-level results.
#
# Required input files:
#   - sample_metadata.tsv
#   - *.genes.results (output files from rsem-calculate-expression )
#
# Required columns in sample_metadata.tsv:
#   - ibSLSDataID  
#   - ibSLSDataReleaseID
#   - TissueName
#   - MissionID
#   - Group
#
# Output files:
#   - SourceData_SuppFig2.csv
#
# Notes:
#   - PCA is performed on log2(TPM + 1).
#   - Genes were retained if TPM > 1 in more than 30% of samples.

samples <- read.table("sample_metadata.tsv", sep = "\t", header = TRUE, check.names = FALSE) %>%
  select(
    ibSLSDataID,
    ibSLSDataReleaseID,
    TissueName,
    Mission,
    Group
  ) 

List <- list.files("files/", pattern = "\\.genes.results$", full.names = TRUE) %>%
  mixedsort()

d <- do.call(cbind,
             lapply(List,
                    FUN=function(x) { 
                      aColumn <- read.table(x,header=T)[,c("gene_id","transcript_id.s.","expected_count","TPM")];
                      sample <-gsub("_vM20.genes.results","",basename(x))
                      colnames(aColumn)[3] = paste(sample,"expected_count",sep="|");
                      colnames(aColumn)[4] = paste(sample,"TPM",sep="|");
                      aColumn;
                    }
             )
)

d <- d[, !duplicated(colnames(d))] %>%
  select(-transcript_id.s.)

tpm <- d %>%
  select(gene_id, ends_with("TPM")) %>%
  pivot_longer(
    -gene_id,
    names_to = "sample",
    values_to = "tpm"
  ) %>%
  separate(sample, into = c("sample", "name"), sep = "\\|") %>%
  select(-name) %>%
  mutate(log_tpm = log(tpm + 1, 2)) %>%
  group_by(gene_id) %>%
  mutate(
    n_samples = n(),
    n_pass = sum(tpm > 1, na.rm = TRUE),
    pass = n_pass / n_samples > 0.3
  ) %>%
  ungroup() %>%
  filter(pass == TRUE) %>%
  select(gene_id, sample, log_tpm) %>%
  pivot_wider(names_from = sample, values_from = log_tpm) %>%
  column_to_rownames("gene_id")

pca <- prcomp(t(tpm), scale. = TRUE)
s <- summary(pca)

score <- as.data.frame(pca$x) %>%
  rownames_to_column("ibSLSDataID") %>%
  left_join(samples, by = "ibSLSDataID") %>%
select(ibSLSDataReleaseID,Mission,Tissue,GroupName,PC1,PC2)

write.csv(score, "SourceData_SuppFig2.csv", quote = FALSE, row.names = FALSE)


