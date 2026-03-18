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
#     /path/to/STAR/bin \
#     20
# Notes:
#   - `--star-gzipped-read-file` assumes gzipped FASTQ input.
#   - `--star-output-genome-bam` enables genome BAM output from STAR.
#   - `--strandedness reverse` assumes reverse-stranded RNA-seq libraries.

SAMPLE_ID="$1"
R1_FASTQ="$2"
R2_FASTQ="$3"
OUTDIR="$4"
REFERENCE_PREFIX="$5"
STAR_PATH="$6"
THREADS="${7:-20}"

mkdir -p "${OUTDIR}"

rsem-calculate-expression \
  --paired-end \
  --star \
  --star-gzipped-read-file \
  --star-path "${STAR_PATH}" \
  --star-output-genome-bam \
  --strandedness reverse \
  -p "${THREADS}" \
  "${R1_FASTQ}" \
  "${R2_FASTQ}" \
  "${REFERENCE_PREFIX}" \
  "${OUTDIR}/${SAMPLE_ID}"
