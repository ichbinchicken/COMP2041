#!/usr/bin/perl -w
# put your demo script here
# This one can perfectly work.
if ($#ARGV + 2 != 3) {
    printf("Usage: %s <number of lines> <string>\n", $0);
    exit(1);
}
$number  = $ARGV[0] =~ /[0-9]/;
if ($number eq "") {
    printf("Usage: %s <number of lines> <string>\n", $0);
    exit(1);
}
$char = $ARGV[1] =~ /[a-zA-Z]/;
if ($char eq "") {
    printf("Usage: %s <number of lines> <string>\n", $0);
    exit(1);
}
$value = $ARGV[0];
for (my $i = 0; $i < $value; $i++) {
    print $ARGV[1] . "\n";
}
