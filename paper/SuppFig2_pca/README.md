# PCA of transcriptome profiles across missions and tissues

The following script was used to generate the PCA across all samples shown in Supplementary Fig. 2.

`scripts/SuppFig2_pca_plot.R`

## Input data

This script requires the following input files:

- `sample_metadata.tsv`
- gene-level RSEM result files in `files/` with filenames ending in `.genes.results`

The `sample_metadata.tsv` must contain the following columns:

- `TissueName` (e.g. `Liver`, `Thymus`)
- `MissionID` (e.g. `MHU-1`, `MHU-2`)
- `Group` (e.g. `MHU01_GC_WT`, `MHU01_FL_WT`)

Each `.genes.results` file is expected to contain, at minimum, the following columns:

- `gene_id` (e.g. `ENSMUSG00000000001.4`, `ENSMUSG00000000003.15`)
- `transcript_id(s)` (e.g. `ENSMUST00000000001.4`, `ENSMUST00000000003.13,ENSMUST00000114041.2`)
- `expected_count` (numeric values)
- `TPM` (numeric values)

## Output
The script produces:
- `SourceData_SuppFigS2.csv`  
  PCA score table including sample identifiers, principal component scores (PC1 and PC2), and associated sample metadata

## Example
```bash
Rscript scripts/SuppFig2_pca_plot.R
```
## Expected output
Example output files:
- `SourceData_SuppFigS2.csv`

## Environment

The scripts were developed and tested in the following environment:

| Software | Version | Purpose | Ref. | 
|---|---|---|---|
| R | 4.1.2 | Data processing  and statistical analysis | [1] | 
| tidyverse | 1.3.1 | Data manipulation | [2] | 
| dplyr | 1.0.8 | Data manipulation | [3] | 
| gtools | 3.9.5 | Data manipulation | [4] | 

## Installation

Install the required R packages before running the scripts:

```r
install.packages(c("tidyverse", "dplyr"))
```

## Expected run time
On a typical desktop computer, each RPM plotting script should complete within a few seconds.

## References

[1] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[2] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.” _Journal of Open Source Software_, *4*(43), 1686. doi:10.21105/joss.01686.

[3] Wickham H, François R, Henry L, Müller K, Vaughan D (2026). _dplyr: A Grammar of Data Manipulation_. doi:10.32614/CRAN.package.dplyr. 

[4] Warnes G, Bolker B, Lumley T, Magnusson A, Venables B, Ryodan G, Moeller S (2023). _gtools: Various R Programming Tools_. doi:10.32614/CRAN.package.gtools 


## Notes
- PCA is performed on log2-transformed TPM values, calculated as log2(TPM + 1).
- Genes are retained for PCA if TPM > 1 in more than 30% of samples.
- PCA is performed on the transposed gene-by-sample matrix using prcomp(..., scale. = TRUE).
- The source datafile was used for web-lendered visualisation using interactive PCA viewer.
