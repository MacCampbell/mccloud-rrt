# mccloud-rrt
Phylogenetics of McCloud River Redband Trout    

### Structure

ddd-xxx-xxx.xx - scripts in order   
/outputs/ddd - outputs from analysis scripts (in .gitignore)   
/bams/ - bams (in .gitignore)   
/bamlists - bamlists   

### Bamlists
test.bamlist - 18 individuals
test2.bamlist - test.bamlist plus:   
  Hatchery Strains (2 of each if possible. MTSH and MTWS are low coverage, did not include, total = 6)  
  Lower Stanislaus (1)
  N. Fork American (2 of the highest coverage ones based on file size)
  EGLK (1 more, total = 3, based on overall file size)
  GLRT (2 from Buck Creek as the last few in the population seemed less admixed, but may be do to coverage)
  GLRT (6 from the Pit River in three collections based on size and perceived coverage)
  WLRT (1 more from Dimsal for total=3)
  CAGT (four more from two sites, total =6)
  LKGT (four more from two sites, total =6)
  KRNB (3 more from two sites, total =5)
  MMRT ( from more divergent lineages based on figure 7 from report )  
  2 from Dry Creek based on size    
  2 from Edson Creek based on size
  2 from Moosehead (one not present due to low coverage)   
  MRRT totals 8   

test3.bamlist - like test2 but.   
   Fixed the GLRT dismal collections in bams and bamlist (only two included previously)
   Dropped KRNB_UCHG_02
   Dropped KRNB_CHGC_02
   Dropped DryCreek REDB_DRYC_01_RA.sort.flt.bam REDB_DRYC_03_RA.sort.flt.bam (Questions about recent movement)?    
   Dropped Parker Creek

test4.bamlist - added LCT_GACR_10_R1.sort.flt.bam and PCT_PPP1_01_R1.sort.flt.bam for outgroups

## 100 Series
1. 101-call-genos-for-tree.sh   
2. 102-convert-to-phylip.R   
At this point, converting heterozygous sites to ambiguities leads to sites considered invariant (121883 in the test data set out of 221576).  
3. 103-remove-invariant.py - produces a *.asc.phy file with the invariant sites removed for concatenated analysis with ascertainment bias correction.  
4. 104-iq-tree.sh - basic script to run concatenated analysis with IQ-TREE including ascertainment bias correction and 1000 rapid bootstraps with GTR+G(4).  

TBD.  To run SVDQuartets, we need a nexus block and PAUP*. Doing this by hand at this time, see test.nex. Also, IQ-TREE webserver has a RAM limit I hit with test2 (51 inds)

## 200 Series
Here I have identified several loci to try for species tree anlysis. I have then written up angsd to make a vcf restricted to those basic site ranges. Then the FastaAlternateReferenceMaker may work.   

