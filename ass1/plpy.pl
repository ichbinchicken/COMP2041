#!/usr/bin/perl -w
# interprete perl code to python 3.5 code
# written by Ziming Zheng z5052592
# 24.Sep.2016
# This assignment is assumed that spaces and indents are used reasonably.
# Brief structure:
# change line by line and push into array line by line.

#This array stores buffer of changed syntax.
our @outputs;

# Title function:
# Changing shebang
sub Title {
    my ($line) = @_;
    $line =~ s/.*/#!\/usr\/local\/bin\/python3.5 -u/;
    print $line;
}

# Set zero:
# print pure strings
# conditions have:
# 1. print "hello\nworld";
# 2. print "hello world\n";
# 3. print "hello\nworld\n";
# 4. print "\nhello\nworld";
# 5. sys.stdout.write("Enter a number: ") ---> print("Enter a number: ",end="")
sub PrintFunction {
    # condition 1: pure strings
    my ($indent,@line) = @_;
    my $exp1;
    my $exp2;
    my $exp3;
    my $spaces = "";
    my $i;
    # calculate indents:
    for (my $i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    foreach my $line (@line) {
        chomp $line;
    }
    # rebuild the strings:
    foreach my $line (@line) {
        if ($line =~ /print[\s]*/) {
            $line =~ s/print[\s]*/print/;
            $exp1 = $line . "(\"";
        } elsif ($line =~ /\\n$/) {
            $line =~ s/\\n$//;
            $exp2 = $line . "\")". "\n";
        } elsif ($line =~ /.+/) {
            if ($line !~ /\\n$/) {
                $exp2 = $line . "\"\,end\=\"\")" . "\n";
            }
        }
    }
    $exp3 = $spaces.$exp1.$exp2;
    push(@outputs, $exp3);
}

# Set one & Set two & Set three & set four:
# print variables:
# Set three part: print argv
# Set four part: simple uses of printf (requiring % in python)
# conditions/examples have:
# 1. print(answer)
# 2. print(factor0 * factor1)
# 3. print(sys.argv[i + 1])
# 4. print("%3.2f %d" %((a**b), a), end="")
# 5. print("%3.2f %d\n" %((a**b), a))
# 6. print "%3.2f %d", ($a ** $b), $a, $b . "\n";---->print("%d %d toby %d" %( (a ** b), a, b  ))
# 7. print("Usage: %s <number of lines> <string>\n" %( sys.argv[0]))
sub VariablesPrint {
    my ($indent,@line) = @_;
    my $exp1;
    my $exp2 = "";
    my $exp3 = "";
    my $exp4 = "";
    my $exp5 = "";
    my $exp6 = "";
    my $spaces = "";
    my $i;
    # calculate indents:
    for ($i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    foreach my $line (@line) {
        chomp $line;
    }
    # rebuild the statement:
    foreach my $line (@line) {
        if ($line ne "") {
            if ($line =~ /print[f]?[\s]*/) {
                $line =~ s/print[f]?[\s]*/print(/;
                $line =~ s/\$//g;
                $line =~ s/[, .]//g;
                if ($line =~ /ARGV/) {
                    $buff = $line;
                    $buff =~ s/print\(//g;
                    $buff =~ s/ARGV//g;
                    $buff =~ s/\[//g;
                    $buff =~ s/\]//g;
                    $buffs = $buff + 1;
                    $line =~ s/ARGV\[.*\]/sys\.argv[$buffs]/g;
                }
                $exp1 = $line;
            } elsif ($line =~ /\$/) {
                # condition 1: "$answer" --> (answer)
                # condition 2: ARGV --> sys.argv
                if ($line =~ /\$0/) {
                    $line =~ s/\$0/sys\.argv\[0\]/g;
                }
                $line =~ s/\$//g;
                if ($line =~ /ARGV/) {
                    $line =~ s/ARGV/sys.argv/;
                    $temp = $line;
                    if ($temp =~ /\[.*\].*/) {
                        $temp =~ s/\].*//;
                        $temp =~ s/.*\[//;
                        $var = $temp;
                    }
                    $line =~ s/\[.*\]/\[$var + 1\]/;
                }
                if ($line =~ /\\n$/) {
                    $line =~ s/\\n$//;
                    $exp4 = $line . ")". "\n";
                }
                if ($line =~ /^\,/) {
                    $line =~ s/^\,/ \%\(/;
                }
                $exp3 = $line;
            } elsif ($line =~ /\\n/) {
                if ($line =~ /.*\\n$/) {
                    $line =~ s/\\n$//;
                    $exp6 = $line;
                }
                $exp4 = ")" . "\n";
            } else {
                $exp2 = $line;
            }
        }
    }
    if ($exp4 eq "") {
        $exp4 = "\,end\=\"\")" . "\n";
    }
    if ($exp3 =~ /\./) {
        if ($exp3 !~ /sys\./) {
            $exp3 =~ s/\.//g;
        }
    }
    if ($exp2 =~ /\%/ || $exp6 =~ /\%/) {
		# this is for translating printf in perl.
        if ($exp6 eq "") {
            $exp5 = $spaces.$exp1."\"".$exp2."\"".$exp3."\)".$exp4;
        } else {
            $exp5 = $spaces.$exp1."\"".$exp6."\"".$exp3."\)".$exp4;
        }
    } else {
        # this is for single variable: print(answer);
        $exp5 = $spaces.$exp1.$exp2.$exp4;
    }
    # if print statement has hash with {}:
    if ($exp5 =~ /\w+\{\w+\}/) {
        $exp5 =~ s/\{/\[/;
        $exp5 =~ s/\}/\]/;
    }
    push(@outputs,$exp5);
}

# Set three:
# chomp ==> rstrip()
sub ChangingChomp {
    my $var;
    my $chomp;
    my ($indent, @words) = @_;
    foreach my $word (@words) {
        if ($word !~ /chomp/) {
            $var = $word;
        } elsif ($word =~ /chomp/) {
            $chomp = ".rstrip()";
        }
    }
    my $spaces = "";
    my $i;
    for ($i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    my $exp = $spaces.$var." = ".$var.$chomp."\n";
    return $exp;
}

# Set three:
# this is purely for the sake of test in example 3
# need to think more variations.
# conditions have:
# print("%s lines" % line_count)
sub PrintJoin {
    my @temp;
    #my $exp1;
    my $exp2;
    my $exp3;
    my $exp4;
    my $exp5;
    my ($indent, @words) = @_;
    my $spaces = "";
    for ($i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    foreach my $word (@words) {
        if ($word =~ /print[\s]*/) {
            $word =~ s/print[\s]*//;
            if ($word =~ /join/) {
                $word =~ s/.*j/j/;
                @temp = split(",", $word);
                foreach my $temp (@temp) {
                    if ($temp =~ /\(/) {
                        $temp =~ s/join\(//;
                        $exp2 = $temp . ".";
                    } elsif ($temp =~ /\)/) {
                        $temp =~ s/\)//;
                        if ($temp =~ /\@ARGV/) {
                            $exp3 = "(sys.argv[1:])";
                        }
                    }
                }

            }
        } elsif ($line =~ /\\n/) {
            $exp4 = ")" . "\n";
        }
    }
    $exp5 = "print(".$exp2."join".$exp3.$exp4;
    push(@outputs, $exp5);
}

# Set four, combined strings printing:
# this one is only past by given examples
# conditions have:
# print "$line_count lines\n" ====> print("%s lines" % line_count)
sub CombinedPrint {
    my ($indent, @words) = @_;
    my $exp1;
    my $exp2 = "";
    my $exp3 = "";
    my $exp4 = "";
    my $exp5 = "";
    my $exp6 = "";
    my $spaces = "";
    my $var;
    my $newLineFlag = 0;
    for ($i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    foreach my $word (@words) {
        chomp $word;
    }
    foreach my $word (@words) {
        if ($word ne "") {
            if ($word =~ /print[\s]*/) {
                $word =~ s/print[\s]*/print/;
                $exp1 = $word . "(\"";
            } elsif ($word =~ /\$\w+\s+\w+/) {
                @segments = split(" ", $word);
                foreach my $s (@segments) {
                    if ($s =~ /\$/) {
                        $s =~ s/\$//;
                        $var = $s;
                        $s =~ s/\w+/\%s /g;
                        $exp2 = $s;
                    } else {
                        if ($s =~ /\\n/) {
                            $s =~ s/\\n//;
                            $newLineFlag = 1;
                        }
                        $exp3 = $s;
                    }
                }
                $exp4 = $exp2 . $exp3."\" "."% ".$var;
            } elsif ($word =~ /\\n/) {
                $exp5 = ")" . "\n";
            }
        }
    }
    $exp6 = $exp1 . $exp4 . $exp5;
    if ($newLineFlag == 1) {
        $exp6 .= ")"."\n";
    }
    push(@outputs, $exp6);
}

# Subset Four:
# /.*/--->rematch without any "$" sign:
# conditions have:
# $number  = $ARGV[0] =~ /[0-9]/; ----> $number  = $ARGV[0] =~ /[0-9]/;
sub ReMatch {
    my ($indent, @words) = @_;
    my $exp1 = "";
    my $exp2 = "";
    my $exp3 = "";
    my $exp4 = "";
    my $spaces = "";
    for ($i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    foreach my $x (@words) {
        $x =~ s/^\s*//g;
        chomp $x;
        if ($x =~ /\~/) {
            $x =~ s/\~\s*//g;
            $x =~ s/\///g;
            $x =~ s/\///g;
        }
    }
    for (my $y = 0; $y < 3; $y++) {
        if ($words[$y] =~ /\@/) {
            $words[$y] =~ s/\@//;
        }
        if ($y == 0) {
            $exp1 = $words[$y]."=";
        } elsif ($y == 1){
            if ($words[$y] =~ /ARGV/) {
                $buff = $words[$y];
                $buff =~ s/ARGV//g;
                $buff =~ s/\[//g;
                $buff =~ s/\]//g;
                $buffs = int($buff) + 1;
                $words[$y] =~ s/ARGV\[.*\]/sys\.argv[$buffs]/g;
                $exp3 = "\,".$words[$y]."\)";
            } else {
                $exp3 = "\,".$words[$y]."\)";
            }
        } elsif ($y == 2) {
            $exp2 = "re\.match\(r\'".$words[$y]."\'"
        }
    }
    $exp4 = $spaces.$exp1.$exp2.$exp3."\n";
    return $exp4;
}

# Subset two:
# for loop
# conditions have:
# I have assume that there is a space after a semicolon.
# for (my $var = 0; $var < expression; $var++) {
    # body...
# }
sub ForLoop {
    my ($indent, @words) = @_;
    my $exp1 = "";
    my $exp2 = "";
    my $exp3 = "";
    my $exp4 = "";
    my $exp5 = "";
    my $spaces = "";
    my $count = 0;
    my $prev_flag = 0;
    for ($i = 0; $i < $indent; $i++) {
        $spaces .= " ";
    }
    foreach my $var (@words) {
        $var =~ s/\$//g;
        if ($var =~ /for/) {
            $exp1 = $var." ";
        } elsif ($var =~ /[\+\-]{2}/) {
            $var =~ s/[\+\-]{2}//g;
            $var =~ s/\)//g;
            $exp2 = $var. " ";
        } elsif ($var =~ /^\d$/) {
            if ($count == 0) {
                $exp3 = $var."\,";
                $count ++;
            } elsif ($count == 1) {
                $exp4 = $var;
            }
        } elsif ($var =~ /(\>|\<|\>\=|\<\=|\=\=)/) {
            $prev_flag = 1;
        } elsif ($prev_flag == 1 && $var !~ /^\d$/) {
            if ($var =~ /ARGV/) {
                $buff = $var;
                $buff =~ s/ARGV//g;
                $buff =~ s/\[//g;
                $buff =~ s/\]//g;
                $buffs = $buff + 1;
                $var =~ s/ARGV\[.*\]/int\(sys\.argv[$buffs]\)/g;
            }
            $exp4 = $var;
            $prev_flag ++;
        }
    }
    $exp5 = $spaces.$exp1.$exp2."in range\(".$exp3.$exp4."\)"."\:\n";
    push(@outputs, $exp5);
}

# Input function:
# some changes are simple, so I don't create a new subroutine.
#1. Reading a file line by line and finding special character:
#2. first delete semicolon
#3. mathching any comments with "#" beginning
#4. mathcing any shebang
#5. mathcing any print:
   #5.a. strings combined woth variables
   #5.b. pure strings
   #5.c. pure variables
#6. matching foreach statement
#7. matching any $variables while using in the context
   #7.a. matching "eq"
   #7.b. matching "$" sign
   #7.c. matching chomp
   #7.d. matching STDIN
#8. matching "s/blah/blah" ===>re.sub(...)
#9. mathching "++" ==> += 1
#10. matching "last" ==> breaks
#11. matching join, push, pop, reverse, unshift, shift in various types.
sub Input {
    my ($line) = @_;
    $line =~ s/;//g;
    # comments:
    if ($line =~ /^\#/ && $line !~ /#!\/usr\/bin\/perl -w/) {
        push(@outputs,$line);
    # calling different types of print functions:
    } elsif ($line =~ /#!\/usr\/bin\/perl -w/) {
        Title $line;
    } elsif ($line =~ /print/) {
        $buff = $line;
        @buff = $buff =~ /./g;
        $indent = 0;
        foreach my $x (@buff) {
            if ($x eq "p") {
                last;
            }
            $indent++;
        }
        if ($line =~ /\w*\s*\$\w+\s+\w+/) {
            # this is to match combined strings with variables.
            # such as "$num_line lines" --> (%s lines)
            $line =~ s/^[ ]*//g;
            @line = split("\"", $line);
            CombinedPrint $indent, @line;
        } elsif ($line !~ /\$/ && $line !~ /\@/) {
            $line =~ s/^[ ]*//g;
            @line = split("\"", $line);
            PrintFunction $indent, @line;
        } elsif ($line =~ /\$/) {
            if ($line =~ /print/) {
                $line =~ s/^[ ]*//g;
                @line = split("\"", $line);
                VariablesPrint $indent, @line;
            }
        } elsif ($line =~ /\@/) {
            if ($line =~ /join/) {
                @line = split("\"", $line);
                PrintJoin $indent, @line;
            } elsif ($line =~ /reverse/) {
                $line =~ s/\@//g;
                @words = split(" ", $line);
				$exp0 = $words[0];
				$exp1 = $words[1];
				$exp2 = $words[2];
                $line =~ s/print\s*reverse.*/$exp0\($exp2\.$exp1\(\)\)/;
                push(@outputs, $line);
            } else {
                $line =~ s/\@//g;
                @words = split(" ", $line);
				$exp0 = $words[0];
				$exp1 = $words[1];
                $line =~ s/print.*/$exp0\($exp1\)/;
                push(@outputs, $line);
            }
        }
    # foreach statements:
    # conditions have:
    # foreach $i (@array)
    # foreach $i (sort keys @array)
    # foreach $i (0..4)
    } elsif ($line =~ /foreach\s*/) {
        $line =~ s/my\s*//g;
        $line =~ s/foreach/for/;
        $line =~ s/\$//g;
        $line =~ s/\(/in /;
        if ($line =~ /\@ARGV/) {
            $line =~ s/\@ARGV/sys.argv[1:]/
        } else {
            $line =~ s/\@//g;
        }
        $line =~ s/\)//;
        $line =~ s/[\s]*{/:/;
        if ($line =~ /keys/) {
            $buffer = $line;
            $buffer =~ s/.*keys/keys/;
            $buffer =~ s/\%//;
            $buffer =~ s/://;
            @words = split(" ", $buffer);
            $expr = $words[1].".keys():";
            $line =~ s/keys.*/$expr/;
        }
        if ($line =~ /\d\.\./) {
            $buffer = $line;
            @preNumbers = split(" ", $buffer);
            foreach my $x (@preNumbers) {
                if ($x =~ /\d\.\./) {
                    $x =~ s/://;
                    $x =~ s/\.\./,/;
                    if ($x !~ /#ARGV/) {
                        @nums = split(",",$x);
                        for (my $y = 0; $y < 2;$y++) {
                            if ($y == 0) {
                                $start = $nums[$y];
                            } else {
                                $end = $nums[$y];
                                $end++;
                            }
                        }
                    } elsif ($x =~ /\#ARGV/) {
                        $line =~ s/0\.\.\#ARGV/range(len(sys.argv) - 1)/;
                    }
                }
            }
            if ($line !~ /ARGV/ && $line !~ /sys\.argv/) {
                $line =~ s/\d\.\.[\d\#\w]*/range($start,$end)/;
            }
        }
        push(@outputs, $line);
    # calling for loop functions:
    } elsif ($line =~ /for\s*/) {
        $line =~ s/my//g;
        $buff = $line;
        @buff = $buff =~ /./g;
        $indent = 0;
        foreach my $x (@buff) {
            if ($x ne " ") {
                last;
            }
            $indent++;
        }
        @line = split(" ", $line);
        ForLoop $indent, @line;
    # grep any stuff associate with $variable:
    # if some functions are not associate with $variable, I also include outside this condition.
    } elsif ($line =~ /\$/) {
        $line =~ s/\$//g;
        $line =~ s/my //g;
        # change hash:
        # $hash{$dic} ----> hash[dic]
        if ($line =~ /\w+{\w+}/) {
            $line =~ s/\{/\[/;
            $line =~ s/\}/\]/;
        }
        # "{" end of line -----> ":" end of line
        # conditions have:
        # if (....) {
        # while (....) {
        if ($line =~ /[\s]*\{$/) {
            $line =~ s/[\s]*{/:/;
        }
        # change "eq" ---> "=="
		# "ne" --> !=
        # "" --> None
        # exclude some non-related words containing eq:
        if ($line =~ /eq\s*.*\)/ && $line !~ /\/.*eq.*\//) {
            $line =~ s/eq/\=\=/g;
        }
        if ($line =~ /if\s*\(\w+ ne .*\)/) {
            $line =~ s/ne/\!\=/g;
        }
        if ($line =~ /[\=\!]{2}\s*\"\"/) {
            $line =~ s/\"\"/None/;
        }
        # only two conditions:
        # $length = @array;
        # @array = split("blah", $line);
        if ($line =~ /\@/ && $line !~ /shift/ && $line !~ /append/ && $line !~ /pop/ && $line !~ /push/) {
            if ($line =~ /split/) {
                $line =~ s/\@//g;
                $line =~ s/split/re\.split\(r\'/;
                $line =~ s/\s*\///;
                $line =~ s/\//\'/;
            } else {
                $line =~ s/\@/len\(/;
            }
            chomp $line;
            $line = $line.")"."\n";
        }
        # grep if ($blah !~ /.../)
        if ($line =~ /if.*\!\~/) {
            $buffer = $line;
            $buffer =~ s/\(//;
            $buffer =~ s/\)\://;
            @lines = split(" ", $buffer);
            $lines[3] =~ s/\///;
            $lines[3] =~ s/\///;
            $exp = "not " . "re\.match\(r\'" . $lines[3] . "\'\, ".$lines[1];
            $line =~ s/\(.*\)/\($exp\)\)/;
        }
        # grep if ($blah =~ /.../)
        if ($line =~ /if.*\=\~/) {
            $buffer = $line;
            $buffer =~ s/\(//;
            $buffer =~ s/\)\://;
            @lines = split(" ", $buffer);
            $lines[3] =~ s/\///;
            $lines[3] =~ s/\///;
            $exp = "re\.match\(r\'" . $lines[3] . "\'\, ".$lines[1];
            $line =~ s/\(.*\)/\($exp\)\)/;
        }
        # shift:
		# $blah = shift @array; ---> blah = array.pop(0);
        if ($line =~ /shift/ && $line !~ /unshift/) {
            if ($line =~ /\@ARGV/) {
                $line =~ s/shift\s*\@ARGV/sys\.argv\.pop\(1\)/;
            } else {
                $buffer = $line;
                $buffer =~ s/.*shift\s*\@//g;
                chomp $buffer;
                $line =~ s/shift.*/$buffer\.pop(0)/;
            }
        }
        # pop :
        # condition: $line = pop @array;
        if ($line =~ /pop/) {
            $line =~ s/\@//g;
            $line =~ s/\,//g;
            $buffer = $line;
            $buffer =~ s/^[ ]*//g;
            @lines = split(" ", $buffer);
            $exp1 = $lines[3];
            $line =~ s/pop.*/$exp1\.pop\(\)/;
        }
        # push @array, $ele:
        if ($line =~ /push/) {
            $line =~ s/\@//g;
            $line =~ s/\,//g;
            @lines = split(" ", $line);
            $exp1 = $lines[1];
            $exp2 = $lines[2];
            $line =~ s/push.*/$exp1\.append\($exp2\)/;
        }
        # unshift @array, $ele;
        if ($line =~ /unshift/) {
            $line =~ s/\@//g;
            $line =~ s/\,//g;
            @lines = split(" ", $line);
            $exp1 = $lines[1];
            $exp2 = $lines[2];
            $line =~ s/unshift.*/$exp1\.insert\($exp2\)/;
        }
        # for the sake of demo00.pl
        # change ARGV[0/1/2...]
        if ($line =~ /ARGV/ && $line !~ /\=\~/ && $line !~ /#/) {
            if ($line !~ /if/)  {
                $buff = $line;
                $buff =~ s/.*ARGV//g;
                $buff =~ s/\[//g;
                $buff =~ s/\]//g;
                $buffs = $buff + 1;
                $line =~ s/ARGV\[.*\]/int\(sys\.argv[$buffs]\)/g;
            } else {
                $line =~ s/ARGV/sys\.argv/;
            }
        }
        if ($line =~ /\}\s*elsif/) {
            $line =~ s/\}\s*elsif/elif/;
		# grep "chomp"
        } elsif ($line =~ /chomp/) {
            $buff = $line;
            @buff = $buff =~ /./g;
            $indent = 0;
            foreach my $x (@buff) {
                if ($x eq "c") {
                    last;
                }
                $indent++;
            }
            $line =~ s/chomp[\s]*/chomp /;
            @line = split(" ", $line);
            $line = ChangingChomp $indent, @line;
			# grep <> and <STDIN>
        } elsif ($line =~ /<STDIN>/ || $line =~ /<>/) {
            if ($line !~ /while/) {
                $line =~ s/<STDIN>/sys.stdin.readline()/;
            } elsif ($line =~ /while/) {
                $line =~ s/while\s*\(/for /;
                if ($line =~ /\<\>/) {
                    $line =~ s/\=\s*\<\>\)/in fileinput.input()/;
                } elsif ($line =~ /<STDIN>/) {
                    $line =~ s/\=\s*\<\STDIN>\)/in fileinput.input()/;
                }
            }
        # delete while (<F>) {
        # change the line where open is located.
        # have a look on demo02.pl
        # open F, "$blah" ----> with open(blah) as infile:
        } elsif ($line =~ /<.+>/ && $line !~ /<STDIN>/) {
            $line = "";
        } elsif ($line =~ /open/) {
            $buffer = $line;
            @lines = split("\"", $buffer);
            $buff2 = $lines[1];
            $line =~ s/open.*/with open\($buff2\) as infile\:/;
        # replace s/blah/blah --> re.sub(....)
        } elsif ($line =~ /=~[\s]*s\//) {
            $line =~ s/=~/=/;
            $line =~ s/s\//re\.sub\(r'/;
            $line =~ s/g//;
            $temp = $line;
            @replace = split("\/", $temp);
            @buffers = split(" ", $replace[0]);
            $vName = $buffers[0];
            $alter = $replace[1];
            $line =~ s/\/.*\//\'\, \'$alter\'\, $vName\)/;
        } elsif ($line =~ /\#ARGV/) {
            $line =~ s/\#ARGV/len\(sys\.argv\)\-2/g;
        # /blah/ ----> re.match(....)
        } elsif ($line =~ /.+\s*=\s*.+\s*\=\~\s*\/.*\//) {
            $buff = $line;
            @buff = $buff =~ /./g;
            $indent = 0;
            foreach my $x (@buff) {
                if ($x ne " ") {
                    last;
                }
                $indent++;
            }
            @line = split("\=", $line);
            $line = ReMatch $indent, @line;
        } elsif ($line =~ /\+\+/) {
            $line =~ s/\+\+/\+\=1/g;
        } elsif ($line =~ /\-\-/) {
            $line =~ s/\-\-/\-\=1/g;
        }
        push(@outputs, $line);
    # followings are shift, push, pop and unshift WITHOUT any "$" sign:
    # have a look on test02.pl
    # for instance:
    # unshift @array, "Kevin";
    # push @array, "dog";
    # pop @array;
    # reverse @array;
    # pop @array;
    } elsif ($line =~ /unshift/) {
        $line =~ s/\@//g;
        $line =~ s/\,//g;
        @lines = split(" ", $line);
        $exp1 = $lines[1];
        $exp2 = $lines[2];
        $line =~ s/unshift.*/$exp1\.insert\(0\, $exp2\)/;
        push(@outputs,$line);
    } elsif ($line =~ /push/) {
        $line =~ s/\@//g;
        $line =~ s/\,//g;
        @lines = split(" ", $line);
        $exp1 = $lines[1];
        $exp2 = $lines[2];
        $line =~ s/push.*/$exp1\.append\($exp2\)/;
        push(@outputs,$line);
    } elsif ($line =~ /pop/) {
        $line =~ s/\@//g;
        @lines = split(" ", $line);
        $exp1 = $lines[1];
        $line =~ s/pop.*/del $exp1\[len\($exp1\)-1]/;
        push(@outputs,$line);
    } elsif ($line =~ /shift/) {
        if ($line =~ /\@ARGV/) {
            $line =~ s/shift\s*\@ARGV/sys\.argv\.pop\(1\)/;
        } else {
            $buffer = $line;
            $buffer =~ s/.*shift\s*\@//g;
            chomp $buffer;
            $line =~ s/shift.*/$buffer\.pop(0)/;
        }
        push(@outputs,$line);
    } elsif ($line =~ /reverse/) {
        $line =~ s/\@//g;
        @lines = split(" ", $line);
        $exp1 = $lines[1];
        $line =~ s/reverse.*/$exp1\.reverse\(\)/;
        push(@outputs,$line);
	# if statements without "$" sign 
    } elsif ($line =~ /[\s]*\{/) {
        if ($line =~ /\}\s*else/) {
            $line =~ s/\}\s*else/else/;
        }
        if ($line =~ /\@/) {
            $line =~ s/\@//g;
        }
        $line =~ s/[\s]*\{/:/;
        push(@outputs,$line);
    } elsif ($line =~ /\}/) {
        $line =~ s/\}//;
        chomp $line;
	# The followings are other stuff:
	# last --> break
    # exit --> sys.exit
	# next --> continue
	# hash with % and {blah} 
    } elsif ($line =~ /last/){
        $line =~ s/last/break/;
        push(@outputs,$line);
    } elsif ($line =~ /exit/) {
        $line =~ s/exit/sys\.exit/g;
        push(@outputs,$line);
    } elsif ($line =~ /next/) {
        $line =~ s/next/continue/;
        push(@outputs,$line);
    } elsif ($line =~ /\@.*\s*=\s*\(\)/) {
        $line =~ s/\@//g;
        $line =~ s/\(\)/\[\]/;
        push(@outputs,$line);
    } elsif ($line =~ /\%/) {
        $line =~ s/\%//;
        $line =~ s/\(/\{/;
        $line =~ s/\)/\}/;
        push(@outputs,$line);
    } else {
        push(@outputs,$line);
    }
}

# Main funtion:
# Read from ARGV[0] or STDIN into Input subroutine.
if ($#ARGV+1 == 0) {
    while ($line = <STDIN>) {
        Input $line;
    }
} else {
    open(F, "$ARGV[0]") or die "$0: Can't open the file: $!\n";
    while ($line = <F>) {
        Input $line;
    }

}

# adding flags:
# adding:
# import sys
# import re
# import fileinput
$sys_flag = 0;
$input_flag = 0;
$re_flag = 0;
foreach my $output (@outputs) {
    if ($output !~ /^#/) {
        if ($output =~ /sys/) {
            $sys_flag = 1;
        }
        if ($output =~ /fileinput/) {
            $input_flag = 1;
        }
        if ($output =~ /re/ && $output !~ /readline\(\)/) {
            $re_flag = 1;
        }
    }
}

if ($re_flag == 1) {
    unshift(@outputs, "import re\n");
}
if ($input_flag == 1) {
    unshift(@outputs, "import fileinput\n");
}
if ($sys_flag == 1) {
    unshift(@outputs, "import sys\n");
}

# count the number of lines need to be printed:
$total_lines = 0;
foreach my $output (@outputs) {
    $total_lines++;
}

# Adding float():
# if sys.stdin.readline() was a number, add float() outside it.
# for instance: <STDIN> --> float(sys.stdin.readline())
for ($pos = 0;$pos < $total_lines; $pos++) {
    if ($outputs[$pos] =~ /sys\.stdin\.readline\(\)/) {
        $buffer = $outputs[$pos];
        $buffer =~ s/= sys\.stdin\.readline\(\)//;
        $var = $buffer;
        $var =~ s/^[ ]*//g;
        chomp $var;
        $numCmp_flag = 0;
        for ($i = 0;$i < $total_lines; $i++) {
            if ($outputs[$i] =~ /$var\s*\=\=\s*\d/ || $outputs[$i] =~ /$var\s*\>\s*\d/
                || $outputs[$i] =~ /$var\s*\<\s*\d/ || $outputs[$i] =~ /$var\s*\>\=\s*\d/
                || $outputs[$i] =~ /$var\s*\<\=\s*\d/ || $outputs[$i] =~ /[$var]\s*[\+\-\*\/\%]\s*/
                || $outputs[$i] =~ /[$var]\s*\*\*\s*/) {
                $numCmp_flag = 1;
                last;
            }
        }
        if ($numCmp_flag == 1) {
            $outputs[$pos] =~ s/sys\.stdin\.readline\(\)/float\(sys\.stdin\.readline\(\)\)/;
        }
    }
}

# display all the translated python syntax.
for ($pos = 0;$pos < $total_lines; $pos++) {
    print $outputs[$pos];
}
