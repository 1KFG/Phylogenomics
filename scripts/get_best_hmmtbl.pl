#!env perl
use strict;
use warnings;
use Getopt::Long;
my $cutoff = 1e-20;
GetOptions('c|e|cutoff:s' => \$cutoff);

my %seen;
while(<>) {
    next if /^\#/;
    my @row = split(/\s+/,$_);
    my $t = $row[0];
    my $q = $row[3];
    my $evalue = $row[6];
    next if $evalue > $cutoff;
    if( exists $seen{$q} ) {
	next;
    }
    $seen{$q} = [$t,$evalue];
}
for my $s ( keys %seen ) {
    print join("\t",$s,@{$seen{$s}}),"\n";
}
