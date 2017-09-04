#!/usr/bin/python
import sys,re
if len(sys.argv) != 3:
   sys.stderr.write("Usage: %s <number of lines> <string>\n" % sys.argv[0])
   sys.exit(1)
number = re.match(r'[0-9]', sys.argv[1])
if number == None:
   sys.stderr.write("Usage: %s <number of lines> <string>\n" % sys.argv[0])
   sys.exit(1)
char = re.match(r'[a-zA-Z]', sys.argv[2])
if char == None:
   sys.stderr.write("Usage: %s <number of lines> <string>\n" % sys.argv[0])
   sys.exit(1)
value = int(sys.argv[1])
for i in range(0,value):
    print sys.argv[2]
