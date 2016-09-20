use strict;
use warnings;
my $base = "Chytrid.Jul8_56sp.phy.BS";
my $range = 1000000000;
print "module load RAxML\n";
for( my $i = 0; $i < 499; $i++ ){
 my $random_number = int(rand($range));
 print "raxmlHPC-AVX -y -s ",$base.$i," -m PROTGAMMALG -n T",$i," -p $random_number\n";
}
