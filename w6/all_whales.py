#!/usr/bin/python
import re,sys
number = []
breed = []
for line in sys.stdin:
    line = line.strip()
    array = []
    array = re.split(r'(^[0-9]+|[a-zA-Z]+[\s[a-zA-Z]*]\W*)', line)
    #print array
    number.append(array[1])
    array[2] = re.sub(r'[ ]+', ' ', array[2])
    array[2] = re.sub(r'^[ ]*', '', array[2])
    array[2] = array[2].lower()
    array[2] = re.sub(r's$', '', array[2])
    #print array[2]
    breed.append(array[2])

#print number
#print breed
total = len(breed)
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
        arrange_number[ar] = int(arrange_number[ar])
        arrange_breed.append(breed[curr])
        while (after < total):
            if (breed[curr] == breed[after]):
                pods[ar] = pods[ar] + 1
                number[after] = int(number[after])
#                arrange_number[ar] = int(arrange_number[ar])
                arrange_number[ar] = arrange_number[ar] + number[after]
                number[after] = -1
            after = after + 1
        ar = ar + 1
    curr = curr + 1
n = 0
#for k in arrange_breed:
#    print k
#for j in arrange_number:
#    print j
#print "\n"
#for l in pods:
#    print l
arrange_breed_r = arrange_breed

sum_arrange = len(arrange_breed)
pod_set = {}
counter = 0
while (counter < sum_arrange):
    pod_set.setdefault(arrange_breed_r[counter], pods[counter])
    counter = counter + 1
items = pod_set.items()
items.sort()
pods = []
arrange_breed = []
for key,value in items:
#    print key, value
    arrange_breed.append(key)
    pods.append(value)
#print pods
#print arrange_breed

number_set = {}
counter = 0
while (counter < sum_arrange):
    number_set.setdefault(arrange_breed_r[counter], arrange_number[counter])
    counter = counter + 1
items = number_set.items()
items.sort()
arrange_number = []
for key,value in items:
#    print key, value
    arrange_number.append(value)
#print arrange_number
#print arrange_breed
pos = 0
while (pos < sum_arrange):
    print "%s observations: %d pods, %s individuals" %(arrange_breed[pos], pods[pos], arrange_number[pos])
    pos = pos + 1
