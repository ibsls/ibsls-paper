# Software versions

This file summarizes the main software tools used for RNA-seq data processing in the ibSLS database.

## Core software

| Software | Version | Purpose | Ref. | Note |
|---|---|---|---|---|
| STAR | 2.6.1d | RNA-seq reference preparation and read mapping. Used with `rsem-prepare-reference --star` and `rsem-calculate-expression --star`. | [1] | 
| RSEM | 1.3.1 | RNA-seq reference preparation and expression quantification. Used with `rsem-prepare-reference --star` and `rsem-calculate-expression --star`.  | [2] | 
| samtools | [xxx] | BAM sorting and indexing | [3] | 
| R | [xxx] | Data processing  and statistical analysis | [4] | 
| tidyverse | [xxx] | Data manipulation in `03_merge_expression.R` | [5] | 
| dplyr | [xxx] | Data manipulation in `03_merge_expression.R` | [6] | 
| stringr | [xxx] | String handling in `03_merge_expression.R` | [7] | 
| gtools | [xxx] | Mixed sorting of file names in `03_merge_expression.R` | [8] | 
| DESeq2 | [xxx] | Differential expression analysis | [9] | 
| ggplot2 | [xxx] | Data visualization | [10] | 

## References

[1] Dobin A, Davis CA, Schlesinger F, Drenkow J, Zaleski C, Jha S, Batut P, Chaisson M, Gingeras TR. *STAR: ultrafast universal RNA-seq aligner*. Bioinformatics. 2013;29(1):15-21. doi:10.1093/bioinformatics/bts635

[2] Li B, Dewey CN. *RSEM: accurate transcript quantification from RNA-Seq data with or without a reference genome*. BMC Bioinformatics. 2011;12:323. doi:10.1186/1471-2105-12-323

[3] Danecek P, Bonfield JK, Liddle J, Marshall J, Ohan V, Pollard MO, Whitwham A, Keane T, McCarthy SA, Davies RM, Li H. *Twelve years of SAMtools and BCFtools*. GigaScience. 2021;10(2):giab008. doi:10.1093/gigascience/giab008

[4] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[5] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H. *Welcome to the 
tidyverse*. Journal of Open Source Software. 2019;4(43):1686. doi:10.21105/joss.01686

[6] Wickham H, François R, Henry L, Müller K, Vaughan D. *dplyr: A Grammar of Data Manipulation*. R package.

[7] Wickham H. *stringr: Simple, Consistent Wrappers for Common String Operations*. R package.

[8] Warnes GR, Bolker B, Lumley T. *gtools: Various R Programming Tools*. R package.

[9] Love MI, Huber W, Anders S. *Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2*. Genome Biology. 2014;15(12):550. doi:10.1186/s13059-014-0550-8

[10] Wickham H. *ggplot2: Elegant Graphics for Data Analysis*. Springer-Verlag New York; 2016.
