# Reference preparation

This directory documents the reference files and commands used to prepare the RSEM reference for the RNA-seq workflow in the ibSLS database.

## Overview

The reference was prepared using `rsem-prepare-reference --star`, which generates the RSEM reference files together with STAR-compatible index files.

## Source files

The following source files were used:

| label |	file_name | type | source | role | note | URL | 
|---|---|---|---|---|---|---|
| genome_fasta | mm10_no_alt_analysis_set_ENCODE.fasta | FASTA | ENCODE	reference genome | mouse genome | FASTA	| [1] |
| gene_annotation | gencode.vM20.basic.annotation.gtf | GTF | GENCODE vM20 basic	gene annotation | mouse gene annotation | [2] |

[1] https://www.encodeproject.org/files/mm10_no_alt_analysis_set_ENCODE/@@download/mm10_no_alt_analysis_set_ENCODE.fasta.gz

[2] https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M20/gencode.vM20.basic.annotation.gtf.gz


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
