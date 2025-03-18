.SILENT:

IMAGE_NAME := resume_lint
BASE_IMAGE := $(shell cat ./Dockerfile | grep FROM | awk '{ print $$NF }')
YARN_ENTRYPOINT := $(shell docker run --rm --entrypoint /bin/bash -it $(BASE_IMAGE) which yarn)

.PHONY: pdf
pdf: build
	docker run \
	--rm \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/pdf-configs:/work/pdf-configs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it $(IMAGE_NAME) \
	build:pdf

.PHONY: sh
sh: build
	docker run \
	--rm \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	--entrypoint /bin/bash \
	-it $(IMAGE_NAME)

.PHONY: lint
lint: build
	docker run \
	--rm \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it $(IMAGE_NAME)

.PHONY: fix
fix: build
	docker run \
	--rm \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it $(IMAGE_NAME) fix

.PHONY: build
build:
	docker build --quiet -t $(IMAGE_NAME) .

.PHONY: yarn
yarn:
	docker run \
	--rm \
	-v `pwd`/package.json:/packages/package.json \
	-v `pwd`/yarn.lock:/packages/yarn.lock \
	-w /packages \
	--entrypoint $(YARN_ENTRYPOINT) \
	-it $(BASE_IMAGE) \
	install

.PHONY: packages
packages:
	docker run \
	--rm \
	-v `pwd`/package.json:/packages/package.json \
	-v `pwd`/yarn.lock:/packages/yarn.lock \
	-w /packages \
	--entrypoint $(YARN_ENTRYPOINT) \
	-it $(BASE_IMAGE) \
	upgrade-interactive
