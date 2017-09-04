#!/usr/bin/python
import sys,re
array=[]
words=[]
for line in sys.stdin:
	words=re.findall(r'(\b[A-Za-z]+\b)',line)
	for each in words:
		array.append(each)
length=len(array)
print "%d words"%(length)
