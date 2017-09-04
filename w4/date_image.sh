#!/bin/sh

#  date_image.sh
#  
#
#  Created by Ziming Zheng on 17/08/2016.
#
if test $# -eq 0
then
echo "Usage: ./date_image.sh name1.png name2.png..."
exit 1
fi
for file in $1
do
    cmd=`ls -l $1`
    echo $cmd
    words=`echo "$cmd" | cut -d' ' -f6-9`
    echo $words
    convert -gravity south -pointsize 36 -draw "text 0,10 '$words'" penguins.jpg temporary_file.jpg
    #display penguins.jpg
done
