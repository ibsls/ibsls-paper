# RNA-Seq workflow

This directory contains scripts and reference files used for RNA-seq processing in ibSLS database construction.

## Directory structure

- `references/`: scripts for RSEM reference preparation and STAR index generation 
- `scripts/`: scripts for expression quantification, result merging, count table generation, and differential expression analysis
- `examples/`: Example input files and corresponding example output files for selected scripts.


## Overview

The RNA-seq workflow consists of the following steps:

1. Preparation of the RSEM reference
2. Expression quantification from FASTQ files using RSEM with STAR
3. Merging of per-sample gene-level expression results
4. Generation of compact count tables for group-wise comparison
5. Two-group differential expression analysis using DESeq2
   
## Reference preparation  
Reference preparation is described in: `references/README.md`  

Script: `references/build_index.sh`

Input: `reference genome FASTA`, `gene annotation GTF`

Output: `RSEM reference files`, `STAR index files`

## Quantification

Expression quantification was performed using `rsem-calculate-expression`.  
During this step, read mapping was carried out internally with STAR through the `--star` option.  

Scripts: `scripts/01_rsem_quantification_paired.sh` (for paired-end data) or `scripts/01_rsem_quantification_single.sh` (for single-end data).  

Inputs: FASTQ file(s), RSEM reference prefix, STAR binary directory

Outputs:
- `*.genes.results` (per-sample gene-level expression matrix)
- `*.isoforms.results` (per-sample isoform-level expression matrix)
- genome-aligned BAM files

## Merging expression results

Merges per-sample RSEM gene-level result files to generate gene-level expression matrix for downstream analyses.

Script: `scripts/02_merge_expression.R`

Input: `../references/idlist_vM20.tsv`, `*.genes.results`

Output: `merged.genes.results.txt` (merged gene-level expression table)   

## Generation of compact count tables

Generates compact count tables for DESeq2 from the merged gene expression table.

Script: `scripts/03_make_count_table.py`

Inputs:
- `sample_list.csv` (sample-level annotation used for group-wise aggregation of expression counts)
- `merged.genes.results.txt`

Output: `count_table.tsv` (grouped count table for downstream DESeq2 analysis)

## Differential expression analysis   
Performs two-group differential expression analysis from the compact count table using DESeq2.   

Script: `script/04_deseq2_DEGanalysis.R`   

Input: `count_table.tsv` (the compact count tables generated in the previous step)
- column 1: gene ID
- column 2: comma-separated counts for group B replicates
- column 3: comma-separated counts for group A replicates
  
Output: tab-delimited DEG result table

This script expands replicate counts from each group, reconstructs the count matrix, and performs two-group differential expression analysis using DESeq2.

## Core software

| Software | Version | Purpose | Ref. |
|---|---|---|---|
| STAR | 2.6.1d | RNA-seq reference preparation and read mapping. | [1] |
| RSEM | 1.3.1 | RNA-seq reference preparation and expression quantification. | [2] |
| R | 4.1.2 and 4.2.2| Data processing and statistical analysis | [3] |
| tidyverse | 1.3.1 | Data manipulation in `02_merge_expression.R` | [4] |
| dplyr | 1.0.8 | Data manipulation in `02_merge_expression.R` | [5] |
| stringr | 1.4.0 | String handling in `02_merge_expression.R` | [6] |
| gtools | 3.9.5| Mixed sorting of file names in `03_merge_expression.R` | [7] |
| DESeq2 | 1.38.3 | Differential expression analysis in `04_deseq2_DEGanalysis.R` | [8] |
| Python | [xxx] | Generation of compact count tables in `03_make_count_table.py` | [9] |


## References

[1] Dobin A, Davis CA, Schlesinger F, Drenkow J, Zaleski C, Jha S, Batut P, Chaisson M, Gingeras TR. *STAR: ultrafast universal RNA-seq aligner*. Bioinformatics. 2013;29(1):15-21. doi:10.1093/bioinformatics/bts635

[2] Li B, Dewey CN. *RSEM: accurate transcript quantification from RNA-Seq data with or without a reference genome*. BMC Bioinformatics. 2011;12:323. doi:10.1186/1471-2105-12-323

[3] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[4] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H. *Welcome to the tidyverse*. Journal of Open Source Software. 2019;4(43):1686. doi:10.21105/joss.01686

[5] Wickham H, François R, Henry L, Müller K, Vaughan D. *dplyr: A Grammar of Data Manipulation*. R package.

[6] Wickham H. *stringr: Simple, Consistent Wrappers for Common String Operations*. R package.

[7] Warnes GR, Bolker B, Lumley T. *gtools: Various R Programming Tools*. R package.

[8] Love MI, Huber W, Anders S. *Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2*. Genome Biology. 2014;15(12):550. doi:10.1186/s13059-014-0550-8

[9] Python Software Foundation. *Python Language Reference*. Available at: https://www.python.org/


