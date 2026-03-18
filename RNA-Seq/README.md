
# RNA-Seq workflow

This directory contains scripts and documentation for RNA-seq processing used in the ibSLS paper.

## Overview

The workflow includes:

1. preparation of the RSEM reference
2. expression quantification with RSEM
3. read mapping performed internally with STAR during RSEM quantification
4. BAM processing using samtools
5. merging per-sample expression outputs for downstream analysis
6. differentially expression analysis using DESeq2

## Directory structure

- `metadata/`: sample lists and example metadata tables
- `references/`: reference preparation script and documentation
- `scripts/`: RNA-seq processing and aggregation scripts

## Reference preparation

Reference preparation is described in:

- `references/README.md`

The reference was prepared using:

- `references/build_index.sh`

This script uses `rsem-prepare-reference --star` to generate the RSEM reference together with STAR-compatible index files.

## Quantification

Expression quantification was performed using `rsem-calculate-expression`.

During this step, read mapping was carried out internally with STAR through the `--star` option.

Separate scripts are provided for paired-end and single-end RNA-seq data:

- `scripts/01_rsem_quantification_paired.sh`
- `scripts/01_rsem_quantification_single.sh`

## BAM processing

BAM processing was performed using:

- `scripts/02_samtools_sort.sh`

This step sorts and indexes BAM files for downstream analysis.

## Merging expression results

Per-sample expression outputs were merged using:

- `scripts/03_merge_expression.R`

This step generates a merged expression matrix for downstream analyses.

## Differential expression analysis

Differential expression analysis was performed using DESeq2 from compact count tables in which replicate counts for each comparison group were stored as comma-separated values.
The analysis script is provided in:

- `scripts/04_deseq2_analysis.R`

## Notes

Reference index files are not included in this repository.
They should be rebuilt locally using the source FASTA/GTF files and `references/build_index.sh`.

Some file paths and execution settings were simplified from the original computational environment for public release.
