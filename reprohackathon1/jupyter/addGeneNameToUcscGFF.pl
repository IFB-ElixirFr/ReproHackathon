#!/usr/bin/env perl
use strict;

my $ucscGFF = $ARGV[0];
my $ucscTable = $ARGV[1];

my %map;

open(TABLE,$ucscTable);
<TABLE>;
while(<TABLE>){
    chomp;
    my @tab = split(/\t/);
    my $nm = $tab[1];
    my $gname = $tab[12];

    $map{$nm} = $gname;
}
close(TABLE);

open(GFF,$ucscGFF);
while(<GFF>){
    if(/gene_id \"(.*?)\".*transcript_id \"(.*?)\"/){
	s/gene_id \"(.*?)\"/gene_id \"$map{$1}\"/;
    }
    print $_;
}
close(GFF);
