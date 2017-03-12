# Simple speaker recognition

This is a demo of a simple machine learning approach to speaker recognition, i.e. the problem of correctly determining the speaker of something said. Roughly, the approach works as follows. First, a model is created based on examples of all possible speakers. Then, this model is used to find the speaker which fits best on unknown samples.

## Requirements

The demo requires the following tools and/or packages:

* `Python 3`: a popular programming language which is also widely used for scientific prototyping
* `Octave`: a programming language for scientific computing largely compatible with Matlab.
* `sox` and `libsox-fmt-mp3`: a tool for audio manipulation and the library for processing mp3 files
* `arecord`: a command-line sound recorder for ALSA soundcard driver
* `libpcre` and `zlib`: libraries required to build the nginx web server

The demo requires the following Python modules:

* `numpy`: fundamental package for scientific computing with Python
* `scipy`: another scientific Python library which includes modules for linear algebra, FFT, optimiation, ...
* `scikit-learn`: Python library for doing machine learning 
* `oct2py`: module to call M-files and Octave function from Python
* `flask`: webdevelopment framework for Python

To install the requirements on an Ubuntu 16.10 execute the following commands:

```bash
sudo apt-get install -y python3 python3-pip octave sox libsox-fmt-mp3 alsa-utils
sudo apt-get install -y libpcre++-dev zlib1g-dev
pip3 install numpy scipy scikit-learn oct2py flask
```

The demo also contains a docker file to create a docker image to run the demo in a docker container. For details on running the demo in a docker container see [here](docker/).

## Running the demo

To start the demo type the following command:

```bash
make
```

This will decode the example mp3 files to wav. After this feature vectors are computed from the examples and will be organized into a matrix which will be stored in the file `data/data.mat`. In this matrix each row denotes one example and the columns denote the features. Finally, a cross validation is computed for this matrix.

The output of `make` is a list of the classification accuracy of different classifiers with the standard deviation for each classifier's accuracy and their parameter settings.

```
rows = 1587, columns = 333

acc  | std  | clf | parameters
-----+------+-----+----------------------
0.90 | 0.03 | knn | k=5
0.90 | 0.02 | knn | k=9
0.92 | 0.01 | svm | lin C=1
0.73 | 0.02 | svm | poly degree=5
0.95 | 0.01 | svm | rbf, gamma = 1/#rows
```

In this example a SVM classifier with a radial basis function kernel gives the best clasification accuracy of 95% with a standard deviation of 0.03.

## Predict new files

```bash
./predict.sh MODEL INPUTFILE.{MP3,WAV}
```

For example, if you have called `make` you can use the following command to classify 100ms windows ...
```bash
./predict.sh data/data.mat examples/example_male.mp3
```
