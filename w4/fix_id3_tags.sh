#!/bin/sh

for i in "$@"
do
   for counter in `seq 10`
   do
      string=`ls "$i" | sort -n | head -$counter | tail -1`

      if echo "$string" | egrep 'Cee-Lo' >/dev/null
      then
         artist=`echo $string | sed 's/.mp3//g' | cut -d'-' -f3-4 | sed 's/^ //g'`
         title=`echo $string | sed 's/.mp3//g' | cut -d'-' -f2 | sed 's/^ //g'`
      elif echo "$string" | egrep 'Alt-J' >/dev/null
      then
         artist=`echo $string | sed 's/.mp3//g' | cut -d'-' -f3-4 | sed 's/^ //g'`
         title=`echo $string | sed 's/.mp3//g' | cut -d'-' -f2 | sed 's/^ //g'`
      elif echo "$string" | egrep 'Short Skirt-Long Jacket' >/dev/null
      then
         title=`echo $string | sed 's/.mp3//g' | cut -d'-' -f2-3 | sed 's/^ //g'`
         artist=`echo $string | sed 's/.mp3//g' | cut -d'-' -f4 | sed 's/^ //g'`
      elif echo "$string" | egrep '19-20-20' >/dev/null
      then
         title=`echo $string | sed 's/.mp3//g' | cut -d'-' -f2-4 | sed 's/^ //g'`
         artist=`echo $string | sed 's/.mp3//g' | cut -d'-' -f5 | sed 's/^ //g'`
      else
         title=`echo $string | sed 's/.mp3//g' | cut -d'-' -f2 | sed 's/^ //g'`
         artist=`echo $string | sed 's/.mp3//g' | cut -d'-' -f3 | sed 's/^ //g'`
      fi

#echo $artist
      path=$i/$string
#echo $path
      id3 -t "$title" "$path" >/dev/null
      id3 -a "$artist" "$path" >/dev/null

      album=`echo $i | cut -d'/' -f2`
      id3 -A "$album" "$path" >/dev/null
#echo "$album"
      year=`echo $i | cut -d',' -f2 | sed 's/^ //g'`
      if test `echo "$year" | egrep '/'`
      then
      year=`echo "$year" | sed 's/\///g'`
      fi
      id3 -y "$year" "$path" >/dev/null
#echo "$year"
      track=`echo $string | cut -d' ' -f1`
      id3 -T "$track" "$path" >/dev/null
   done
done


