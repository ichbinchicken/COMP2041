#!/bin/sh

#  email_image.sh
#  
#
#  Created by Ziming Zheng on 17/08/2016.
#
if test $# -eq 0
then
    echo "Usage: ./email_image.sh name1.png name2.png..."
    exit 1
fi
    for file in "$@"
do
    display $file && echo "Address to e-mail this image to?"
    read address
    echo "Message to accompany image?"
    read message
    echo "$message"|mutt -s 'Share a picture to you!' -a "$1" -- $address
    echo "$1 sent to $address"
done
