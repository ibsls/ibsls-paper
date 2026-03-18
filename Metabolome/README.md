# Metabolome workflow

This directory contains scripts and documentation for metabolome data processing used in the ibSLS project.

## Overview

The workflow includes:

1. generation of group-wise abundance tables from metabolite quantification results
2. statistical testing for two-group comparison
3. generation of differential abundance metabolite (DAM) result tables

## Directory structure

- `scripts/`: metabolome data processing and comparison scripts

## Generation of abundance tables

Group-wise abundance tables were generated using:

- `scripts/01_make_abundance_table.py`  まだ

This step extracts metabolite abundance values for predefined comparison groups from the larger metabolite quantification table and prepares compact comparison tables for downstream statistical testing.

## Differential abundance analysis

Differential abundance metabolite (DAM) analysis was performed using:

- `scripts/02_MannU_DAMAnalysis.py`

This script performs two-group comparison using an in-house Mann–Whitney U implementation and generates DAM result tables.

The core `mannwhitneyu()` implementation in `02_MannU_DAMAnalysis.py` is based on the original in-house script used in the ibSLS metabolome workflow.
Additional helper functions and command-line input/output handling were added for public release.

## Core software

| Software | Version | Purpose | Ref. |
|---|---|---|---|
| Python | [xxx] | Metabolome data processing and DAM analysis | [1] |

## References

[1] Python Software Foundation. *Python Language Reference*. Available at: https://www.python.org/

## Notes

Some file paths and execution settings were simplified from the original computational environment for public release.
Additional software and package versions should be added if external Python packages are used in the finalized metabolome workflow.
