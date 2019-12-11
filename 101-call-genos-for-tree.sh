#!/bin/bash -l
# NOTE the -l flag!
# Mac says: I have no idea why this is here.

# Name of the job 
#SBATCH -J angsdgenos

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
#SBATCH --time=1-01:00:00 #run for a day and an hour

# Standard out and Standard Error output files with the job number in the name.
#SBATCH -o bench-%j.output
#SBATCH -e bench-%j.output

# hostname is just for debugging
hostname
export OMP_NUM_THREADS=$SLURM_NTASKS
module load benchmarks

# The main job executable to run: note the use of srun before it
#Including triallelic SNPS and creating a .vcf.
#Experience seg fault. Removing -doVcf 1 and just using -doGeno 4 
#Not considering a minMaf at this time.

#for first test data set
#srun angsd -P 24 -b bamlists/test.bamlist -minInd 16 -ref genome/omyV6Chr.fasta -out outputs/100/test -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.out 2> outputs/100/101.err

#for second test data set
#srun angsd -P 24 -b bamlists/test2.bamlist -minInd 46 -ref genome/omyV6Chr.fasta -out outputs/100/test2 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.out 2> outputs/100/101.err

#for third test data set
#srun angsd -P 24 -b bamlists/test3.bamlist -minInd 42 -ref genome/omyV6Chr.fasta -out outputs/100/test3 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.out 2> outputs/100/101.err

#for fourth test data set, with and without minMaf
srun angsd -P 24 -b bamlists/test4.bamlist -minInd 43 -ref genome/omyV6Chr.fasta -out outputs/100/test4 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.out 2> outputs/100/101.err

srun angsd -P 24 -b bamlists/test4.bamlist -minInd 43 -ref genome/omyV6Chr.fasta -out outputs/100/test4-maf05 -minMaf 0.05 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.05.out 2> outputs/100/101.05.err

srun angsd -P 24 -b bamlists/test4.bamlist -minInd 43 -ref genome/omyV6Chr.fasta -out outputs/100/test4-maf10 -minMaf 0.10 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.10.out 2> outputs/100/101.10.err

#for fifth test data set, with and without minMaf
srun angsd -P 24 -b bamlists/test5.bamlist -minInd 18 -ref genome/omyV6Chr.fasta -out outputs/100/test5 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.out 2> outputs/100/101.err

srun angsd -P 24 -b bamlists/test5.bamlist -minInd 18 -ref genome/omyV6Chr.fasta -out outputs/100/test5-maf05 -minMaf 0.05 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.05.out 2> outputs/100/101.05.err

srun angsd -P 24 -b bamlists/test5.bamlist -minInd 18 -ref genome/omyV6Chr.fasta -out outputs/100/test5-maf10 -minMaf 0.10 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -skipTriallelic 0 -SNP_pval 1e-6 -doGeno 4 -doPost 1 > outputs/100/101.10.out 2> outputs/100/101.10.err
