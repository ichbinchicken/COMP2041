#!/bin/sh
for file in "$@"
do
   #echo "$file"
   sed 's/COMP2041/COMP2042/;s/COMP9041/COMP9042/' "$file" > /tmp/o
   #ERROR CHECKING
   #mv /tmp/o "$file"
done

