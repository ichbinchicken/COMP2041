#!/usr/bin/python
import re,sys
number = []
breed = []
for line in sys.stdin:
    line = line.strip()
    array = []
    array = re.split(r'(^[0-9]+|[a-zA-Z]+[\s[a-zA-Z]*]\W*)', line)
# question: why python can ignore the space in the element of array? for instance, " humpback" in the array compared with "humpback" in argv[1]???? 
    print array
    number.append(array[1])
    breed.append(array[2])
#print number
#print breed
total = len(breed)
#print total
curr = 0
ar = 0
arrange_number = []
arrange_breed = []
pods = []
while (curr < total):
    after = curr + 1
    if (number[curr] != -1) :
        pods.append(1)
        arrange_number.append(number[curr])
        arrange_breed.append(breed[curr])
        while (after < total):
            if (breed[curr] == breed[after]):
                pods[ar] = pods[ar] + 1
                number[after] = int(number[after])
                arrange_number[ar] = int(arrange_number[ar])
                arrange_number[ar] = arrange_number[ar] + number[after]
                number[after] = -1
            after = after + 1
        ar = ar + 1
    curr = curr + 1
n = 0
sum_arrange = len(arrange_breed)
#for k in arrange_breed:
#    print k
#for j in arrange_number:
#    print j
while (n < sum_arrange):
    arrange_breed[n] = arrange_breed[n].strip()
    if (sys.argv[1] == arrange_breed[n]):
        print "%s observations: %d pods, %s individuals" %(arrange_breed[n], pods[n], arrange_number[n])
        break
    n = n + 1
if(n == sum_arrange):
    print "%s observations: 0 pods, 0 individuals" %(sys.argv[1])
