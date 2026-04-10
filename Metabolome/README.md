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

This step extracts metabolite abundance values for predefined comparison groups from the larger metabolite quantification table and prepares compact comparison tables for downstream statistical testing.

Script:  `scripts/01_make_concentration_table.py`  
Input:   ` `
Output: ` `


## Differential abundance analysis

This script performs two-group comparison using an in-house Mann–Whitney U implementation and generates Differential abundance metabolite (DAM) result tables.

Script: `scripts/02_dam_calculation.py`
Input: ` ` 
Output: ` `


## Core software

| Software | Version | Purpose | Ref. |
|---|---|---|---|
| Python | [3.9] | Metabolome data processing and DAM analysis | [1] |

## References

[1] Python Software Foundation. *Python Language Reference*. Available at: https://www.python.org/

## Notes

Some file paths and execution settings were simplified from the original computational environment for public release.
Additional software and package versions should be added if external Python packages are used in the finalized metabolome workflow.
