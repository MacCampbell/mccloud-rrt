#! /bin/bash

# Goal is to have a fasta alignment
# this is combined with a nexus block for MrBayes
# Then, a series of tree searches are done.

# 1303-batch-mb.sh genelist.txt

# set up nexus files
# for f in *.afas.trim; do seqConverter.pl -d$f -on; done;
# perl -pi -e 's/nucleotide/DNA/g' *afas.nex


list=$1
wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 

do

string="sed -n ${x}p ${list}" 
str=$($string)

var=$(echo $str | awk -F"\t" '{print $1, $2}')   
        set -- $var
        c1=$1
        c2=$2

echo "#! /bin/bash -l

module load bio/MrBayes/3.2.6-pic-intel-2016b 

mb ${c1}.afas.nex control.nex

" > ${c1}.sh

sbatch --partition=bio --ntasks=1 --tasks-per-node=1 -t 2-10:00:00 --mem=214G ${c1}.sh
      
       x=$(( $x + 1 ))

done