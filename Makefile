.SILENT:

IMAGE_NAME := resume_lint

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

packages:
	docker pull "$(shell cat ./Dockerfile | grep FROM | awk '{ print $$NF }')"
	docker run \
	--rm \
	--platform linux/amd64 \
	-v `pwd`/package.json:/packages/package.json \
	-v `pwd`/yarn.lock:/packages/yarn.lock \
	-w /packages \
	--entrypoint "$(shell docker run --entrypoint /bin/bash -it resume_lint which yarn)" \
	-it "$(shell cat ./Dockerfile | grep FROM | awk '{ print $$NF }')" \
	install
	docker run \
	-v `pwd`/package.json:/packages/package.json \
	-v `pwd`/yarn.lock:/packages/yarn.lock \
	-w /packages \
	--entrypoint "$(shell docker run --entrypoint /bin/bash -it resume_lint which yarn)" \
	-it "$(shell cat ./Dockerfile | grep FROM | awk '{ print $$NF }')" \
	upgrade-interactive
