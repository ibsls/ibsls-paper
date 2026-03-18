
# Manuscript-specific scripts

This directory contains manuscript-specific scripts and notes associated with figures in the ibSLS paper.

## Mission-specific centrifuge parameters for artificial gravity loading

Raw RPM records underlying Supplementary Fig. S1 are provided as Supplementary Data associated with the paper.  
The manuscript Source Data includes the binned values used for plotting.  
The following scripts generate the binned data and figure panels from the raw RPM records.


## PCA of transcriptome profiles across missions and tissues (Supplementary Figure S2)

This directory includes the script used to generate the all-sample PCA shown in Supplementary Fig. S2.

## Web-rendered bar-graph panels

Some graph panels in the manuscript are screenshots from the ibSLS web interface, including gene-expression panels (Figs. 4c, 5d, and 7c; Supplementary Fig. S3b) and metabolite-abundance panels (Figs. 4f and 6d; Supplementary Fig. S4a-e).  
The underlying numerical values are provided as Source Data, whereas standalone plotting scripts are not provided for these web-rendered panels.

## Core software

| Software | Version | Purpose | Ref. | 
|---|---|---|---|
| R | [xxx] | Data processing  and statistical analysis | [1] | 
| tidyverse | [xxx] | Data manipulation in `03_merge_expression.R` | [2] | 
| dplyr | [xxx] | Data manipulation in `03_merge_expression.R` | [3] | 
| stringr | [xxx] | String handling in `03_merge_expression.R` | [4] | 
| gtools | [xxx] | Mixed sorting of file names in `03_merge_expression.R` | [5] | 
| ggplot2 | [xxx] | Data visualization | [6] | 

## References

[1] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[2] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H. *Welcome to the 
tidyverse*. Journal of Open Source Software. 2019;4(43):1686. doi:10.21105/joss.01686

[3] Wickham H, François R, Henry L, Müller K, Vaughan D. *dplyr: A Grammar of Data Manipulation*. R package.

[4] Wickham H. *stringr: Simple, Consistent Wrappers for Common String Operations*. R package.

[5] Warnes GR, Bolker B, Lumley T. *gtools: Various R Programming Tools*. R package.

[6] Wickham H. *ggplot2: Elegant Graphics for Data Analysis*. Springer-Verlag New York; 2016.

