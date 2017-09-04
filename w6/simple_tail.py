#!/usr/bin/python
import sys
total = []
argc = len(sys.argv)
#print argc
for i in range(1,argc): #get the total number of lines in each file
    num = len(open(sys.argv[i]).readlines())
    total.append(num)
#print total

for k in range(1,argc):
    with open(sys.argv[k]) as ins:
        array = []
        for line in ins:
            array.append(line)
    value = int(total[k-1])
    if (value < 10):
        index = 0
        while (index < value):
            array[index] = array[index].strip()
            print array[index]
            index = index + 1
    else :
        index = value - 10
        while (index < value):
            array[index] = array[index].strip()
            print array[index]
            index = index + 1
