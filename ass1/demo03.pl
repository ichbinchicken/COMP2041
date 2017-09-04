#!/usr/bin/perl -w
# put your demo script here
while ($line = <>) {
    @fields = split / /, $line;
    $student_number = $fields[1];
    if ($already_counted{$student_number}) {
        next;
    }
    $already_counted{$student_number} = 1;
    $full_name = $fields[2];
    if ($full_name !~ /.*,\s+(\S+)/) {
        next;
    }
    $first_name = $1;
    $fn{$first_name}++;
}
foreach $first_name (keys %fn) {
    printf "There are %2d people with the first name %s\n", $fn{$first_name}, $first_name;
}
