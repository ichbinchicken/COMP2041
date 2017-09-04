#!/usr/local/bin/python3.5 -u
import sys
print("Enter a number: ",end="")
a = float(sys.stdin.readline())
if (a < 0):
    print("negative")
elif (a == 0):
    print("zero")
elif (a < 10):
    print("small")
else:
    print("large")
