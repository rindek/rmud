PROJECT = rindek/rmud
BUILD_TAG = build-local

IMAGE_TAG = $(PROJECT):$(BUILD_TAG)
ENVFILE = "./.env"
VOLUMES = /dummy

export IMAGE_TAG
export ENVFILE
export VOLUMES

revision:
	$(eval GIT_COMMIT = $(shell git rev-parse HEAD))
	echo $(GIT_COMMIT) > REVISION.txt

build-dev: revision
	docker build \
		-f Dockerfile.dev \
		--tag $(IMAGE_TAG) \
		--label "git_commit=$(GIT_COMMIT)" \
		.

build-dev-truffle: revision
	docker build \
		-f Dockerfile.truffle-native \
		--tag $(IMAGE_TAG) \
		--label "git_commit=$(GIT_COMMIT)" \
		.

build-dev-truffle-graalvm: revision
	docker build \
		-f Dockerfile.truffle-graalvm \
		--tag $(IMAGE_TAG) \
		--label "git_commit=$(GIT_COMMIT)" \
		.

dev: build-dev
	@ [ -e .env.development ] || cp -v .env.example .env.development
	VOLUMES=.:/app \
	ENVFILE=./.env.development \
	docker-compose -p rmudev -f docker-compose-dev.yml run --service-ports --rm app 'sh -l'

dev-truffle: build-dev-truffle
	@ [ -e .env.development ] || cp -v .env.example .env.development
	VOLUMES=.:/app \
	ENVFILE=./.env.development \
	docker-compose -p rmudev -f docker-compose-dev.yml run --service-ports --rm app 'bash -l'

dev-truffle-graalvm: build-dev-truffle-graalvm
	@ [ -e .env.development ] || cp -v .env.example .env.development
	VOLUMES=.:/app \
	ENVFILE=./.env.development \
	docker-compose -p rmudev -f docker-compose-dev.yml run --service-ports --rm app 'bash -l'

test:
	STAGE=test bundle exec rspec -f d

run:
	ruby rmud.rb

run-prod:
	ruby --jvm rmud.rb

seed:
	bundle exec rake world:seed
