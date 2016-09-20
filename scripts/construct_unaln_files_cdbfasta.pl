#!env perl
use strict;
use warnings;
use Getopt::Long;
use File::Spec;
my $dir = 'search';
my $dbdir = 'pep';
my $ext = "fa";
my $outdir = 'aln';
my $idxfile = 'allseq';

GetOptions(
    'd|dir:s'   => \$dir,
    'e|ext:s'   => \$ext,
    'I|idx:s'   => \$idxfile,
    'db:s'      => \$dbdir,
    'o|out:s'   => \$outdir,
    );
$idxfile = File::Spec->catfile($dbdir,$idxfile);
`cat $dbdir/*.$ext | esl-reformat fasta - > $idxfile`;
`cdbfasta $idxfile`;

opendir(BEST,$dir) || die "cannot open dir: $dir, $!";

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
    open(CDBYANK,"| cdbyank $idxfile.cidx -o $outdir/$gene.$ext") || die $!;    
    while( my ($sp,$seqname) = each %{$by_gene{$gene}} ) {
	print CDBYANK $seqname,"\n";
    }
}
