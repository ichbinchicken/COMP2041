#!/usr/bin/python
import sys,re,glob
words=[]
name=[]
for file in glob.glob("poems/*.txt"):
	total=0
	count=0

	for line in open(file):
        	words=re.findall(r'(\b[A-Za-z]+\b)',line)
        	for each in words:
			total+=1
			if(each.lower() == sys.argv[1].lower()):
				count+=1;
	result=float(count)/total
	file = re.sub(r'_', ' ',file)
	file = re.sub('.txt','',file)
	file = re.sub('poems\/','',file)
	print "%4d/%6d = %.9f %s"%(count,total,result,file)
