#!env perl
use strict;
use Bio::SeqIO;
my $dir = shift;
opendir(DIR,$dir) || die $!;
my $keep = shift;
my %k;
open(my $fh => $keep) || die $!;
while(<$fh>) {
    next if /^\s+/ || /^Pref/;
    my ($p,$l) = split;
    $k{$p}=$l;
}
for my $file ( readdir(DIR) ) {
 next unless $file =~ /(\S+)\.trim$/;
 my $stem = $1;
 my $out = Bio::SeqIO->new(-file => ">$dir/$stem.trim.keep", -format => 'fasta');
 my $in = Bio::SeqIO->new(-format => 'fasta', -file => "$dir/$file");
 while( my $s = $in->next_seq ) { 
    my ($sp,$gn) = split(/\|/,$s->display_id);
    if( exists $k{$sp} ) {
        $s->desc("$sp|$gn ".$s->desc);
	$s->display_id($sp);
	$out->write_seq($s);
    }
 }
 #last
}
