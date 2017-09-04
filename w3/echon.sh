#!/bin/sh
if test $# -ne 2
then
    echo "Usage: ./echon.sh <number of lines> <string>"
    exit 1
elif egrep '-' <<<$1 > /dev/null
then
        echo "./echon.sh: argument 1 must be a non-negative integer"
        exit 1
elif egrep '^[a-zA-Z]+$' <<<$1 > /dev/null
then
    echo "./echon.sh: argument 1 must be a non-negative integer"
    exit 1
fi

for i in `seq $1`
do
    echo $2 
done
