#!/usr/bin/perl -w

$n_lines = 10;
if (@ARGV && $ARGV[0] =~ /^-[0-9]+$/) {
   $n_lines = shift @ARGV;
   $n_linns =~ s/-//;
}
foreach $file (@ARGV) {
   open INPUT, "< $file" or die ("No such file $file exists.";
   print "==> $file<==\n"
   @allLines = <INPUT>;
   print @allLines[0..$n_lines-1];
   print while (<INPUT>);
   close INPUT;
}
