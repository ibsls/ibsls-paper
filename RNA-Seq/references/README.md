# Reference preparation

This directory documents the reference files and commands used to prepare the RSEM reference for the RNA-seq workflow in the ibSLS database.

## Overview

The reference was prepared using `rsem-prepare-reference --star`, which generates the RSEM reference files together with STAR-compatible index files.

## Source files

The following source files were used:

- genome FASTA: `mm10_no_alt_analysis_set_ENCODE.fasta`
- gene annotation GTF: `gencode.vM20.basic.annotation.gtf`

These source files are not redistributed in this repository.

## Build script

Reference construction is described in:

- `build_index.sh`

## Output

Running `build_index.sh` generates the RSEM reference files with the prefix:

- `mm10_vM20`

When `--star` is used, STAR-compatible index files are also generated as part of the same reference preparation step.

## Build log

A STAR genome generation log from the original analysis environment is provided in:

- `logs/mm10_vM20Log.out`

This log is included as supplementary provenance information.

## Note

Reference index files are not included in this repository.
Please rebuild them locally using the source FASTA/GTF files and `build_index.sh`.
