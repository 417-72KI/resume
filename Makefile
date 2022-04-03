build:
	@docker build --quiet -t resume_lint .

sh: build
	@docker run \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	--entrypoint /bin/bash \
	-it resume_lint

lint: build
	@docker run \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it resume_lint

fix: build
	@docker run \
	-v `pwd`/docs:/work/docs \
	-v `pwd`/.textlintrc:/work/.textlintrc \
	-it resume_lint fix

upgrade-packages:
	@docker run \
	-v `pwd`/package.json:/packages/package.json \
	-v `pwd`/yarn.lock:/packages/yarn.lock \
	-w /packages \
	--entrypoint "$(shell docker run --entrypoint /bin/bash -it resume_lint which yarn)" \
	-it "$(shell cat ./Dockerfile | grep FROM | awk '{ print $$NF }')" \
	upgrade-interactive
