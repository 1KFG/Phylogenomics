use strict;
use warnings;

my $dir = shift || ".";

opendir(DIR,$dir) || die $!;
open(IN,"FILES") || die $!;
my %expected;
my $i = 1;
while(<IN>) {
 my ($n) = split;
 $n =~ s/\.trim//;
 $expected{$n} = $i++
}
my %seen;
for my $file ( readdir(DIR) ) {
# if ( $file =~ /RAxML_bipartitions.(\S+)/ ) {
 if ( $file =~ /RAxML_info.(\S+)/ ) {
  $seen{$1}++;
 }
}
my @rerun;
for my $ex ( sort { $expected{$a} <=> $expected{$b} } keys %expected ) {
 if ( ! exists $seen{$ex} ) {
  warn("missing $ex - [ $expected{$ex} ]\n");
  push @rerun, $expected{$ex};
 }
}
print join(",", sort { $a <=> $b } @rerun),"\n";
