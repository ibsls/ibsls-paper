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

