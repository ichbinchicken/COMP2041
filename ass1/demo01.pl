#!/usr/bin/perl -w
# put your demo script here
$counter = 0;
@total = ();
while ($line = <STDIN>){
	@words = split /\W+/, $line;
	$total[$counter] = @words;
	if ($total[$counter] != 0) {
		$num = 0;
		while ($num < $total[$counter]) {
			if ($words[$num] !~ /[a-zA-Z]/) {
				$total[$counter] = $total[$counter] - 1;
			}
			$num++;
		}
	}
	$counter ++;
}
$pos = 0;
$summ = 0;
while ($pos < $counter) {
	$summ += $total[$pos];
	$pos ++;
}
print "$summ words\n";
