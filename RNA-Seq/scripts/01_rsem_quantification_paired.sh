#!/usr/bin/env bash
set -euo pipefail

# Run RSEM-based expression quantification for paired-end RNA-seq data.
# Read mapping is performed internally with STAR via the --star option.
#
# Required software:
#   - RSEM
#   - STAR
#
# Example:
#   bash 01_rsem_quantification_paired.sh \
#     MHU001 \
#     /path/to/MHU001_R1.fastq.gz \
#     /path/to/MHU001_R2.fastq.gz \
#     /path/to/results \
#     /path/to/references/mm10_vM20 \
#     20

SAMPLE_ID="$1"
R1_FASTQ="$2"
R2_FASTQ="$3"
OUTDIR="$4"
REFERENCE_PREFIX="$5"
THREADS="${6:-20}"

mkdir -p "${OUTDIR}"

rsem-calculate-expression \
  --paired-end \
  --star \
  --star-gzipped-read-file \
  -p "${THREADS}" \
  "${R1_FASTQ}" \
  "${R2_FASTQ}" \
  "${REFERENCE_PREFIX}" \
  "${OUTDIR}/${SAMPLE_ID}"
