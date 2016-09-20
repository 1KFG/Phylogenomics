#!env perl
use strict;
use Bio::SeqIO;

my $in = Bio::SeqIO->new(-format => 'fasta', -file => shift);
my $keep = shift;
my %k;
open(my $fh => $keep) || die $!;
while(<$fh>) {
    next if /^\s+/ || /^Pref/;
    my ($p,$l) = split;
    $k{$p}=$l;
}
my $out = Bio::SeqIO->new(-format => 'fasta');
while( my $s = $in->next_seq ) { 
    if( exists $k{$s->display_id} ) {
	$out->write_seq($s);
    }
}
    
