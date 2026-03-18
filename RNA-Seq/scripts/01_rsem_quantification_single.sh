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

SAMPLE_ID="$1"
FASTQ="$2"
OUTDIR="$3"
REFERENCE_PREFIX="$4"
THREADS="${5:-20}"

mkdir -p "${OUTDIR}"

rsem-calculate-expression \
  --star \
  --star-gzipped-read-file \
  -p "${THREADS}" \
  "${FASTQ}" \
  "${REFERENCE_PREFIX}" \
  "${OUTDIR}/${SAMPLE_ID}"
