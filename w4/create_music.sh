#!/bin/sh

#  create_music.sh
#  
#
#  Created by Ziming Zheng on 22/08/2016.
#
ls music | sed 's/ T/\nT/g' >>albumName
for j in music/*/*
do
   echo "$j" >>musicName
done
number=`cat albumName | wc -l`
number2=`cat musicName | wc -l`
for time in `seq $number2`
do
   string=`cat musicName | head -$time | tail -1 | cut -d'/' -f3`
   echo $string >>musicNameGood
done
mkdir $2
cd $2
for counter in `seq $number`
do
   title=`cat ~/program/2041/w4/albumName| head -$counter | tail -1`
   mkdir "$title"
done

#copy the folder name
for file in *
do
   cd "$file"
   touch $1
   for count in `seq 10`
   do
      cp "$1" "$count.mp3"
   done
   rm $1
   cd ..
done
number3=`cat ~/program/2041/w4/musicNameGood | wc -l`

#copy each music name
n=0
for file2 in *
do
   cd "$file2"
   if test $n -eq 0
   then
      p=1
      for file4 in *
      do
         readline2=`cat ~/program/2041/w4/musicNameGood | head -$p | tail -1`
         mv "$p.mp3" "$readline2"
         p=$[$p+1]
      done
   else
      l=1
      for file3 in *
      do
         m=$[$n*10]
         readline=`cat ~/program/2041/w4/musicNameGood | sed '1,'$m'd' | head -$l | tail -1`
         mv "$l.mp3" "$readline"
         l=$[$l+1]
      done
   fi
   cd ..
   n=$[$n+1]
done

rm ~/program/2041/w4/albumName
rm ~/program/2041/w4/musicName
rm ~/program/2041/w4/musicNameGood