## PCA of transcriptome profiles across missions and tissues

The following script was used to generate the all-sample PCA shown in Supplementary Fig. 2.  
- `scripts/SuppFig2_pca_plot.R`  

### Input data
This script requires the following input files:
- `sample_metadata.tsv`
- gene-level RSEM result files in `files/used/` with filenames ending in `.genes.results`

The metadata table must contain the following columns:
- `Tissues_TissueName`
- `Missions_MissionID`
- `ExperimentGroups_GroupID`

Each `.genes.results` file is expected to contain, at minimum, the following columns:
- `gene_id`
- `transcript_id(s)`
- `expected_count`
- `TPM`

### Output
The script produces:
- `SourceData_SuppFigS2.csv`  
  PCA score table including sample identifiers, principal component scores, and associated sample metadata
- `PCA_forSuppFigS2.pdf`  
  A multi-page PDF containing PCA plots of all samples

### Example
```bash
Rscript scripts/SuppFig2_pca_plot.R
```
###E xpected output
Example output files:
- `SourceData_SuppFigS2.csv`
- `PCA_forSuppFigS2.pdf`

### Expected run time
On a typical desktop computer, the script should complete within a few minutes, depending on the number of samples and the size of the input files.

### Notes
- PCA is performed on log2-transformed TPM values, calculated as log2(TPM + 1).
- Genes are retained for PCA if TPM > 1 in more than 30% of samples.
- PCA is performed on the transposed gene-by-sample matrix using prcomp(..., scale. = TRUE).
- The output PDF includes multiple PCA views, including PC1 vs PC2, PC3 vs PC4, and PC5 vs PC6, with samples colored or shaped according to tissue and mission.
- Sample metadata are merged into the PCA score table to facilitate downstream interpretation and figure annotation.
