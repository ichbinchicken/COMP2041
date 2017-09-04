#!/usr/local/bin/python3.5 -u
import fileinput
# written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
# Count the number of lines on standard input.

line = ""
line_count = 0
for line in fileinput.input():
    line_count += 1
print("%s lines" % line_count)
