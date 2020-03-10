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
#Generic here

#SBATCH --partition=med
#SBATCH --nodes=1
# #SBATCH --ntasks-per-node=1
# #SBATCH --ntasks=24
#SBATCH --ntasks=1
#SBATCH --time=3-01:00:00 #run for three days and an hour

#Memory allocation
#SBATCH --mem=32G

# Standard out and Standard Error output files with the job number in the name.
#SBATCH -o bench-%j.out
#SBATCH -e bench-%j.err

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

#Now I have SE rad
# SRR5933416.1.fastq 
# SRR5933417.1.fastq
# SRR5933432.1.fastq
# SRR5933433.1.fastq

#Generate sorted bam the same way
#I ended up running this at the command line: srun --nodes=1 --time=14:00:00 --partition=high
#srun --nodes=1 --time=14:00:00 --mem=32G --partition=high bwa mem genome/omyV6Chr.fasta data/SRR5933416.1.fastq | samtools view -Sb | samtools sort - -o bams/SRR5933416.1.fastq.sort.bam;
#srun --nodes=1 --time=14:00:00 --mem=32G --partition=high bwa mem genome/omyV6Chr.fasta data/SRR5933417.1.fastq | samtools view -Sb | samtools sort - -o bams/SRR5933417.1.fastq.sort.bam;
#srun --nodes=1 --time=14:00:00 --mem=32G --partition=high bwa mem genome/omyV6Chr.fasta data/SRR5933432.1.fastq | samtools view -Sb | samtools sort - -o bams/SRR5933432.1.fastq.sort.bam;
#srun --nodes=1 --time=14:00:00 --mem=32G --partition=high bwa mem genome/omyV6Chr.fasta data/SRR5933433.1.fastq | samtools view -Sb | samtools sort - -o bams/SRR5933433.1.fastq.sort.bam;


#For SE proper pairing and removing duplicates doesn't apply
#srun samtools view -f 0x2 -b bams/PCT_PPP1_01_R1.sort.bam	| samtools rmdup - bams/PCT_PPP1_01_R1.sort.flt.bam;
