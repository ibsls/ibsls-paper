#!/usr/bin/env bash
set -euo pipefail

# Run RSEM-based expression quantification for single-end RNA-seq data.
# Read mapping is performed internally with STAR via the --star option.
#
# Required software:
#   - RSEM
#   - STAR
#
# Example:
#   bash 01_rsem_quantification_single.sh \
#     MHU002 \
#     /path/to/MHU002.fastq.gz \
#     /path/to/results \
#     /path/to/references/mm10_vM20 \
#     20
# Notes:
#   - `--star-gzipped-read-file` assumes gzipped FASTQ input.
#   - `--star-output-genome-bam` enables genome BAM output from STAR.
#   - `--strandedness reverse` assumes reverse-stranded RNA-seq libraries.

SAMPLE_ID="$1"
FASTQ="$2"
OUTDIR="$3"
REFERENCE_PREFIX="$4"
STAR_PATH="$5"
THREADS="${6:-20}"

mkdir -p "${OUTDIR}"

rsem-calculate-expression \
  --star \
  --star-path "${STAR_PATH}" \
  --star-gzipped-read-file \
  --star-output-genome-bam \
  --strandedness reverse \
  -p "${THREADS}" \
  "${FASTQ}" \
  "${REFERENCE_PREFIX}" \
  "${OUTDIR}/${SAMPLE_ID}"
