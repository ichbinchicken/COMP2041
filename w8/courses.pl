#!/usr/bin/perl -w
$url = "http://timetable.unsw.edu.au/current/$ARGV[0]KENS.html";
open F, "wget -q -O- $url|" or die;
$count = 0;
while (<F>) {
    if ($_ =~ /$ARGV[0]/ && ($count % 2 == 0)) {
        $_ =~ s/.html.*//g;
        $_ =~ s/.*\"//g;
        print $_ ;;
    }
    $count++;
}
