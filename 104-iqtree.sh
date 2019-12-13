#!/bin/bash -l
# NOTE the -l flag!
# Mac says: I have no idea why this is here.

# Name of the job 
#SBATCH -J iqtree

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

#Memory allocation
#SBATCH --mem=12G


# hostname is just for debugging
hostname
export OMP_NUM_THREADS=$SLURM_NTASKS
module load benchmarks

# The main job executable to run: note the use of srun before it
# IQ-Tree output   --prefix STRING      Prefix for all output files (default: aln/partition)
# Using this base path_to_iqtree -s test.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000
# Can automatically select the number of cores with -nt
#srun /home/maccamp/bin/iqtree -nt -s outputs/100/test3.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000


srun /home/maccamp/bin/iqtree -nt -s outputs/100/test4p.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000
srun /home/maccamp/bin/iqtree -nt -s outputs/100/test4-maf05p.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000
srun /home/maccamp/bin/iqtree -nt -s outputs/100/test4-maf10p.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000


srun /home/maccamp/bin/iqtree -nt -s outputs/100/test5p.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000
srun /home/maccamp/bin/iqtree -nt -s outputs/100/test5-maf05p.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000
srun /home/maccamp/bin/iqtree -nt -s outputs/100/test5-maf10p.asc.phy -st DNA -m GTR+G4+F+ASC -bb 1000 -alrt 1000

