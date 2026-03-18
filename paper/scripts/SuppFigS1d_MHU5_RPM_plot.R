
#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)

# Generate binned source data and a plot for Supplementary Figure S1d (MHU-5).
#
# Input:
#   - SupplementaryDataS4.txt
#
# Output:
#   - SourceData_SuppFigS1d.csv
#   - MHU-5.bin10s.pdf
#
# Notes:
#   - Raw RPM records are aggregated into 10-row bins.
#   - Median values of ElapsedDays and RPM are used for plotting.
#   - The shaded interval corresponds to the range used for summary statistics.

input_file <- "MHU-5_rpm.txt"
source_data_file <- "SourceData_SuppFigS1d.csv"
plot_file <- "MHU-5.bin10s.pdf"

d <- read.table(input_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE) %>%
  mutate(
    Date = as.POSIXct(paste(V1, V2), format = "%Y/%m/%d %H:%M:%S"),
    RPM = as.numeric(V3),
    ElapsedDays = as.numeric(Date - first(Date), units = "days")
  )

binned <- d %>%
  mutate(bin = (row_number() - 1) %/% 10) %>%
  group_by(bin) %>%
  summarise(
    ElapsedDays = median(ElapsedDays, na.rm = TRUE),
    RPM = median(RPM, na.rm = TRUE),
    .groups = "drop"
  )

write.csv(
  binned %>% select(ElapsedDays, RPM),
  source_data_file,
  quote = FALSE,
  row.names = FALSE
)

summary_df <- d %>%
  filter(ElapsedDays > 22 & ElapsedDays < 25) %>%
  summarise(
    mean_rpm = mean(RPM, na.rm = TRUE),
    sd_rpm = sd(RPM, na.rm = TRUE),
    max_rpm = max(RPM, na.rm = TRUE),
    min_rpm = min(RPM, na.rm = TRUE)
  )

print(summary_df)

pdf(plot_file)
g <- ggplot(binned, aes(x = ElapsedDays, y = RPM)) +
  geom_rect(
    xmin = 22, xmax = 25,
    ymin = 0, ymax = Inf,
    fill = "lightblue", alpha = 0.2,
    inherit.aes = FALSE
  ) +
  geom_line(linewidth = 0.2, na.rm = TRUE) +
  theme_bw() +
  theme(
    legend.position = "top",
    axis.ticks.length = grid::unit(-3, "pt"),
    axis.ticks = element_line(linewidth = 1),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1.5)
  ) +
  ylim(0, 80) +
  ggtitle("MHU-5, bin = 10 sec") +
  xlab("Days since the start of MARS") +
  ylab("Measured rotation speed [RPM]")
print(g)
dev.off()
