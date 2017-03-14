G  = $(shell id -g $(USER))
U  = $(shell id -u $(USER))
T := $(shell mktemp -d)

NOCACHE ?= false

all:
	@echo using uid $(U) and gid $(G)
	@cat Dockerfile.template | sed -e "s/:GID:/$(G)/g" | sed -e "s/:UID:/$(U)/g" > $(T)/Dockerfile
	docker build --no-cache=$(NOCACHE) -t talk/1 -f $(T)/Dockerfile $(T)
	@rm -rf $(T)

run:
	@docker run -t -i --rm -e DISPLAY=$(DISPLAY) -p 10001:10001 -p 5001:5001 --device=/dev/snd:/dev/snd -v /tmp/.X11-unix:/tmp/.X11-unix -v $(PWD)/../:/host talk/1
