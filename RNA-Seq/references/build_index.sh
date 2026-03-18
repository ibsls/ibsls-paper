#!/usr/bin/env bash
set -euo pipefail

# Build the RSEM reference for the RNA-seq workflow used in the ibSLS paper.
# STAR-compatible index files are generated through rsem-prepare-reference --star.
#
# Required input files:
#   - mm10_no_alt_analysis_set_ENCODE.fasta
#   - gencode.vM20.basic.annotation.gtf
#
# Required software:
#   - RSEM
#   - STAR
#
# Example:
#   bash build_index.sh

FASTA="mm10_no_alt_analysis_set_ENCODE.fasta"
GTF="gencode.vM20.basic.annotation.gtf"
PREFIX="mm10_vM20"

rsem-prepare-reference \
  --gtf "${GTF}" \
  --star \
  "${FASTA}" \
  "${PREFIX}"
