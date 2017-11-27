IMAGE_REPO ?= quay.io/charter-ctec/charter-ui
IMAGE_TAG ?= v1.0.0 

ifeq "$(VERSION)" ""
	override VERSION = dev
endif

install:
	yarn install

test:
	yarn test

test-ci:
	yarn run test-ci

compile:
	yarn run compile

compile-aot:
	yarn run compile-aot

docker-build: compile-aot
	sudo docker build --pull --rm -t ${IMAGE_REPO}:${IMAGE_TAG} rootfs/

set-version:
	sed -i src/version.ts -e 's/dev/${VERSION}/'
