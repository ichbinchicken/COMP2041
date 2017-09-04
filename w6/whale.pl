#!/usr/bin/perl -w
$i=0;
$j=0;
while ($line = <STDIN>) {
   ($num[$i], $breed[$j]) = $line =~ /(\d+)\s([^\d]+)/;
   $i++;
   $j++;
}
$total = @num;
$curr = 0;
@arrage_num = ();
@arrage_breed = ();
$ar = 0;
@pods = ();
while ($curr < $total) {
   $next = $curr + 1;
   if ($num[$curr] != -1) {
      $pods[$ar] = 1;
      $arrage_num[$ar] = $num[$curr];
      $arrage_breed[$ar] = $breed[$curr];
      while ($next < $total){
         if ($breed[$curr] eq $breed[$next]) {
            $pods[$ar]++;
            $arrage_num[$ar] += $num[$next];
            $num[$next] = -1;
         }
         $next++;
      }
      $ar++;
   }
   $curr++;
}
$n = 0;
$all = @arrage_breed;
while ($n < $all) {
   chomp $arrage_breed[$n];
   if ($ARGV[0] eq $arrage_breed[$n]) {
      print "$arrage_breed[$n] observations: $pods[$n] pods, $arrage_num[$n] individuals\n";
      last;
   }
   $n++;
}
if ($n == $all) {
   print "$ARGV[0] observations: 0 pods, 0 individuals\n";
}
