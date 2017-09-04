#!/usr/bin/perl -w
# put your demo script here
# some tricks:
# 1. different types of using "=~" and "!~"
# 2. $ARGV[0] 
# 3. "" should be "None" in python3.5
# 4. when you grep "ne" in if condition, if you don't think carefully,
# 5. /line/ on line 8 would also included and changed into != like: /line/ --> /li!=/
$char = $ARGV[0] =~ /[a-z]/;
print $char;
if ($char =~ /[a-z]/) {
	if ($char ne "") {
		if ($char !~ /line/) {
			print "pass!\n";
		}
	}
}
