#!/usr/bin/perl -w
$n = $ARGV[0] ;
$string = $ARGV[1] ;
$number = $#ARGV + 1 ;
if ($n !~ /^\d+$/ || $number > 2 || $number < 2 || $string !~ /^[a-zA-Z]+$/) {
  die "Usage: ./echon.pl <number of lines> <string> at ./echon.pl line 3. $!\n" ;
}
$counter = 0 ;
while ($counter < $n) {
  print $string . "\n" ;
  $counter++ ;
}
