C0 ?= audio_examples/example_male.mp3
C1 ?= audio_examples/example_female.mp3

all: data/data.mat
	@./cv.py data/data.mat

# TODO if C0 is older than the model it is not re-created
# TODO maybe replace this by a script
data/class0.wav: $(C0)
	@echo "Decoding $< ..."
	@mkdir -p data
	@sox -q $< -r 44100 -b 16 -c 1 -e signed-integer --endian little -t wav $@

data/class1.wav: $(C1)
	@echo "Decoding $< ..."
	@mkdir -p data
	@sox -q $< -r 44100 -b 16 -c 1 -e signed-integer --endian little -t wav $@

data/data.mat: $(wildcard *.m) data/class0.wav data/class1.wav
	@echo "Building model ..."
	@octave -p octave/ --no-gui ml.m data/class0.wav data/class1.wav data/data.mat

clean:
	rm -rf data live/__pycache__

predict_example:
	@./predict.sh data/data.mat examples/example_male.mp3


# install nginx + html files

HTMLDEP   = $(wildcard html/*.html html/*.js html/*.css)
NGINXDST  = /opt/nginx-voice
NGINXTMP := $(shell mktemp -d)

$(NGINXDST): extra/nginx.conf
	rm -rf $(NGINXDST)
	tar xzf extra/nginx-1.10.3.tar.gz -C $(NGINXTMP)
	cd $(NGINXTMP)/nginx-1.10.3 && ./configure --prefix=$(NGINXDST) && make -j4 && make install
	rm -rf $(NGINXTMP)
	cp extra/nginx.conf $(NGINXDST)/conf/

$(NGINXDST)/conf/nginx.conf: extra/nginx.conf
	cp extra/nginx.conf $(NGINXDST)/conf/

html: $(NGINXDST) $(NGINXDST)/conf/nginx.conf $(HTMLDEP)
	@rm -rf $(NGINXDST)/html-voice/
	@mkdir -p $(NGINXDST)/html-voice
	cp html/* $(NGINXDST)/html-voice/

html-run: html
	/opt/nginx-voice/sbin/nginx

copy-images:
	# todo: convert other formats to jpg
	cp $(I0) $(NGINXDST)/html-voice/class0.jpg
	cp $(I1) $(NGINXDST)/html-voice/class1.jpg

html-clean:
	rm -rf $(NGINXDST)
