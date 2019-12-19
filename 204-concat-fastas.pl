#! /usr/bin/perl -w

# We have numerous fastas named by sample, e.g. "ind0" that correspond to a bamlist. It would be nice to 
# have the files so that they are named by locus with individuals in each file as nexus files.
# working in: /Users/mac/github/mccloud-rrt/outputs/200/splits/fas to avoid messes
# for f in ../*.fasta; do ../../../../204-concat-fastas.pl $f; done;
# now we have a bunch of *.fas that we can combine.
# I generated a bunch of rooted trees like this: 
# for f in *.phylip; do raxmlHPC-PTHREADS-SSE3 -T 3 -m GTRCAT -V -s $f -n `basename $f .phylip` -p 123 -o ind18,ind19; done;
# cat *bestTree* > trees.nex

my $sep="\t";
my $file=shift(@ARGV);
my $name=$file;
$name=~s/\.fasta//;
$name=~s/^\.\.\///;
print "working on $name\n";

my @data=ReadInFASTA($file);

foreach my $seq (@data) {
  my @a=split($sep, $seq); # get loci names separated from sequence bit
  $a[0]=~s/^\d+\s//; # removing leading locus numbers of files
  my $outfile="$a[0].fas"; #print to locus.fas
  open(OUTFILE, '>>', $outfile); #appending
  print OUTFILE ">".$name."\n".$a[1]."\n";
  close(OUTFILE);
}

exit;
# Converts an aligned fasta (aa or dna) seq file to phylip format

# takes an arg; name of a file from which data are read Then read in
# the data and make an array.  Each element of this array corresponds
# to a sequence, name tab data.
sub ReadInFASTA {
    my $infile = shift;
    my @line;
    my $i = -1;
    my @result = ();
    my @seqName = ();
    my @seqDat = ();

    open (INFILE, "<$infile") || die "Can't open $infile\n";

    while (<INFILE>) {
        chomp;
        if (/^>/) {  # name line in fasta format
            $i++;
            s/^>\s*//; s/^\s+//; s/\s+$//;
            $seqName[$i] = $_;
            $seqDat[$i] = "";
        } else {
            s/^\s+//; s/\s+$//;
	    s/\s+//g;                  # get rid of any spaces
            next if (/^$/);            # skip empty line
            s/[uU]/T/g;                  # change U to T
            $seqDat[$i] = $seqDat[$i] . uc($_);
        }

	# checking no occurence of internal separator $sep.
	die ("ERROR: \"$sep\" is an internal separator.  Line $. of " .
	     "the input FASTA file contains this charcter. Make sure this " . 
	     "separator character is not used in your data file or modify " .
	     "variable \$sep in this script to some other character.\n")
	    if (/$sep/);

    }
    close(INFILE);

    foreach my $i (0..$#seqName) {
	$result[$i] = $seqName[$i] . $sep . $seqDat[$i];
    }
    return (@result);
}

# takes multiple string; each string represent a sequence (name tab seq).
# Get rid of the sites where at least one seq has a gap (or ambiguious base)
# It returns an array of sequences.

sub CleanSeqs {
    my @dat = @_;
    my @seqDat = GetSeqDat(@dat);
    my @seqName = GetSeqName(@dat);

    my $minLength = CharLen($seqDat[0]);
    my ($i, $seqNum);
    my @noGapSites = ();
    my @result = ();
    my @codonMat = ();

    # get rid of codons with gaps    
    foreach $i (@seqDat) {
	my @tmpArray = (defined($opt_c)) ? MkTripletArray($i) : split(//, $i);
	push @codonMat, [ @tmpArray ];
	$minLength = @tmpArray if (@tmpArray < $minLength); # find min length
    }

    # identify the sites without any gaps.
    for $i (0 .. $minLength - 1) {
	my $gap = 0;
	if (defined($opt_c)) {
	    for $seqNum (0 .. $#seqDat) {
		if ($codonMat[$seqNum][$i] !~ /^[ACGT]{3}$/) {
		    $gap = 1;
		    last;
		}
	    }
	} elsif ($mode eq "nucleotide") {
	    for $seqNum (0 .. $#seqDat) {
		if ($codonMat[$seqNum][$i] !~ /^[ACGT]{1}$/) {
		    $gap = 1;
		    last;
		}
	    }
	} else { # protein
	    for $seqNum (0 .. $#seqDat) {
		if ($codonMat[$seqNum][$i] =~ /^[\-\?]{1}$/) {
		    $gap = 1;
		    last;
		}
	    }
	}
	push (@noGapSites, $i) if ($gap == 0);
    }

    # select the sites without any gaps
    for $seq (0 .. $#seqDat) {
	my @oneSeq = ();
	foreach $i (@noGapSites) {
	    push @oneSeq, $codonMat[$seq][$i];
	}
	my $newSeq = join "", @oneSeq;
	push @result, $seqName[$seq] . $sep . $newSeq;
    }

    return @result;
}


sub GetSeqDat {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	@line = split (/$sep/, $i);
	push @result, $line[1];
    }

    return (@result)
}

sub GetSeqName {
    my @data = @_;
    my @line;
    my @result = ();

    foreach my $i (@data) {
	@line = split (/$sep/, $i);
	push @result, $line[0];
    }
    return (@result)
}

# returns an array with the 1st argument repeated n times (2nd arg)
sub Repeat {
    my ($val, $n) = @_;
    my @result = ();
    foreach my $i (0..($n-1)) {
	push @result, $val;
    }
    return @result;
}

# this function take two scalars and return the larger value
sub Smaller {
    my ($a, $b) = @_;
    return (($a < $b) ? $a : $b);
}

sub Min {
    my $min = shift;
    foreach my $i (@_) {
	$min = ($i < $min) ? $i : $min;
    }
    return $min;
}

sub Sum {
    my $sum = 0;
    foreach my $i (@_) { 
	$sum += $i;
    }
    return $sum;
}

# count the number of characters in a string
sub CharLen {
    my $string = shift;
    my @charString = split (//, $string);
    return scalar(@charString);
}

# for a given string, it separates into triplets, and return
# the resulting array.
# if the last element is less than a triplet, it will be removed
sub MkTripletArray {
    my $seq = shift;
    $seq =~ s/\s+//g;
    $seq =~ s/(.{3})/$1 /g;
    $seq =~ s/\s+$//;
    my @result = split(/ /, $seq);
    pop @result unless ($result[$#result] =~ /.{3}/);
    return @result;
}

# When one of the codons corresponds to termination, (-1, -1) is returned.
# If two codons are identical, (0,0) is returned even if the codon 
# correspond to termination.

# take a list as the argument and extract the unique elements.
# The order of elements will not be preserved.
sub ExtractUnique {
    my %seen=();
    my @unique = ();

    foreach my $item (@_) {
        push (@unique, $item) unless $seen{$item}++;
    }
    return @unique;
}

