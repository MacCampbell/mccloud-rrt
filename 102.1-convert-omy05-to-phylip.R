#! /usr/local/bin/RScript

# Basic script to convert *.geno.gz to a phylip file.
# Has now been generalized to take a *.geno.gz and print a phylip file to *.phy
# Afterwards, heterozygotes making invariant sites need to me removed, that is.
# Site 1 AAAAR Would be considered invariant by RAxML or IQ-TREE
# This version creates a phylip of only omy05 genotypes
# ./102.1-convert-omy05-to-phylip.R path-to-file file bamlist
# ./102.1-convert-omy05-to-phylip.R outputs/100/ test.geno.gz bamlists/test.bamlist

library(tidyverse)

args = commandArgs(trailingOnly=TRUE)
dir<-args[1]
file<-args[2]
bamlist<-args[3]
basename<-gsub(".geno.gz","",file)

genos<-read_tsv(file=paste(dir,file, sep=""), col_names = FALSE)
#Load meta
labels<-read_tsv(file=bamlist, col_names = FALSE) %>% 
  mutate(Sample=gsub("bams/","",X1)) %>% select(Sample)
labels$Sample<-gsub("_RA.sort.flt.bam","",labels$Sample)
labels$Sample<-gsub("_R1.sort.flt.bam","",labels$Sample)

#Now, we know about two inversion regions omy05 and omy20. Omy05 runs from 27001895-81791946,
#Omy20 runs from 5446054-18985808 Pearse et al. (2019). So, let's filter those out
# omy05<-genos %>% filter(X1 == "omy05" &  X2 >= 27001895 & X2 <= 81791946) (7393 variants)
# Removes 9100 sites in our test data.
genos<-genos %>% mutate(Site=paste(X1, X2, sep="-"))
omy05<-genos %>% filter(X1 == "omy05" &  X2 >= 27001895 & X2 <= 81791946)


seq<-select(omy05, -1:-2)
colnames(seq)<-labels$Sample
seq<-seq[1:(length(seq)-2)] #dropping two empty columns.

#Need to recode ambiguous sites.
#Hmm, I can do this with lapply tediously...

seq<-lapply(seq, function(x) { gsub("AA", "A", x) } )
seq<-lapply(seq, function(x) { gsub("GG", "G", x) } )
seq<-lapply(seq, function(x) { gsub("CC", "C", x) } )
seq<-lapply(seq, function(x) { gsub("TT", "T", x) } )

#Missing data
seq<-lapply(seq, function(x) { gsub("NN", "N", x) } )

#IUPAC Ambigs 
#M	A or C
seq<-lapply(seq, function(x) { gsub("AC", "M", x) } )
seq<-lapply(seq, function(x) { gsub("CA", "M", x) } )

#R	A or G	
seq<-lapply(seq, function(x) { gsub("AG", "R", x) } )
seq<-lapply(seq, function(x) { gsub("GA", "R", x) } )

#W	A or T	
seq<-lapply(seq, function(x) { gsub("AT", "W", x) } )
seq<-lapply(seq, function(x) { gsub("TA", "W", x) } )

#S	C or G	
seq<-lapply(seq, function(x) { gsub("CG", "S", x) } )
seq<-lapply(seq, function(x) { gsub("GC", "S", x) } )

#Y	C or T	
seq<-lapply(seq, function(x) { gsub("CT", "Y", x) } )
seq<-lapply(seq, function(x) { gsub("TC", "Y", x) } )

#K	G or T
seq<-lapply(seq, function(x) { gsub("GT", "K", x) } )
seq<-lapply(seq, function(x) { gsub("TG", "K", x) } )

conv<-as.data.frame(seq)
trans<-t(conv)
rownames(trans)<-paste(paste(rownames(trans), "\t", sep="\t"))

#Does require a little annotation to get the final phylip format (inds/sites)
characters<-dim.data.frame(conv)[1]
inds<-dim.data.frame(conv)[2]
write(cbind(inds, characters)[1:2], file=paste(dir,basename,"-omy05",".phy",sep="")) #put header in
write.table(trans, file=paste(dir,basename,"-omy05",".phy",sep=""), append=TRUE, quote = FALSE, sep="", row.names = TRUE, col.names=FALSE)

#Then a lot of sites need to be removed for proper ascertainment bias correction (e.g. https://groups.google.com/forum/#!topic/raxml/MqzNeIcTBpo)

