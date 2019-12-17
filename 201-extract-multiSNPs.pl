#! /usr/bin/perl -w

# Usage
# $ ./201-extract-multiSNPs.pl outputs/200/200-truncs2.tsv

# We have data like:
#Chrom  Trunc1  Trunc2    Left   Right  SNPs  Diff Locus Density
#   <chr>   <dbl>   <dbl>   <dbl>   <dbl> <dbl> <dbl> <int>   <dbl>
# 1 omy01   46000   47000   46826   47039     2   213     1 0.00939

# We need to (1) get the sequence part
# Then, (2) get the variants inserted into it....
my $sep="\t";

my $in=shift;
my @file=();


open (INFILE, "<", $in) or die "Can't open $in\n";

while(<INFILE>) {
  chomp;
  next if (/^Chrom/);   #Skipping the first line
  #Chrom   Trunc1  Trunc2  Left    Right   SNPs    Diff    Locus   Density
  push(@file, $_);
  
}

close(INFILE);

my @seqs=();

foreach my $line (@file) {
  my @a=split("\t", $line);
  my $seq = `samtools faidx genome/omyV6Chr.fasta $a[0]:$a[3]-$a[4]`; 
  # remove newlines
  push(@seqs, $seq);
}

my $seqFile="outputs/200/fastas.txt";

open (OUTFILE, ">", $seqFile);
print OUTFILE join ("\n", @seqs);
close (OUTFILE);

exit;

