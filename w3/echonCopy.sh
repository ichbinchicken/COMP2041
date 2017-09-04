#!/bin/sh
size=`echo $1 | egrep '^[0-9]$'|wc -l`
if test $size -eq '0'
then
    echo "./echon.sh: argument 1 must be a non-negative integer"
    exit 1
fi
if test $# -ne 2
then
   echo "Usage: ./echon.sh <number of lines> <string>"
   exit 1
fi

for i in `seq $1`
do
    echo $2 
done
