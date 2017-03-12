This directory contains the files that are required to create a docker image to be able to run the demo for speaker recognition in a docker container.

## Build the docker image

Type `make` in this directory to build the docker image.

This creates a docker image with the tag `talk/1` which contains the user `dev` who will have the user id and group id of the user which is used to execute the make command. This is useful as you can use this user in the docker container to modify and create files in the mounted volume which have the same file permissions used in the guest OS.

## Running the demo in the docker containr

Type `make run` in this directory to start the docker container.

The current working directory of the guest OS is mounted into the directory `/host` in the docker container. In this directory you can now run the demo as described [here](../#running-the-demo). The port 10001 is exposed to the guest OS so that you can use your favorite browser in the guest OS to open the browser demo once it has been started in the docker container. 
