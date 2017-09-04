#!/bin/sh
hour=`date | cut -d' ' -f4 | cut -d':' -f1`
if [ $hour -gt 8 -a $hour -lt 17 ]
then 
   exit 0 
fi
exit 1
