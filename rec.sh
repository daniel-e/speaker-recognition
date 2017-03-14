#!/bin/bash

if [ -z $1 ]; then
  echo "You have to provide a filename as the first argument."
fi

# select recording device
# if Q9000 is available select this one
hw=$(arecord -l | grep Q9000 | sed -e 's/card \([0-9]\).*device \([0-9]\).*/\1,\2/g')
if [ -z $hw ]; then
	# otherwise select first device
	hw=$(arecord -l | grep card | grep device | head -n1 | sed -e 's/card \([0-9]\).*device \([0-9]\).*/\1,\2/g')
fi

yellow="\033[0;33m"
nocolor="\033[0m"

echo -e "${yellow}using hw:$hw ${nocolor}" > /dev/stderr

arecord -D hw:$hw -f CD -t wav \
	| sox -t wav - -e signed-integer -c 1 -b 16 --endian little -r 44100 -t wav $1
