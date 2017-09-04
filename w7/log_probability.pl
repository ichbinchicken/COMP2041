#!/usr/bin/perl -w
foreach $file (glob "poems/*.txt") {
   open(F1,"$file") or die "$0: Can't open $file $!\n";
   open(F2,"$file") or die "$0: Can't open $file $!\n";
   $file =~ s/_/ /g;
   $file =~ s/.txt//g;
   $file =~ s/poems\///g;
   $counter = 0;
   @total = ();
   while ($line = <F1>) {
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
   $all = 0;
   while ($line = <F2>) {
   	@words = split /\W+/, $line;
      $total = @words;
   	$num = 0;
   	while ($num < $total) {
   		if ($words[$num] =~/^$ARGV[0]$/i) {
            $all += 1;
   		}
   		$num++;
   	}
   }
   $loga = log(($all+1)/$sum);
   printf "log((%d+1)/%6d) = %8.4f %s\n", $all, $sum, $loga, $file;
   close(F1);
   close(F2);
}
