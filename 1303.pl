#! /usr/bin/perl -w

#Read in something like Gene.99999::CIGENEomyV6.23945.1::g.99999::m.99999.fas
# Append gene to sample name

my $INFILE=shift;

my @a=split(/::/, $INFILE);

open(INFILE, $INFILE);

  while(<INFILE>) {
    chomp($_);
    s/\A\s+//;                         # remove leading spaces
    s/\s+\z//;                         # remove trailing spaces
    if (/^>/) {
    print;
    print "-$a[0]\n";
    } else {
    print;
    print "\n";
    }
}

exit;

