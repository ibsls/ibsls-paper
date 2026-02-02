#!/bin/bash
set -eux

bams=(*_vM20.STAR.genome.bam)
bam=${bams[$SLURM_ARRAY_TASK_ID-1]}
base=$(basename ${bam} .STAR.genome.bam)


module load samtools/1.8
samtools sort \
	-@ 4 \
	-o ${base}.STAR.genome.sort.bam \
	${bam} 

samtools index \
	${base}.STAR.genome.sort.bam

rm ${bam}

echo "fin"
