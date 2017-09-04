#!/usr/local/bin/python3.5 -u
import sys
import re
# put your demo script here
# Note: $a3 must be a number, which means in python, it should be used float(sys.stdin.read).
a1 = sys.stdin.readline()
a2 = sys.stdin.readline()
a3 = float(sys.stdin.readline())
array = []
array.append(a1)
array.append(a2)
array.append("mum")
array.append(2)
del array[len(array)-1]
array.insert(0, "Kevin")
for x in array:
    x = x.rstrip()
    print(x)
    print(a3+1,end="")
print(array)
array.reverse()
print(array.reverse())
