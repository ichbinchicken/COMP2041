#!/usr/bin/perl -w
# put your demo script here
$a1 = <STDIN>;
$a2 = <STDIN>;
$a3 = $a1 % $a2;
print $a1 + 100 ."\n";
print $a1 * $a2 ."\n";
print $a1 - $a2 ."\n";
print $a3;
printf "%d %d hello %d %3.2f\n", ($a1 ** $a2), $a1, $a2, ($a1 / $a2);
printf "%d %d hello %d ", ($a1 ** $a2), $a1, $a2 . "\n";
