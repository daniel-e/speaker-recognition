#!/usr/bin/env python3

# ./start_rest.sh

# reads a raw audio stream from stdin
# requirements: signed, little endian, one channel

import argparse, collections, threading, time, logging
from oct2py import octave
from threading import Thread
from flask import Flask, jsonify

from audio import Audio
from classification import Classifier
from storage import Storage

parser = argparse.ArgumentParser(description = "")
parser.add_argument("-r", type = int, default = 44100, help = "sample rate")
parser.add_argument("-b", type = int, default = 16, help = "bits")
parser.add_argument("--winlen", type = int, default = 100, help = "window length in ms")
parser.add_argument("--tostdout", action = "store_true", help = "write audio stream to stdout")
parser.add_argument("--model", help = "model for classification")
parser.add_argument("--port", type = int, default = 5001, help = "model for classification")
args = parser.parse_args()

# set log level for Flask
logging.getLogger("werkzeug").setLevel(logging.ERROR)

octave.addpath("../octave")
audio = Audio(rate = args.r, bits = args.b)
app = Flask(__name__)
target = Storage()

def listen(winlen, tostdout, model):
    clf = Classifier(model)
    while True:
        t = audio.recv(winlen).as_float_vec()
        r = octave.analyze_row_vec(t)
        if len(r) > 0:
            print("XX", len(t), len(r))
            r = octave.reduce_features_row_vec(r)
            c = "-"
            if len(r) == 1:
                print(len(r[0]))
                c = clf.predict(r[0])
            target.set(c)
            print (c)
        if tostdout:
            print("\n".join(map(str, t)))

@app.route("/status", methods = ["GET"])
def status():
    return jsonify(label = str(target.get()))

def main():
    # thread to read the audio stream
    Thread(target = listen, args = (args.winlen, args.tostdout, args.model)).start()
    # start REST service
    app.run(port = args.port)

if __name__ == "__main__":
    main()
