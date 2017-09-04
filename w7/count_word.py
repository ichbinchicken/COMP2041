#!/usr/bin/python
import sys,re
words=[]
count=0
for line in sys.stdin:
        words=re.findall(r'(\b[A-Za-z]+\b)',line)
        for each in words:
		if(each.lower() == sys.argv[1].lower()):
			count+=1;
print sys.argv[1].lower(),"occurred",count,"times";
