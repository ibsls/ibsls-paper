# ibsls-paper

This repository provides custom scripts and workflow documentation used for data processing and manuscript-related analyses.

**ibSLS: A Biobank for Democratizing Access to Multi-Omics Data and Biospecimens from Spaceflight Research**  
*Manuscript under revision*

## Repository structure

- `RNA-Seq/`: scripts and documentation for RNA-seq workflows used for ibSLS database construction
- `Metabolome/`: scripts and documentation for metabolome workflows used for ibSLS database construction
- `paper/`: manuscript-specific scripts used for processing of figure-related source data and figure generation 
  
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

## License

See `LICENSE`.
