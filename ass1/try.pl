#!/usr/bin/perl -w
$sum = 0;
while ($line = <STDIN>) {
    $line =~ s/^\s*//;
    $line =~ s/\s*$//;
    if ($line !~ /^\d[.\d]*$/) {
        last;
    }
    $sum += $line;
}
print "Sum $sum\n";
