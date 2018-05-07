#! /usr/bin/perl -w
# combine methylation data per sample and calculate coverage
# take combined methylation sites count file and .tab methylation calls file... calculate coverage and output new .tab file with corrected coverage
# methylation_calc_coverage.pl
# 16_Feb_2017
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

#read in files 
open (my $in_fh, '<', $opt_i) || die;
open (my $out_fh, '>', $opt_o) || die;

print $out_fh "chr\tstart\tend\tCG_ratio\tCG_C\tCG_CT\tCG_sites\tCG_cov\tCHG_ratio\tCHG_C\tCHG_CT\tCHG_sites\tCHG_cov\tCHH_ratio\tCHH_C\tCHH_CT\tCHH_sites\tCHH_cov\n";

#my $header = <$in_fh>;
my ($cg_cov, $chg_cov, $chh_cov);
while (my $line = <$in_fh>) {
  chomp $line;
  # $chr, $start, $end, $cg_sites, $cg_C, $cg_CT, $cg_ratio, $chg_sites, $chg_C, $chg_CT, $chg_ratio, $chh_sites, $chh_C, $chh_CT, $chh_ratio

  # my ($chr, $start, $end, $cg_ratio, $cg_C, $cg_CT, undef, $chg_ratio, $chg_C, $chg_CT, undef, $chh_ratio, $chh_C, $chh_CT, undef, $cg_sites, $chg_sites, $chh_sites) = sp
lit ("\t", $line);
  my ($chr, $start, $end, $cg_sites, $cg_C, $cg_CT, $cg_ratio, $chg_sites, $chg_C, $chg_CT, $chg_ratio, $chh_sites, $chh_C, $chh_CT, $chh_ratio) = split ("\t", $line);

  if ($cg_sites eq ".") {
    $cg_cov = 'NA';
  }
  elsif ($cg_sites eq "") {
    $cg_cov = 'NA';
  }
  elsif ($cg_sites == 0) {
    $cg_cov = 'NA';
  }
  else {
    $cg_cov = $cg_CT / $cg_sites;
  }
  if ($cg_cov eq 'NA') {
    $cg_ratio = 'NA';
  }
  elsif ($cg_cov == 0) {
    $cg_ratio = 'NA';
  }


  if ($chg_sites eq ".") {
    $chg_cov = 'NA';
  }
  elsif ($chg_sites eq "") {
    $chg_cov = 'NA';
  }
  elsif ($chg_sites == 0) {
    $chg_cov = 'NA';
  }
  else {
    $chg_cov = $chg_CT / $chg_sites;
  }
  if ($chg_cov eq 'NA') {
    $chg_ratio = 'NA';
  }
  elsif ($chg_cov == 0) {
    $chg_ratio = 'NA';
  }


  if ($chh_sites eq ".") {
    $chh_cov = 'NA';
  }
  elsif ($chh_sites eq "") {
    $chh_cov = 'NA';
  }
  elsif ($chh_sites == 0) {
    $chh_cov = 'NA';
  }
  else {
    $chh_cov = $chh_CT / $chh_sites;
  }
  if ($chh_cov eq 'NA') {
    $chh_ratio = 'NA';
  }
  elsif ($chh_cov == 0) {
    $chh_ratio = 'NA';
  }

  my $truestart = $start + 1;
  print $out_fh "$chr\t$truestart\t$end\t$cg_ratio\t$cg_C\t$cg_CT\t$cg_sites\t$cg_cov\t$chg_ratio\t$chg_C\t$chg_CT\t$chg_sites\t$chg_cov\t$chh_ratio\t$chh_C\t$chh_CT\t$chh_
sites\t$chh_cov\n";
}

close $in_fh;
close $out_fh;
exit;
