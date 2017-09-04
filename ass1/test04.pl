#!/usr/bin/perl -w
# put your demo script here
# check different types of loops
@array = ();
while ($line = <STDIN>) {
    for ($a = 0; $a < 10; $a++) {
        push @array, $line;
    }
}
foreach $i (@array) {
    print $i. "\n";
}
