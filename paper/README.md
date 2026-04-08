
# Scripts associated with figures in the ibSLS paper

This directory contains scripts associated with selected figures in the ibSLS paper.

## Mission-specific centrifuge parameters for artificial gravity loading
Raw RPM records underlying Supplementary Fig. 1 are provided as Supplementary Data associated with the paper.  
The manuscript Source Data includes the binned values used for plotting.  
The following scripts generate the binned data and figure panels from the raw RPM records.

- `scripts/SuppFig1a_MHU1_RPM_plot.R`
- `scripts/SuppFig1b_MHU2_RPM_plot.R`
- `scripts/SuppFig1c_MHU4_RPM_plot.R`
- `scripts/SuppFig1d_MHU5_RPM_plot.R`

### Input data
Each script expects the corresponding raw RPM record file as input in tab-delimited text format, as provided in the Supplementary Data.

### Output
Each script produces:
- `a CSV file containing the binned RPM values used for plotting`
- `a PDF file containing the corresponding figure panel`

### Example
```bash
Rscript scripts/SuppFig1a_MHU1_RPM_plot.R
```

### Expected output
Example output files:
- `SourceData_SuppFigS1a.csv`
- `MHU-1.bin10s.pdf`

### Expected run time
On a typical desktop computer, each RPM plotting script should complete within a few seconds.

### Notes
- Raw RPM records are aggregated into fixed-size bins within each script before plotting.
- Median elapsed time and median RPM per bin are used for visualization.
- The shaded interval in each plot corresponds to the period used for summary-statistics calculation in the manuscript.

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

## Web-rendered panels

Some graph panels in the manuscript were rendered through the ibSLS web interface, including gene-expression bar graphs (Figs. 4c, 5d, and 7c; Supplementary Fig. 3b), metabolite-abundance bar graphs (Figs. 4f and 6d; Supplementary Fig. 4a–e), and a gene-expression heatmap (Fig. 5c).  
The underlying numerical values are provided as Source Data associated with the paper. Standalone plotting scripts are not provided because these panels were generated interactively within the ibSLS web interface. The manuscript illustrates the corresponding navigation paths and representatitve query settings used to access and render these panels.



