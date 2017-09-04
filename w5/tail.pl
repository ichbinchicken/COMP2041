#!/usr/bin/perl -w
$count=0;
$value=-1;
@input=();
#print @ARGV ."\n";
for($i=0;$i<@ARGV;$i++) {
	if($ARGV[$i]=~ /\.txt$/) {
		$count++;
		push @input,$ARGV[$i];
	}
	if($ARGV[$i]=~ /^\-[\d]/){ #get display line number
		$value= $ARGV[$i];
		$value=~ s/[^0-9]//g;
        }
}
#print "$value read\n";
if($count==0) {
	@file=<STDIN>;
	$end=@file;
	if($value==-1) {
		for($b=$end-10;$b<$end;$b++) {
			print $file[$b];
		}
	} else {
		$c=@file;
		if($value>=$c) {
			print @file;
		} else {
	        	for($a=$end-$value;$a<$end;$a++) {
	       			print $file[$a];
        		}
		}
	}
} else {
	$all=@input;
	foreach $f (@input) {
		if($all>1) { print "==> $f <==\n";}
		open(F,"<$f") or die "$0: Can't open $f\n";
		@linelist=<F>;
		$total=@linelist;
#		print "$total reads\n";
		if($value==-1) {
			if ($total > 10) {
			   for($c=$total-10;$c<$total;$c++) {
				   print $linelist[$c];
			   }
		   } else {
				print @linelist;
			}
		}
		else {
			if($total<=$value) {
            print @linelist;
			}
			else {
				for($b=$total-$value;$b<$total;$b++) {
					print $linelist[$b];
				}
			}
		}
		close(F);
	}
}
