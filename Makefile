.SILENT:

IMAGE_NAME := resume_lint
BASE_IMAGE := $(shell cat ./Dockerfile | grep FROM | awk '{ print $$NF }')
YARN_ENTRYPOINT := $(shell docker run --rm --platform linux/amd64 --entrypoint /bin/bash -it $(BASE_IMAGE) which yarn)

build:
	docker build --platform linux/amd64 --quiet -t $(IMAGE_NAME) .

sh: build
	docker run \
	--rm \
	--platform linux/amd64 \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	--entrypoint /bin/bash \
	-it $(IMAGE_NAME)

lint: build
	docker run \
	--rm \
	--platform linux/amd64 \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it $(IMAGE_NAME)

fix: build
	docker run \
	--rm \
	--platform linux/amd64 \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it $(IMAGE_NAME) fix

.PHONY: packages
packages:
	docker run \
	--rm \
	--platform linux/amd64 \
	-v `pwd`/package.json:/packages/package.json \
	-v `pwd`/yarn.lock:/packages/yarn.lock \
	-w /packages \
	--entrypoint $(YARN_ENTRYPOINT) \
	-it $(BASE_IMAGE) \
	upgrade-interactive
