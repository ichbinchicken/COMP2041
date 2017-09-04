#!/usr/bin/perl -w

while ($line = <STDIN>) {
   $line =~ s/[aeiou]//gi; #g : all i : don't care about case
   print $line
}

