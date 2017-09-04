#!/bin/sh
a=4
b=$[$a%2]
echo $b
if test $b -eq 0
then
   echo yes
fi
