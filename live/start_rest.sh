#!/bin/bash

# settings at home
card=0
device=0

#arecord -l | grep Q9000 | sed -e 's/card \([0-9]\).*device \([0-9]\).*/\1,\2/g'

# settings at office
if [ $(arecord -l | grep Q9000 | wc -l) -eq 1 ]; then
	card=2
	device=0
fi

yellow="\033[0;33m"
nocolor="\033[0m"

echo -e "${yellow}using card $card and device $device${nocolor}" > /dev/stderr

arecord -D hw:$card,$device -f CD -t wav \
	| sox -t wav - -e signed-integer -c 1 -b 16 --endian little -r 44100 -t raw - \
	| ./rest.py --model ../data/data.mat $@
