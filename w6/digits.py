#!/usr/bin/python
#!/usr/bin/python
import fileinput,re
for line in fileinput.input():
    line = line.strip() # remove leading & trailing white space
    line = re.sub(r'[0-4]', '<', line)
    line = re.sub(r'[6-9]', '>', line)
    print line
