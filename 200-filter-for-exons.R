# May convert to executable

# Goal is to identify snps within CDs
#$ genome mac$ grep "omy01" CIGENEomyV6-genes-longestTranscripts.gff3 > chromos-omy01.gff3

library(tidyverse)

gff<-read_tsv(file="genome/chromos-omy01.gff3", skip = 1, col_names = FALSE)
cds<-filter(gff, X3=="CDS") %>% select(X1, X4,X5) %>% rename("Chrom"=X1, "Start"=X4, "End"=X5)

genos<-read_tsv(file="outputs/100/test.geno.gz",  col_names = FALSE) %>% filter(X1=="omy01") %>% 
  rename("Chrom"=X1, "Site"=X2)


coding_genos<-left_join(genos, cds, by=c('Chrom')) %>% 
    filter(Site >= Start, Site <= End)

coding_genos<-coding_genos[1:(dim(genos)[2]-1)]

#write to file
write_tsv(coding_genos, "outputs/200/200-filter-for-exons.txt")

#Wow, this is slow and cumbersome. I'm considering annotating the SNPs with SNPEff then filtering.

