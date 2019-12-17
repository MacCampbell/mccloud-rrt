#!/bin/bash -l
# NOTE the -l flag!
# Mac says: I have no idea why this is here.

# Name of the job 
#SBATCH -J angsd-vcfs

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
srun angsd -P 24 sites index outputs/200/200-ranges.tsv

srun angsd -P 24 -b bamlists/test4.bamlist -minInd 43 -anc genome/omyV6Chr.fasta -out outputs/100/test4-maf05p -minMaf 0.05 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -doGeno 4 -doPost 1 -postCutoff 0.95 -sites outputs/200/200-ranges.tsv > outputs/200/202.05.out 2> outputs/200/202.05.err

srun angsd -P 24 -b bamlists/test5.bamlist -minInd 18 -anc genome/omyV6Chr.fasta -out outputs/100/test5-maf05p -minMaf 0.05 -minMapQ 30 -minQ 20 -GL 1 -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -doGeno 4 -doPost 1 -postCutoff 0.95 -sites outputs/200/200-ranges.tsv > outputs/200/202.05.out 2> outputs/200/202.05.err
