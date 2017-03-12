#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ $# -lt 2 ] || [ $# -gt 2 ]; then
  echo "usage: $0 MODEL SOUNDFILE"
  echo "  MODEL      filename of the model (created via ml.m)"
  echo "  AUDIOFILE  audio file"
  exit 1
fi

model=$1
filename=$2

if [ -z $model ] || [ ! -e $model ]; then
  echo "Model $model does not exist or is not set."
  exit 1
fi

if [ -z $filename ] || [ ! -e $filename ]; then
  echo "Input file $filename does not exist or is not set."
  exit 1
fi

t=$(mktemp)
echo -e '\033[1;33mConverting audio file ...\033[0m'
sox -q $filename -r 44100 -b 16 -c 1 -e signed-integer --endian little -t wav $t

p=$(mktemp)
echo -e '\033[1;33mConverting data into matrix ...\033[0m'
octave predict.m $t $p
echo -e '\033[1;33mPredicting with given model ...\033[0m'
./predict.py $model $p

rm -f $t $p
