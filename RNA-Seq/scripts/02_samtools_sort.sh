#!/usr/bin/env bash
set -euo pipefail

# Sort and index a BAM file using samtools.
#
# Required software:
#   - samtools
#
# Example:
#   bash 02_samtools_sort.sh \
#     /path/to/input.bam \
#     /path/to/output.sorted.bam \
#     20

INPUT_BAM="$1"
OUTPUT_BAM="$2"
THREADS="${3:-20}"

samtools sort \
  -@ "${THREADS}" \
  -o "${OUTPUT_BAM}" \
  "${INPUT_BAM}"

samtools index -@ "${THREADS}" "${OUTPUT_BAM}"
