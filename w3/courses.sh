#!/bin/sh


#set -x
echo 1 >course 
alphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZ
for i in `seq 26`
do
#extract the content from URL, there are some weird courses in MATH, so we cut -f7-8 to include something we missed when we used cut -f7
p=`echo $alphabet | cut -c $i`
wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=$p"|grep "$1" | cut -d'/' -f7-8| cut -c 1-8,15-|tr '>' ' '|cut -d'<' -f1|sort -n|uniq|sed '1d' >> course
done

for i in `seq 26`
do
p=`echo $alphabet | cut -c $i`
wget -q -O- "http://www.handbook.unsw.edu.au/vbook2016/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=$p"|grep "$1" | cut -d'/' -f7-8| cut -c 1-8,15-|tr '>' ' '|cut -d'<' -f1|sort -n|uniq|sed '1d' >> course
done

#sed '1d' is because this is a number in the file of "course"
cat course | sed '1d' | sort -n | uniq |egrep '^[A-Z]{4}[0-9]{4}'| egrep -v '[A-Z]{4}[)]' > course


#for doing this one, there is also some weird expession of course, which is that a space is after the end the line and if we do uniq, shell will regard as two different expressions.
linenumber=`cat course | wc -l`
for i in `seq $linenumber`
do
output=`head -$i course| tail -1`
number=`echo $output | wc -w`
echo $output | cut -d' ' -f1-$number >>new
done
uniq new | cat new
rm new








#linenumber=`wc -l `
#for i in `seq $linenumber`
#do
#output=`cat wenjian | head $m | tail 1`
#number=echo output | wc -w
#jandsflnaewof | kansdf e > new
#cat new | uniq
#size=`wc -c















