#!/usr/bin/perl -w

@a=<STDIN>;
$size=@a;
#$index1=`perl -e 'print rand($size), "\n"'`;
#print $index1
$i=0;
while($i < $size*10) {
	$index1=`perl -e 'print rand($size), "\n"'`;
	$index2=`perl -e 'print rand($size), "\n"'`;
	($a[$index1],$a[$index2])=($a[$index2],$a[$index1]);
	$i++;
}
print @a;
