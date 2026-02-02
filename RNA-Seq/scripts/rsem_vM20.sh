#!/bin/bash

set -eux

fqs=(*_1.fastq.gz)
fq=${fqs[$SLURM_ARRAY_TASK_ID-1]}
base=$(basename ${fq} _1.fastq.gz)

##previous ver
#RSEMv1.3.1
#STARv2.6.1d

module load RSEM/1.3.1
module load STAR/2.6.1d


rsem-calculate-expression \
	--star \
	--star-path /usr/local/software/ubuntu-20.04/bioinfo/STAR/2.6.1d/bin/ \
	--star-gzipped-read-file \
	--star-output-genome-bam \
	--strandedness reverse \
	-p 2 \
	${base}_1.fastq.gz \
	${base}_2.fastq.gz \
	./vM20/mm10_vM20 \
	${base}_vM20 \
	--paired-end

echo "fin"

	
	
	
	
