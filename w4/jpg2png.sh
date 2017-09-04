#!/bin/sh

#  jpg2png.sh
#  
#
#  Created by Ziming Zheng on 17/08/2016.
#
for jpgfile in *
do
    pngfile=`echo "$jpgfile" | sed -e 's/.jpg/.png/'`
    if test "$pngfile" = "$jpgfile"
    then
        continue
    fi
    if test -e "$pngfile"
    then
        echo "$pngfile already exists"
        continue
    fi
    mv "$jpgfile" "$pngfile"
done