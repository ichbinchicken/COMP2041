#!/bin/sh

#  file_sizes.sh
#  
#
#  Created by Ziming Zheng on 14/08/2016.
#

#put all the names of file in different categories
for file in *
do
    lineNum=`cat $file | wc -l`
    if test $lineNum -lt 10
    then
        echo -n "$file " >>less
    elif test $lineNum -lt 100 -a $lineNum -ge 10
    then
        echo -n "$file " >>medium
    elif test $lineNum -ge 100
    then
        echo -n "$file " >>large
    fi
done

#change the format in less, medium and large
for i in less medium large
do
    if test "$i" = "less"
    then
        wordNum=`cat $i | wc -w`
        for j in `seq $wordNum`
        do
        word=`cat $i |cut -d' ' -f$j`
            if test $j -eq $wordNum
            then
                echo "$word" >>lessGood
            else
                echo -n "$word ">>lessGood
            fi
        done
    elif test "$i" = "medium"
    then
        wordNum=`cat $i | wc -w`
        for k in `seq $wordNum`
        do
            word=`cat $i |cut -d' ' -f$k`
            if test $k -eq $wordNum
            then
                echo "$word" >>mediumGood
            else
                echo -n "$word ">>mediumGood
            fi
       done
    elif test "$i" = "large"
    then
        wordNum=`cat $i | wc -w`
        for m in `seq $wordNum`
        do
            word=`cat $i |cut -d' ' -f$m`
            if test $m -eq $wordNum
            then
                echo "$word" >>largeGood
            else
                echo -n "$word ">>largeGood
            fi
        done
    fi
done


#show the files
lessWords=`cat lessGood`
echo "Small files: $lessWords"
mediumWords=`cat mediumGood`
echo "Medium-sized files: $mediumWords"
largeWords=`cat largeGood`
echo "Large files: $largeWords"

rm less lessGood medium mediumGood large largeGood




