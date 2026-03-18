# ibsls-paper

This repository contains scripts and workflow documentation associated with the ibSLS paper.

## Repository structure

- `RNA-Seq/`: scripts and documentation for RNA-seq data processing, including reference preparation, expression quantification, merging of per-sample results, and differential expression analysis
- `Metabolome/`: scripts and documentation for metabolome data processing and differential abundance metabolite (DAM) analysis
- `paper/`: manuscript-specific scripts used for figure generation and processing of figure-related source data

## RNA-Seq

The `RNA-Seq/` directory contains scripts for:

- preparation of RSEM references with STAR-compatible index files
- RNA-seq expression quantification using RSEM
- BAM sorting and indexing using samtools
- merging of per-sample gene-level expression outputs
- generation of compact count tables for group-wise comparison
- differential expression analysis using DESeq2

For details, see:

- `RNA-Seq/README.md`

## Metabolome

The `Metabolome/` directory contains scripts for:

- generation of group-wise abundance tables from metabolite quantification results
- statistical testing for two-group comparison
- generation of differential abundance metabolite (DAM) result tables

For details, see:

- `Metabolome/README.md`

## Manuscript-specific scripts

The `paper/` directory contains scripts used for manuscript-specific analyses and figure generation, including:

- mission-specific RPM plots and binned source data for Supplementary Figure S1
- all-sample PCA plotting for Supplementary Figure S2

For details, see:

- `paper/README.md`

## Scope

This repository provides custom scripts and workflow documentation used for data processing and manuscript-related analyses associated with the ibSLS paper.

The repository does not redistribute:

- controlled-access datasets
- large intermediate files
- prebuilt reference index files for STAR or RSEM

Reference files should be rebuilt locally using the scripts and source information provided in the corresponding subdirectories.

## License

See `LICENSE`.
