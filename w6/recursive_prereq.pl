#!/usr/bin/perl -w
$url_ung = "http://www.handbook.unsw.edu.au/undergraduate/courses/2015/$ARGV[1].html";
$url_post = "http://www.handbook.unsw.edu.au/postgraduate/courses/2015/$ARGV[1].html";
($name) = $ARGV[1] =~ /([A-Z]{4})/; #bracket is important.
#print "$name\n";
open F1, "wget -q -O- $url_ung|" or die;
while ($line = <F1>) {
   if ($line =~ /$name/ && $line =~ /Prerequisite/) {
      $line =~ s/Excluded:.*//g;  #delete Excluded courses
      $line =~ s/\b(?!\b[A-Z]{4}[0-9]{4}\b)\w+\b//g; #delete anywords except course words
      $line =~ s/\W//g; #delete other special characters
      @pre_ung = $line =~ /[A-Z]{4}[0-9]{4}/g; #split very powerful
   }
}
#@ug_pre = @pre_ung;
#$hi_num = @hi_pre;
#foreach $g (@pre_ung) {
#   print $g;
#}
@subcos = @pre_ung;
$all = @subcos;
$judge = 0;
$pos = 0;
while ($judge == 0) {
      $prev = $all;
      $url_ung = "http://www.handbook.unsw.edu.au/undergraduate/courses/2015/$subcos[$pos].html";
#      ($name) = $subcos[$pos] =~ /([A-Z]{4})/; #brackets is important.
#      print "$subcos[$pos]~~" . "\n";
      open F3, "wget -q -O- $url_ung|" or die;
      while ($line = <F3>) {
         if ($line =~ /Prerequisite/) {
            $line =~ s/\b(?!\b[A-Z]{4}[0-9]{4}\b)\w+\b//g;
            $line =~ s/\W//g;
#            print $line . "\n";
            @new = $line =~ /[A-Z]{4}[0-9]{4}/g;
            @new_sort = sort @new;
#            foreach $u (@new_sort) {
#               print $u . "\n";
#            }
            push (@subcos, @new_sort);
            $all = @subcos;
#            print $all ."\n";
            foreach $k (@subcos) {
               print $k ."\n";
            }
            push (@pre_ung, @new_sort);
         }
      }
      if ($prev == $all) {
#          print "******$subcos[$pos]*******\n";
         if ($subcos[$pos] ne "COMP3931" && $subcos[$pos] ne "TELE3018") {
            $judge = 1;
         }
      }
#      print $judge . "\n";
      $pos++;
}

foreach $k (@pre_ung) {
   print $k ."\n";
}
#after @pre_ung has all pre courses
#now finding postgraduate recursive courses
open F2, "wget -q -O- $url_post|" or die;
while ($line = <F2>) {
   if ($line =~ /$name/ && $line =~ /Prerequisite/) {
     $line =~ s/Excluded:.*//g;  #delete Excluded courses
     $line =~ s/\b(?!\b$name[0-9]{4}\b)\w+\b//g; #delete anywords except course words
     $line =~ s/\W//g; #delete other special characters
     @pre_post = $line =~ /[A-Z]{4}[0-9]{4}/g;
  }
}
@po_pre = @pre_post;
@subcos_po = @pre_post;
foreach my $course (@po_pre) {
   $judge = 0;
   $count = 0;
   while ($judge == 0) {
      $url_ung = "http://www.handbook.unsw.edu.au/postgraduate/courses/2015/$subcos_po[$count].html";
      ($name) = $subcos_po[$count] =~ /([A-Z]{4})/; #brackets is important.
      open F4, "wget -q -O- $url_post|" or die;
      while ($line = <F4>) {
         if ($line =~ /Prerequisite/) {
            $line =~ s/\b(?!\b[A-Z]{4}[0-9]{4}\b)\w+\b//g;
            $line =~ s/\W//g;
#            print $line . "\n";
            @new = $line =~ /[A-Z]{4}[0-9]{4}/g; # powerful split
            @new_sort = sort @new;
#            foreach $u (@new_sort) {
#               print $u . "\n";
#            }
            push (@subcos_po, @new_sort);
            push (@pre_post, @new_sort);
         } else {
            $judge = 1;
         }
      }
      $pos++;
   }
}
@total_cos = ();
push (@total_cos, @pre_ung);
push (@total_cos, @pre_post);
#foreach $k (@total_cos) {
#   print $k ."\n";
#}

close(F1);
close(F2);
close(F3);
close(F4);
