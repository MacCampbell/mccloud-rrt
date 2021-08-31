#!/bin/bash
#Replace barcode with a name.
#Usage
#bash ~/mccloud-rrt/1102.1-rename.sh ../radmeta-unixbreaks.csv


file=$1
n=$(wc -l ${file} | awk '{print $1}')
x=1

while [ ${x} -le ${n} ] #This can be adjusted based on number of files
do

        string="sed -n ${x}p $file" #The file here represents whatever metadate file contains column
        str=$($string)

        var=$(echo $str | awk -F"," '{print $1,$2,$3,$4,$5,$6,$7}')   
        set -- $var
        c1=$1 #is RA or RB for me
        c2=$2 #barcode 1
        c3=$3 #barcode 2
        c4=$4 #plate
        c5=$5 #nmfs
        c6=$6 #Watershed
        c7=$7 #code
        #SOMM085_S2_L002_TGGCGA_RA_GGAAGAGATCTGCAGG.fastq
       # mv BMAG057_GTGGCC_RA_GG${c3}TGCAGG.fastq ${c4}_RA.fastq
       # mv BMAG057_GTGGCC_RB_GG${c3}TGCAGG.fastq ${c4}_RB.fastq
         mv SOMM085_S2_L002_${c2}_${c1}_GG${c3}TGCAGG.sort.flt.bam ${c6}-${c5}_${c1}.sort.flt.bam

        x=$(( $x + 1 )) #This will loop the file to the next line

done
