#!/bin/bash -l
# NOTE the -l flag!
# Mac says: I have no idea why this is here.

# Name of the job 
#SBATCH -J mapping

#Email myself
#SBATCH --mail-user=maccampbell@ucdavis.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

#Job level

#SBATCH --partition=med
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=8
#SBATCH --ntasks=24
#SBATCH --time=3-01:00:00 #run for three days and an hour

# Standard out and Standard Error output files with the job number in the name.
#SBATCH -o bench-%j.output
#SBATCH -e bench-%j.output

# hostname is just for debugging
hostname
export OMP_NUM_THREADS=$SLURM_NTASKS
module load benchmarks

# The main job executable to run: note the use of srun before it.
# Copying these commands from Ensieh for the LCT/PCT data for outgroups and lazily hard coding.
# Some locations are Paired-End it looks like though, and I'm trying:
# PPP1_01_R1.fastq.gz
# GACR_10_R1.fastq.gz
#	bwa mem ../ref_genome/omyV6Chr.fasta CAGT_ASHF_01_RA.fastq CAGT_ASHF_01_RB.fastq | samtools view -Sb - | samtools sort - -o CAGT_ASHF_01_RA.sort.bam 
# samtools view -f 0x2 -b CAGT_ASHF_01_RA.sort.bam | samtools rmdup - CAGT_ASHF_01_RA.sort.flt.bam

srun bwa mem genome/omyV6Chr.fasta data/GACR_10_R1.fastq.gz data/GACR_10_R2.fastq.gz	 | samtools view -Sb | samtools sort - -o bams/LCT_GACR_10_R1.sort.bam	
srun samtools view -f 0x2 -b bams/LCT_GACR_10_R1.sort.bam	| samtools rmdup - bams/LCT_GACR_10_R1.sort.flt.bam

#Boy I should parallelize this, but, naahhh. It's Friday. Now for PPP1_01_R1.fastq.gz
srun bwa mem genome/omyV6Chr.fasta data/PPP1_01_R1.fastq.gz data/PPP1_02_R1.fastq.gz	 | samtools view -Sb | samtools sort - -o bams/PCT_PPP1_01_R1.sort.bam	
srun samtools view -f 0x2 -b bams/PCT_PPP1_01_R1.sort.bam	| samtools rmdup - bams/PCT_PPP1_01_R1.sort.flt.bam

