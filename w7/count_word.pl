#!/usr/bin/perl -w
$sum = 0;
while ($line = <STDIN>) {
	@words = split /\W+/, $line;
   $total = @words;
	$num = 0;
	while ($num < $total) {
		if ($words[$num] =~/^$ARGV[0]$/i) {
         $sum += 1;
#         print $words[$num] . "\n";
		}
		$num++;
	}
}
$char = lc($ARGV[0]);
print "$char occurred $sum times\n";
