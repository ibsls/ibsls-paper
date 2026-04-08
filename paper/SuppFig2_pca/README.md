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

## Expected run time
On a typical desktop computer, the script should complete within a few minutes, depending on the number of samples and the size of the input files.

## Notes
- PCA is performed on log2-transformed TPM values, calculated as log2(TPM + 1).
- Genes are retained for PCA if TPM > 1 in more than 30% of samples.
- PCA is performed on the transposed gene-by-sample matrix using prcomp(..., scale. = TRUE).
- The source datafile was used for web-lendered visualisation using interactive PCA viewer.
