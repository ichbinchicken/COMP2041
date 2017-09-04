#!/usr/bin/perl -w
@sem = ();
$lec_flag = 0;
$sem_count = 0;
$tmp = "";
$d_flag = 0;
$t_flag = 0;
if ($ARGV[0] =~ "-d") {
    shift @ARGV;
    $d_flag = 1;
}
if ($ARGV[0] =~ "-t") {
    shift @ARGV;
    $t_flag = 1;
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
                @total=split /\),/,$_;
                $c{$sem[$sem_count-1]} += 1;
                $$time = $_;
                #$a{$time} += 1;
                if ($d_flag == 0 && $t_flag == 0) {
  	      	  	    print $argv,': ',$sem[$sem_count-1],' ', $_ if ($_ ne $tmp);
        	    } else {
                    foreach $i (@total) {
                        @hour=$i=~/[0-2][0-9]:/g;
                        @day=$i=~/Mon|Tue|Wed|Thu|Fri/g;
                        foreach $j (@day) {
                            $hour[0]=~s/://g;
                            $hour[1]=~s/://g;
      		                $k=$hour[0];
                            while ($k<$hour[1]) {
                                @combined=[];
                                push @combined,$sem[$sem_count-1];
                                push @combined,$argv;
                                push @combined,$j;
                                $k=~s/^0//g;
                                push @combined,$k;
                                shift @combined;
                                $combined=join ' ',@combined;
                                $a{$combined}+=1;
                                if($a{$combined}==1) {
                                    if($t_flag == 0){
                                        print $combined,"\n";
                                    }
                                } else {
                                    $a{$combined}=1;
      			                }
                                $k++;
                            }
                        }
                    }
                }
            }
            $lec_flag = 0;
        }
    }
}
if ($t_flag == 1) {
    foreach $sem (sort keys %c) {
        print "$sem    ";
        foreach $indexX ("Mon","Tue","Wed","Thu","Fri") {
            print "   ",$indexX;
        }
        print "\n";
        foreach $indexY ("09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00") {
            print $indexY;
            foreach $indexX ("Mon","Tue","Wed","Thu","Fri") {
                $count=0;
                $time=$indexY;
                $time=~s/^0//g;
                $time=~s/:00//g;
                foreach $arg (@ARGV) {
                    @string=[];
                    push @string,$sem;
                    push @string,$arg;
                    push @string,$indexX;
                    push @string,$time;
                    shift @string;
                    $string=join ' ',@string;
                    $a{$string}+=0;
                    $count+=$a{$string};
                }
                if($count==0) {
                    print "      ";
                } else {
                    print "     ",$count;
                }
            }
            print "\n";
        }
    }
}
