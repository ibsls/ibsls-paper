
# Scripts and notes associated with figures in the ibSLS paper.

This directory contains scripts and notes associated with figures in the ibSLS paper.

## Mission-specific centrifuge parameters for artificial gravity loading

Raw RPM records underlying Supplementary Fig. S1 are provided as Supplementary Data associated with the paper.  
The manuscript Source Data includes the binned values used for plotting.  
The following scripts generate the binned data and figure panels from the raw RPM records.

`scripts/SuppFigS1a_MHU1_RPM_plot.R`  
`scripts/SuppFigS1b_MHU2_RPM_plot.R`  
`scripts/SuppFigS1d_MHU4_RPM_plot.R`   
`scripts/SuppFigS1e_MHU5_RPM_plot.R`

## PCA of transcriptome profiles across missions and tissues

The following script was used to generate the all-sample PCA shown in Supplementary Fig. S2.  
`scripts/SuppFigS2_pca_plot.R`  

## Web-rendered panels

Some graph panels in the manuscript are screenshots from the ibSLS web interface, including gene-expression bar graphs (Figs. 4c, 5d, and 7c; Supplementary Fig. S3b) and metabolite-abundance bar graphs (Figs. 4f and 6d; Supplementary Fig. S4a-e), and gene-expression heatmap (Fig. 5c).  
The underlying numerical values are provided as Source Data, whereas standalone plotting scripts are not provided for these web-rendered panels.

## Core software

| Software | Version | Purpose | Ref. | 
|---|---|---|---|
| R | 4.1.2 | Data processing  and statistical analysis | [1] | 
| tidyverse | 1.3.1 | Data manipulation | [2] | 
| dplyr | 1.0.8 | Data manipulation | [3] | 
| lubridate | 1.8.0 | Date handling | [4] | 
| ggplot2 | 3.3.5 | Data visualization | [6] | 
| ggsci | 4.2.0 | Data visualization | [xxx] |

## References

[1] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[2] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H. *Welcome to the 
tidyverse*. Journal of Open Source Software. 2019;4(43):1686. doi:10.21105/joss.01686

[3] Wickham H, François R, Henry L, Müller K, Vaughan D. *dplyr: A Grammar of Data Manipulation*. R package.

[4] xx

[5] Warnes GR, Bolker B, Lumley T. *gtools: Various R Programming Tools*. R package.

[6] Wickham H. *ggplot2: Elegant Graphics for Data Analysis*. Springer-Verlag New York; 2016.

