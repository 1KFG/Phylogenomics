#!env perl

my $dir = shift || "search/JGI_1086";
opendir(DIR, $dir) || die "Cannot open $dir";
my %hits;
for my $file ( readdir(DIR) ) {
    next unless $file =~ /\.best$/;
    open(my $fh => "$dir/$file") || die $!;
    while(<$fh>) {
	my ($qfamily,$hit,$evalue) = split;
	$qfamily =~ s/\./_/;
	my ($sp,$gname) = split(/\|/,$hit,2);
	push @{$hits{$qfamily}}, [$sp, $evalue];
    }
}

print join("\t", qw(FAMILY SPECIES EVALUE)), "\n";
for my $family ( sort keys %hits ) {
    for my $geneinfo ( @{$hits{$family}} ) {
	print join("\t", $family, @$geneinfo), "\n";
    }
}
