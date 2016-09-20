#!env perl
use strict;
use warnings;
use Bio::SeqIO;
use Bio::DB::Fasta;
use Getopt::Long;

my $dir = 'search';
my $dbdir = 'pep';
my $outdir = 'aln';
GetOptions(
    'd|dir:s'   => \$dir,
    'db:s'      => \$dbdir,
    'o|out:s'   => \$outdir,
    );

my $db = Bio::DB::Fasta->new($dbdir);
opendir(BEST,$dir) || die $dir;

my %by_gene;
for my $file ( readdir(BEST) ) {
    next unless $file =~ /(\S+)\.best/;
    my $stem = $1;
    open(my $fh => "$dir/$file") || die "$dir/$file: $!";
    while(<$fh>) {
	my ($gene,$name) = split;
	$by_gene{$gene}->{$stem} = $name;
    }
}

for my $gene ( keys %by_gene ) {
    my $out = Bio::SeqIO->new(-format => 'fasta',
			      -file   => ">$outdir/$gene.fa");
    while( my ($sp,$seqname) = each %{$by_gene{$gene}} ) {
	my $seq = $db->get_Seq_by_acc($seqname);
	if( ! $seq ) {
	    warn("cannot find $seqname ($sp)\n");
	} else {
	    $out->write_seq($seq);
	}
    }
}
