#!/usr/bin/perl -w
@sem = ();
$lec_flag = 0;
$sem_count = 0;
$d_flag = 0;
$tmp = "";
if ($ARGV[0] =~ "-d") {
    shift;
    $d_flag = 1;
}
sub printDetails {
    my $tmp_num = 0;
    my ($line, $semester, $subject) = @_;
    my @words = split /\),/, $line;
    # my %a = {};
    foreach $i (@words) {
        @hours = $i =~ /[0-2][0-9]:/g;
        @days = $i =~ /Mon|Tue|Wed|Thu|Fri/g;
        foreach $j (@days) {
            $hours[0] =~ s/://g;
            $hours[1] =~ s/://g;
            $k = $hours[0];
            while ($k < $hours[1]) {
                my @combined = [];
                push @combined,$semester;
                push @combined,$subject;
                push @combined,$j;
                $k=~s/^0//g;
                push @combined,$k;
                shift @combined; #question?
                $combined=join ' ',@combined;
#                print $combined . "\n";
                $a{$combined} += 1; #question?
                if($a{$combined} == 1) {
                    print $combined . "\n";
                }
                $k++;
            }

        }
    }


}

foreach $argv (@ARGV) {
    $url = "http://timetable.unsw.edu.au/current/$argv.html";
    open F, "wget -q -O- $url|" or die;
    while (<F>) {
        if ($_ =~ /SUMMARY OF SUMMER TERM CLASSES/)  {
            $sem[$sem_count] = "X1";
            $sem_count++;
        }
        if ($_ =~ /SUMMARY OF SEMESTER ONE CLASSES/)  {
            $sem[$sem_count] = "S1";
            $sem_count++;
        }
        if ($_ =~ /SUMMARY OF SEMESTER TWO CLASSES/) {
            $sem[$sem_count] = "S2";
            $sem_count++;
        }
        if ($_ =~ /Lecture/) {
            $lec_flag = 1;
        }
        if (($_ =~ /(Mon|Tue|Wed|Thu|Fri) / || $_ =~ /WEB/) && ($lec_flag == 1)) {
#            chomp $_;
            $_ =~ s/^\s+//g;
            $_ =~ s/<td class="data">//g;
            $_ =~ s/<\/td>//g;
            if (($sem[$sem_count-1] eq "S1" || $sem[$sem_count-1] eq "S2"
                || $sem[$sem_count-1] eq "X1") && $_ !~ /Weeks:2.*/ && $_ !~ /WEB/) {
            #if statement: excluded tute(begining with week2), web courses
                if ($d_flag == 1) {
                    # subroutine:
                    printDetails $_, $sem[$sem_count-1], $argv;
                } else {
                    print "$argv: $sem[$sem_count-1] $_" if $_ ne $tmp;
                }
                $tmp = $_;
#                print $_;
            }
            $lec_flag = 0;
        }
    }
}
