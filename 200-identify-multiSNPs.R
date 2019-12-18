# May convert to executable

# Goals:
# 1: Identify snps within CDs
# 2: Identify multi-snp sequences if possible
# 3: Remove tetrasomically-inherited genomic regions
# 4: Create sequences for species tree analysis (followed by netowrk analysis)

library(tidyverse)

#gff<-read_tsv(file="genome/chromos-omy01.gff3", skip = 1, col_names = FALSE)
#cds<-filter(gff, X3=="CDS") %>% select(X1, X4,X5) %>% rename("Chrom"=X1, "Start"=X4, "End"=X5)

genos<-read_tsv(file="outputs/100/test5-maf05p.geno.gz",  col_names = FALSE)  %>% 
  rename("Chrom"=X1, "Site"=X2) %>% mutate(Coord=paste(Chrom,Site, sep="-"))
#Remove inversion zones
omy05<-genos %>% filter(Chrom == "omy05" &  Site >= 27001895 & Site <= 81791946) %>% mutate(Coord=paste(Chrom,Site,sep="-")) %>% select(Coord)
omy20<-genos %>% filter(Chrom == "omy20" &  Site >= 5446054  & Site <= 18985808) %>% mutate(Coord=paste(Chrom,Site,sep="-")) %>% select(Coord)
genos<-genos %>% filter(!Coord %in% omy05$Coord) %>% filter(!Coord %in% omy20$Coord) %>% select(-Coord)


#Identifying RAD Loci
truncs <- genos %>% select(Chrom, Site) %>% group_by(Chrom) %>% mutate(Next=lead(Site,1)) %>%
  mutate(Length=Next-Site) %>% mutate(Trunc1=(Site %/% 1000) * 1000) %>%
  mutate(Trunc2 = (Next %/% 1000) * 1000) %>% mutate(SnpDiff= Next-Site)

#Find SNPs in a RAD locus
truncs2 <- truncs %>% filter(SnpDiff < 600) %>% group_by(Chrom, Trunc1, Trunc2) %>% 
  summarise(Left=min(Site), Right=max(Next), SNPs=n()+1) %>% mutate(Diff=Right-Left) %>%
  ungroup() %>%
  mutate(Locus=row_number()) %>%
  mutate(Density=SNPs/Diff) %>% filter(Density < 0.05)

# We can generate sequences now.
# Randomly sampling 100
# But, we still need to subsitute the proper variants into the resulting sequences....
loci<-sample_n(truncs2, 1000) %>% arrange(Locus)
write_tsv(loci, path="outputs/200/200-truncs2.tsv")
write_tsv(select(loci, Chrom, Left, Right), col_names = FALSE, path="outputs/200/200-ranges.tsv")