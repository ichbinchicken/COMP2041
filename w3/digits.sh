#!/bin/sh
#set -x
#linenumber=`wc -l $1`
mid=5
#for k in `seq $linenumber`
while read line
do
#output=`cat $1 | head -$k | tail -1`
number=`echo $line |wc -w`
    for i in `seq $number`
    do
        word=`echo $line| cut -d' ' -f$i`
        charNum=`echo $word | wc -c`
        for j in `seq $charNum`
        do
            char=`echo $word| cut -c$j`
            if echo $char |egrep '[0-9]' >/dev/null
            then
                if test $char -lt $mid
                then
                    echo -n "<"  # why must be quoted?
                elif test $char -gt $mid
                then
                    echo -n ">"
                elif test $char -eq $mid
                then
                    echo -n $mid
                fi
            elif echo $char | egrep '[a-zA-Z]' >/dev/null
            then
                echo -n $char
            elif echo $char | egrep '[^a-zA-Z]|[^0-9]' >/dev/null
            then
                echo -n $char
            fi
        done
        if test $i -eq $number
        then
            echo " "
        else
        echo -n " "
        fi
    done
done












#mid=5
    #space=""
#if test $a -lt $mid
#then
#  echo -n '<'  # why must be quoted?
# elif test $a -gt $mid
# then
#     echo -n '>'
# elif test $a -eq $mid
# then
#    echo -n $mid
# fi
#done
