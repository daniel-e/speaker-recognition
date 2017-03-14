#!/bin/bash

if [ -z $1 ]; then
	echo "You have to provide a filename as the first argument."
	exit 1
fi

# select recording device
# if Q9000 is available select this one
hw=$(arecord -l | grep Q9000 | sed -e 's/card \([0-9]\).*device \([0-9]\).*/\1,\2/g')
if [ -z $hw ]; then
	# otherwise select first device
	hw=$(arecord -l | grep card | grep device | head -n1 | sed -e 's/card \([0-9]\).*device \([0-9]\).*/\1,\2/g')
fi
# select number of channels (the first supported number of channels)
ch=$(arecord -D hw:$hw --dump-hw-params 2>&1 | grep CHANNELS | cut -d: -f2 | sed -e 's/^\s\+//g' | tr -d '[]' | sed -e 's/^\s\+//g' | cut -d\  -f1)



yellow="\033[0;33m"
nocolor="\033[0m"

echo -e "${yellow}using hw:$hw ${nocolor}" > /dev/stderr

arecord -D hw:$hw -f CD -t wav -c $ch \
	| sox -t wav - -e signed-integer -c 1 -b 16 --endian little -r 44100 -t wav $1
