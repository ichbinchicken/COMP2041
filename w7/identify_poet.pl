#!/usr/bin/perl -w
foreach $poem (glob "poems/*.txt") {
   # count the total word of given poem first.
   open(F2,"$poem") or die "$0: Can't open $poem $!\n";
   $counter = 0;
   @total = ();
   while ($line2 = <F2>) {
      @words_t = split /\W+/, $line2;
      $total[$counter] = @words_t;
      if ($total[$counter] != 0) {
         $num2 = 0;
         while ($num2 < $total[$counter]) {
            if ($words_t[$num2] !~ /[a-zA-Z]/) {
               $total[$counter] = $total[$counter] - 1;
            }
            $num2++;
         }
      }
      $counter ++;
   }
   $pos_t = 0;
   $sum = 0;
   while ($pos_t < $counter) {
      $sum += $total[$pos_t];
      $pos_t ++;
   }
   close(F2);
   # sum = total word of one given poem
   foreach $file (@ARGV) {
      $count_words = 0;
      if ($file ne "-d") {
         open(F1,"$file") or die "$0: Can't open $file $!\n";
         while ($line = <F1>) {
            @words_argv = split /\W+/, $line;
            $sum_words = @words_argv;
            if ($sum_words != 0) {
    	          $num = 0;
    		       while ($num < $sum_words) {
    			       if ($words_argv[$num] =~ /[a-zA-Z]/) {
                      open(F3,"$poem") or die "$0: Can't open $poem $!\n";
                      $all = 0;
                      while ($line3 = <F3>) {
                         @words_c = split /\W+/, $line3;
                         $total_c = @words_c;
                         $num3 = 0;
                         while ($num3 < $total_c) {
                            if ($words_c[$num3] =~/^$words_argv[$num]$/i) {
                               $all += 1;
                     	    }
                     	    $num3++;
                         }
                      }
#                     print "$all\n";
                      $loga[$count_words] = log(($all+1)/$sum);
#                     print "$loga[$count_words]\n";
                      $count_words++;
                   }
                   $num++;
                } #$num < $sum_words
            }
         } # <F1>
         close(F1);
         close(F3);
         $poem2 = $poem;
         $poem2 =~ s/_/ /g;
         $poem2 =~ s/.txt//g;
         $poem2 =~ s/poems\///g;
         $loga_total = 0;
         $pos_words= 0;
         while ($pos_words < $count_words) {
            $loga_total += $loga[$pos_words];
            $pos_words++;
         }
         $hash{$loga_total} = "$poem2";
      }
   } #file
} #poem
if ($ARGV[0] eq "-d") {
   foreach my $k (sort keys %hash) {
      printf "%s: log_probability of %5.1f for %s\n", $ARGV[1], $k ,$hash{$k};
   }
}
