#!env perl
use strict;
use warnings;
use Bio::TreeIO;

my $table = shift || die $!;
my $treefile = shift || die $!;

open(my $fh => $table) || die $!;
my %table;
while(<$fh>) {
    my ($pref,$name) = split;
    $table{$pref} = $name;
}

my $tree = Bio::TreeIO->new(-format => 'newick',
			    -file   => $treefile)->next_tree;
if( $tree ) {
    for my $node ( grep { $_->is_Leaf } $tree->get_nodes ) {
	my $id = $node->id;
	if( $table{$id} ) {
	    $node->id($table{$id});
	} else {
	    warn("id is $id cannot find\n");
	}
    }
}
Bio::TreeIO->new(-format => 'newick',
		 -file => ">newname_$treefile")->write_tree($tree);
