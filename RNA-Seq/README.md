# RNA-Seq workflow

This directory contains scripts and documentation for RNA-seq data processing used in the ibSLS project and associated manuscript analyses.

## Overview

The workflow includes:

1. preparation of the RSEM reference
2. expression quantification with RSEM
3. read mapping performed internally with STAR during RSEM quantification
4. BAM processing using samtools
5. merging per-sample expression outputs
6. generation of compact count tables for group-wise comparison
7. differential expression analysis using DESeq2

## Directory structure

- `examples/`: examples of sample lists and output tables
- `references/`: reference preparation scripts and related documentation
- `scripts/`: RNA-seq processing, aggregation, and differential expression analysis scripts

## Reference preparation  
Reference preparation is described in:  `references/README.md`  
Script:  `references/build_index.sh`  
Input:  
- `reference genome FASTA`
- `gene annotation GTF`  
Output:  
- `RSEM reference files`  
- `STAR index files`

## Quantification

Expression quantification was performed using `rsem-calculate-expression`.  
During this step, read mapping was carried out internally with STAR through the `--star` option.  
Separate scripts are provided for paired-end and single-end RNA-seq data:  
Scripts:
- `scripts/01_rsem_quantification_paired.sh`
- `scripts/01_rsem_quantification_single.sh`

Input:
- FASTQ files
- reference prefix

Output:
- per-sample `.genes.results`
- per-sample `.isoforms.results`
- BAM files


## BAM processing

BAM processing was performed using:

- `scripts/02_samtools_sort.sh`

This step sorts and indexes BAM files for downstream analysis.

## Merging expression results

Per-sample expression outputs were merged using:

- `scripts/03_merge_expression.R`

This step generates a merged gene-level expression matrix for downstream analyses.

## Generation of compact count tables

Compact count tables for group-wise comparisons were generated using:

- `scripts/04_make_count_table.py`

This step converts merged gene-level expression results into compact count tables in which replicate counts for each comparison group are stored as comma-separated values.

## Differential expression analysis

Differential expression analysis was performed using DESeq2 from the compact count tables generated in the previous step.

The analysis script is provided in:

- `scripts/05_deseq2_two_group.R`

This script expands replicate counts from each comparison group, reconstructs the count matrix, and performs two-group differential expression analysis using DESeq2.

## Core software

| Software | Version | Purpose | Ref. |
|---|---|---|---|
| STAR | 2.6.1d | RNA-seq reference preparation and read mapping. Used with `rsem-prepare-reference --star` and `rsem-calculate-expression --star`. | [1] |
| RSEM | 1.3.1 | RNA-seq reference preparation and expression quantification. Used with `rsem-prepare-reference --star` and `rsem-calculate-expression --star`. | [2] |
| samtools | 1.8 | BAM sorting and indexing | [3] |
| R | 4.1.2 and 4.2.2| Data processing and statistical analysis | [4] |
| tidyverse | 1.3.1 | Data manipulation in `03_merge_expression.R` | [5] |
| dplyr | 1.0.8 | Data manipulation in `03_merge_expression.R` and manuscript-specific scripts | [6] |
| stringr | 1.4.0 | String handling in `03_merge_expression.R` | [7] |
| gtools | 3.9.5| Mixed sorting of file names in `03_merge_expression.R` | [8] |
| DESeq2 | 1.38.3 | Differential expression analysis | [9] |
| Python | [xxx] | Generation of compact count tables in `04_make_count_table.py` | [10] |

## Expected run time

Each step typically requires several hours per sample, depending on read depth and computing environment.

## References

[1] Dobin A, Davis CA, Schlesinger F, Drenkow J, Zaleski C, Jha S, Batut P, Chaisson M, Gingeras TR. *STAR: ultrafast universal RNA-seq aligner*. Bioinformatics. 2013;29(1):15-21. doi:10.1093/bioinformatics/bts635

[2] Li B, Dewey CN. *RSEM: accurate transcript quantification from RNA-Seq data with or without a reference genome*. BMC Bioinformatics. 2011;12:323. doi:10.1186/1471-2105-12-323

[3] Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, Whitwham A, Keane T, McCarthy SA, Davies RM, Li H. *Twelve years of SAMtools and BCFtools*. GigaScience. 2021;10(2):giab008. doi:10.1093/gigascience/giab008

[4] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[5] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H. *Welcome to the tidyverse*. Journal of Open Source Software. 2019;4(43):1686. doi:10.21105/joss.01686

[6] Wickham H, François R, Henry L, Müller K, Vaughan D. *dplyr: A Grammar of Data Manipulation*. R package.

[7] Wickham H. *stringr: Simple, Consistent Wrappers for Common String Operations*. R package.

[8] Warnes GR, Bolker B, Lumley T. *gtools: Various R Programming Tools*. R package.

[9] Love MI, Huber W, Anders S. *Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2*. Genome Biology. 2014;15(12):550. doi:10.1186/s13059-014-0550-8

[10] Python Software Foundation. *Python Language Reference*. Available at: https://www.python.org/

## Notes

Reference index files are not included in this repository.
They should be rebuilt locally using the source FASTA/GTF files and `references/build_index.sh`.

## Manuscript-specific visualization

Additional manuscript-specific visualization scripts, including the all-sample PCA script, are provided separately under the manuscript-specific analysis directory.
