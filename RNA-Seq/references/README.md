# Reference preparation

This directory documents the reference files and commands used to prepare the RSEM reference for the RNA-seq workflow in the ibSLS database.

## Overview

The reference was prepared using `rsem-prepare-reference --star`, which generates the RSEM reference files together with STAR-compatible index files.

## Source files

The following source files were used:

| File_name | Type | Source | Role  | URL | 
|---|---|---|---|---|
| mm10_no_alt_analysis_set_ENCODE.fasta | FASTA | ENCODE	 | mouse reference genome | [1] |
| gencode.vM20.basic.annotation.gtf | GTF | GENCODE  | vM20 basic	gene annotation |  [2] |

[1] https://www.encodeproject.org/files/mm10_no_alt_analysis_set_ENCODE/@@download/mm10_no_alt_analysis_set_ENCODE.fasta.gz

[2] https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M20/gencode.vM20.basic.annotation.gtf.gz

## Derived annotation table

The following annotation table was derived from the GTF file. This table is not required for RSEM reference construction itself, but was retained as a companion annotation resource for downstream use in ibSLS.  

| File_name | Derived from | Description |
|---|---|---|
| idlist_vM20.tsv | gencode.vM20.basic.annotation.gtf | Tab-delimited table containing ENSEMBLE gene IDs, gene symbols, and related annotation fields extracted from the GTF file |

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

## Expected run time

Each step typically requires several hours per sample, depending on read depth and computing environment.

## Note

Reference index files are not included in this repository.
Please rebuild them locally using the source FASTA/GTF files and `build_index.sh`.
