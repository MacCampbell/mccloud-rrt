# mccloud-rrt
Phylogenetics of McCloud River Redband Trout    

### Structure

ddd-xxx-xxx.xx - scripts in order   
/outputs/ddd - outputs from analysis scripts (in .gitignore)   
/bams/ - bams (in .gitignore)   
/bamlists - bamlists   

## 100 Series
1. 101-call-genos-for-tree.sh   
2. 102-convert-to-phylip.R   
At this point, converting heterozygous sites to ambiguities leads to sites considered invariant (121883 in the test data set out of 221576).  
3. 103-remove-invariant.py - produces a *.asc.phy file with the invariant sites removed for concatenated analysis with ascertainment bias correction.  
4. 104 - TBD.  To run SVDQuartets, we need a nexus block and PAUP*. Doing this by hand at this time, see test.nex. 
