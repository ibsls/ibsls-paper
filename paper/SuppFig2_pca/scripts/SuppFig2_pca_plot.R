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
#   - files/used/*.genes.results
#
# Required columns in sample_metadata.tsv:
#   - ibSLSDataID
#   - Tissues_TissueID
#   - Tissues_TissueName
#   - Missions_MissionID
#   - ExperimentGroups_GroupID
#
# Output files:
#   - PCA_allsamples_score.csv
#   - PCA_allsamples.pdf
#
# Notes:
#   - PCA is performed on log2(TPM + 1).
#   - Genes were retained if TPM > 1 in more than 30% of samples.

samples <- read.table("sample_metadata.tsv", sep = "\t", header = TRUE, check.names = FALSE) %>%
  select(
    ibSLSDataID,
    Tissues_TissueID,
    Tissues_TissueName,
    Missions_MissionID,
    ExperimentGroups_GroupID
  ) 

List <- list.files("files/used", pattern = "\\.genes.results$", full.names = TRUE) %>%
  mixedsort()

d <- do.call(
  cbind,
  lapply(
    List,
    FUN = function(x) {
      aColumn <- read.table(x, header = TRUE, check.names = TRUE)[, c("gene_id", "transcript_id.s.", "expected_count", "TPM")]
      sample <- gsub("_vM20.genes.results", "", basename(x))
      colnames(aColumn)[3] <- paste(sample, "expected_count", sep = "|")
      colnames(aColumn)[4] <- paste(sample, "TPM", sep = "|")
      aColumn
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
  mutate(
    Tissues_TissueID = case_when(
      is.na(Tissues_TissueID) ~ "Liv",
      TRUE ~ Tissues_TissueID
    ),
    Missions_MissionID = case_when(
      is.na(Missions_MissionID) ~ "MHU02",
      TRUE ~ Missions_MissionID
    )
  ) %>%
  mutate(
    Genotype = case_when(
      grepl("_KO", ExperimentGroups_GroupID) ~ "KO",
      TRUE ~ "WT"
    ),
    Group = case_when(
      grepl("_AG", ExperimentGroups_GroupID) ~ "AG",
      grepl("_MG", ExperimentGroups_GroupID) ~ "MG",
      grepl("_GC", ExperimentGroups_GroupID) ~ "GC",
      grepl("MHU03_FL", ExperimentGroups_GroupID) ~ "MG"
    )
  ) %>%
  mutate(
    Genotype = factor(Genotype, levels = c("WT", "KO")),
    Group = factor(Group, levels = c("GC", "MG", "AG", "PG")),
    Missions_MissionID = factor(Missions_MissionID, levels = c("MHU01", "MHU02", "MHU03", "MHU04", "MHU05"))
  )

write.csv(score, "SourceData_SuppFigS2.csv", quote = FALSE, row.names = FALSE)

pdf("PCA_forSuppFigS2.pdf")

g <- ggplot(score, aes(x = PC1, y = PC2)) +
  geom_point(size = 2) +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle(
    "allSamples",
    subtitle = "genes w/ TPM > 1 in >30% of samples"
  ) +
  xlab(paste("PC1", round(s$importance["Proportion of Variance", "PC1"], 4) * 100, "%")) +
  ylab(paste("PC2", round(s$importance["Proportion of Variance", "PC2"], 4) * 100, "%"))
plot(g)

g <- ggplot(score, aes(x = PC1, y = PC2, color = Tissues_TissueID)) +
  geom_point(size = 2) +
  scale_color_primer(palette = c("mark17")) +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle(
    "allSamples",
    subtitle = "genes w/ TPM > 1 in >30% of samples"
  ) +
  xlab(paste("PC1", round(s$importance["Proportion of Variance", "PC1"], 4) * 100, "%")) +
  ylab(paste("PC2", round(s$importance["Proportion of Variance", "PC2"], 4) * 100, "%"))
plot(g)

g <- ggplot(score, aes(x = PC1, y = PC2, color = Missions_MissionID)) +
  geom_point(size = 2) +
  scale_color_nejm() +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle(
    "allSamples",
    subtitle = "genes w/ TPM > 1 in >30% of samples"
  ) +
  xlab(paste("PC1", round(s$importance["Proportion of Variance", "PC1"], 4) * 100, "%")) +
  ylab(paste("PC2", round(s$importance["Proportion of Variance", "PC2"], 4) * 100, "%"))
plot(g)

g <- ggplot(score, aes(x = PC1, y = PC2, color = Tissues_TissueID, shape = Missions_MissionID)) +
  geom_point(size = 2) +
  scale_color_primer(palette = c("mark17")) +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle(
    "allSamples",
    subtitle = "genes w/ TPM > 1 in >30% of samples"
  ) +
  xlab(paste("PC1", round(s$importance["Proportion of Variance", "PC1"], 4) * 100, "%")) +
  ylab(paste("PC2", round(s$importance["Proportion of Variance", "PC2"], 4) * 100, "%"))
plot(g)

g <- ggplot(score, aes(x = PC3, y = PC4, color = Tissues_TissueID, shape = Missions_MissionID)) +
  geom_point(size = 2) +
  scale_color_primer(palette = c("mark17")) +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle(
    "allSamples",
    subtitle = "genes w/ TPM > 1 in >30% of samples"
  ) +
  xlab(paste("PC3", round(s$importance["Proportion of Variance", "PC3"], 4) * 100, "%")) +
  ylab(paste("PC4", round(s$importance["Proportion of Variance", "PC4"], 4) * 100, "%"))
plot(g)

g <- ggplot(score, aes(x = PC5, y = PC6, color = Tissues_TissueID, shape = Missions_MissionID)) +
  geom_point(size = 2) +
  scale_color_primer(palette = c("mark17")) +
  theme_bw() +
  theme(legend.position = "top") +
  ggtitle(
    "allSamples",
    subtitle = "genes w/ TPM > 1 in >30% of samples"
  ) +
  xlab(paste("PC5", round(s$importance["Proportion of Variance", "PC5"], 4) * 100, "%")) +
  ylab(paste("PC6", round(s$importance["Proportion of Variance", "PC6"], 4) * 100, "%"))
plot(g)

dev.off()
