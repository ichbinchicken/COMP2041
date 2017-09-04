#!/usr/bin/perl -w
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
$sum = 0;
while ($pos < $counter) {
	$sum += $total[$pos];
	$pos ++;
}
print "$sum words\n";
