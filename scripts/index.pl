#!env perl
use strict;
use Bio::DB::Fasta;

my $pepdir = "pep";
opendir(DIR,$pepdir) || die "cannot open dir";

for my $file ( readdir(DIR) ) {
  next if ($file =~ /^\./ || $file !~ /\.fasta$/);
  warn("file is $file\n");
  my $dbh = Bio::DB::Fasta->new("$pepdir/$file");
} 
