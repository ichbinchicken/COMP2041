#!/usr/bin/python
import sys,re,subprocess
dic = {}
f_flag = False
if (sys.argv[1] == "-f"):
    f_flag = True
    sys.argv.pop(1) #shift function in perl
for url in sys.argv[1:]:
    webpage = subprocess.check_output(["wget", "-q", "-O-", url], universal_newlines=True)
    tags = re.findall('<[A-Za-z0-9]+',webpage) #\/?
    for tag in tags:
        tag = tag.lower();
        tag = re.sub('<','',tag)
        if(dic.has_key(tag) == False):
            dic[tag] = 1
        else:
            dic[tag] += 1
if (f_flag == False) :
    for key in sorted(dic.keys()):
        print key,dic[key]
else :
    names = []
    nums = []
    names = dic.keys()
    nums = dic.values()
    # while split the value and key, the value is in accordance to
    # the order in dictionary (Python is great).
    # using standard bubble sort:
    total = len(nums)
    num_pos = 0
    while (num_pos < total) :
        nswaps = 0
        num_pos2 = total - 1
        while (num_pos2 > num_pos) :
            if (nums[num_pos2] < nums[num_pos2 - 1]) :
                tmp = nums[num_pos2]
                nums[num_pos2] = nums[num_pos2 - 1]
                nums[num_pos2 - 1] = tmp
                tmp2 = names[num_pos2]
                names[num_pos2] = names[num_pos2 - 1]
                names[num_pos2 - 1] = tmp2
                nswaps += 1
            num_pos2 -= 1
        if (nswaps == 0) :
            break
        num_pos += 1
    pos = 0
    while (pos < total) :
        print names[pos], nums[pos]
        pos += 1
