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
