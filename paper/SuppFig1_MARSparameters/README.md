# Mission-specific centrifuge parameters for artificial gravity loading
Raw RPM records underlying Supplementary Fig. 1 are provided as Supplementary Data associated with the paper.  
The manuscript Source Data includes the binned values used for plotting.  
The following scripts generate the binned data and figure panels from the raw RPM records.

- `scripts/SuppFig1a_MHU1_RPM_plot.R`
- `scripts/SuppFig1b_MHU2_RPM_plot.R`
- `scripts/SuppFig1c_MHU4_RPM_plot.R`
- `scripts/SuppFig1d_MHU5_RPM_plot.R`

## Input data
Each script expects the corresponding raw RPM record files, as provided in the Supplementary Data 10-13.

## Output
Each script produces:
- `a CSV file containing the binned RPM values used for plotting`
- `a PDF file containing the corresponding figure panel`

## Example
```bash
Rscript scripts/SuppFig1a_MHU1_RPM_plot.R
```

## Expected output
Example output files:
- `SourceData_SuppFigS1a.csv`
- `MHU-1.bin10s.pdf`

## Environment

The scripts were developed and tested in the following environment:

| Software | Version | Purpose | Ref. | 
|---|---|---|---|
| R | 4.1.2 | Data processing  and statistical analysis | [1] | 
| tidyverse | 1.3.1 | Data manipulation | [2] | 
| dplyr | 1.0.8 | Data manipulation | [3] | 
| lubridate | 1.8.0 | Date handling | [4] | 
| ggplot2 | 3.3.5 | Data visualization | [5] | 

## Installation

Install the required R packages before running the scripts:

```r
install.packages(c("tidyverse", "dplyr", "lubridate", "ggplot2", "ggsci"))
```

## Expected run time
On a typical desktop computer, each RPM plotting script should complete within a few seconds.

## References

[1] R Core Team. *R: A language and environment for statistical computing*. R Foundation for Statistical Computing, Vienna, Austria.

[2] Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L, Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.” _Journal of Open Source Software_, *4*(43), 1686. doi:10.21105/joss.01686.

[3] Wickham H, François R, Henry L, Müller K, Vaughan D (2026). _dplyr: A Grammar of Data Manipulation_. doi:10.32614/CRAN.package.dplyr. 

[4] Garrett Grolemund, Hadley Wickham (2011). Dates and Times Made Easy with lubridate. Journal of Statistical Software, 40(3), 1-25. 

[5] H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016.

## Notes
- Raw RPM records are aggregated into fixed-size bins within each script before plotting.
- Median elapsed time and median RPM per bin are used for visualization.
- The shaded interval in each plot corresponds to the period used for summary-statistics calculation in the manuscript.

