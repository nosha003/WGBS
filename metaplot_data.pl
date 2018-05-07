#! /usr/bin/perl -w
# use bedtools intersect from bins peaks and gene gff output... pull out data to use for metaplot
# TEfamily_macs.pl
# 2_Jan_2017
# Jaclyn_Noshay

use warnings;
use strict;
use Getopt::Std;

#set soft coded files
my $usage = "\n0 -i in -o out\n";
our ($opt_i, $opt_o, $opt_h);
getopts("i:o:h") || die "$usage";

#check that all files are defined
if ( (!(defined $opt_i)) || (!(defined $opt_o)) || (defined $opt_h) ) {
  print "$usage";
}

#read in bedtools intersect file 
open (my $in_fh, '<', $opt_i) || die;
open (my $out_fh, '>', $opt_o) || die;

print $out_fh "chr\tbinstart\tbinstop\tbinid\tchr\tgene\tgenestart\tgenestop\tgenesize\tstrand\tdistance\tstrand_distance\trelative_distance\treal_distance\tcount\n";
#print $out_fh "chr\tbinstart\tbinstop\tbinid\tchr\tTE\tTEstart\tTEstop\tTEsize\tstrand\tdistance\tstrand_distance\trelative_distance\treal_distance\tcount\n";

my $strand_dist;
my $relative_dist;
my $real_dist;
my $genesize;
my $header = <$in_fh>;
while (my $line = <$in_fh>) {
  chomp $line;

  my ($gene_name, undef) = split (";", $geneID);
  $gene_name =~ s/ID=gene://;
  #my ($TE_name, undef) = split("Zm", $TEID);
  #$TE_name =~ s/ID=//;

  my $dist = $dist_bin * -1;

  if (!($strand eq "+")) {
    $strand_dist = $dist * -1;
  }
  else {
    $strand_dist = $dist;
  }
  
  if ($strand_dist > 0) {
    $relative_dist = $strand_dist + 1000;
  }
  else {
    $relative_dist = $strand_dist;
  }

  $genesize = abs($geneend - $genestart);
  #$genesize = abs($TEend - $TEstart);

  if ($strand_dist == 0) {
    my $diff = $end - $genestart;
    #my $diff = $end - $TEstart;
    my $decimal = $diff / $genesize;
    $relative_dist = $decimal * 1000;
    $real_dist = $diff;
  }
  else {
    $real_dist = $strand_dist;
  }
  my $binid = $chr . "_" . $start . "_" . $end;

  print $out_fh "$chr\t$start\t$end\t$binid\t$genechr\t$gene_name\t$genestart\t$geneend\t$genesize\t$strand\t$dist\t$strand_dist\t$relative_dist\t$real_dist\t$count\n";
  #print $out_fh "$chr\t$start\t$end\t$binid\t$TEchr\t$TE_name\t$TEstart\t$TEend\t$genesize\t$strand\t$dist\t$strand_dist\t$relative_dist\t$real_dist\t$count\n";
}

close $in_fh;
close $out_fh;
exit;
