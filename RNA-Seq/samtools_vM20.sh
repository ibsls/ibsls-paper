#!/bin/bash
#SBATCH --array=1-96
#SBATCH -D /home/jaxa/akihito.otsuki.bz/workdir/240215_mhu8/02_star_rsem
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=12G

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
