use strict;
use warnings;
use Getopt::Long;
use Bio::SeqIO;

my $prefix = 'prefix.tab';
my $dir = 'aln/Roz200';
GetOptions(
	 'p|prefix:s' => \$prefix,
	'd|dir:s'     => \$dir,
	);
open(my $fh => $prefix) || die $!;
my %lookup;
while(<$fh>) {
 next if /^Pref/;
 my @row = split;
 $lookup{$row[0]} = $row[1];
}

opendir(DIR,$dir) || die "$dir:$!";

for my $file ( readdir(DIR) ) {
    next unless $file =~ /\.(fa|aa|cds)$/;
    my $ofile = Bio::SeqIO->new(-format => 'fasta', -file => ">$dir/$file.rename");
    my $ifile = Bio::SeqIO->new(-format => 'fasta', -file => "$dir/$file");
    while( my $seq = $ifile->next_seq ) {
	my $id = $seq->display_id;
	my ($sp) = split(/\|/,$id);
	my $longname = $lookup{$sp};
	if( ! $longname ) {
	    die "cannot find $sp ($id) in $prefix: $file";
	}
	$seq->display_id($longname);
	$seq->description("$id ".$seq->description);
	$ofile->write_seq($seq);
    }
}
 
