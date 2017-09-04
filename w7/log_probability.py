#!/usr/bin/python
import sys,re,glob,math
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
	result=math.log(float(count+1)/total)

	file = re.sub(r'_', ' ',file)
	file = re.sub('.txt','',file)
	file = re.sub('poems\/','',file)
	print "log((%d+1)/%6d) = %8.4f %s"%(count,total,result,file)
