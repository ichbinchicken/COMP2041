#!/usr/bin/perl -w
# put your demo script here
# Note: $a3 must be a number, which means in python, it should be used float(sys.stdin.read).
$a1 = <STDIN>;
$a2 = <STDIN>;
$a3 = <STDIN>;
@array = ();
push @array, $a1;
push @array, $a2;
push @array, "mum";
push @array, 2;
pop @array;
unshift @array, "Kevin";
foreach my $x (@array) {
    chomp $x;
    print $x. "\n";
    print $a3 + 1;
}
print @array;
reverse @array;
print reverse @array;
