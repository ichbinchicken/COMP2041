#!/usr/bin/perl -w
$url_ung = "http://www.handbook.unsw.edu.au/undergraduate/courses/2015/$ARGV[0].html";
$url_post = "http://www.handbook.unsw.edu.au/postgraduate/courses/2015/$ARGV[0].html";
($name) = $ARGV[0] =~ /([A-Z]{4})/; #brackets is important.
#print "$name\n";
open F1, "wget -q -O- $url_ung|" or die;
while ($line = <F1>) {
    if ($line =~ /Prerequisite/) {
      $line =~ s/Excluded:.*//g;  #delete Excluded courses
      $line =~ s/\b(?!\b$name[0-9]{4}\b)\w+\b//g; #delete anywords except course words
      $line =~ s/\W//g; #delete other special characters
      @pre_ung = $line =~ /[A-Z]{4}[0-9]{4}/g; #split very powerful
#      print @pre_ung;
      foreach my $course (@pre_ung) {
         print $course . "\n";
      }
   }
}

open F2, "wget -q -O- $url_post|" or die;
while ($line = <F2>) {
   if ($line =~ /$name/ && $line =~ /Prerequisite/) {
     $line =~ s/Excluded:.*//g;  #delete Excluded courses
     $line =~ s/\b(?!\b$name[0-9]{4}\b)\w+\b//g; #delete anywords except course words
     $line =~ s/\W//g; #delete other special characters
     @pre_post = $line =~ /[A-Z]{4}[0-9]{4}/g;
#      print @pre_ung;
     foreach my $course (@pre_post) {
        print $course . "\n";
     }
  }
}
