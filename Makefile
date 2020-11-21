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

dev: build-dev
	@ [ -e .env.development ] || cp -v .env.example .env.development
	VOLUMES=.:/app \
	ENVFILE=./.env.development \
	docker-compose -p rmudev -f docker-compose-dev.yml run --service-ports --rm app 'sh -l'

test:
	STAGE=test bundle exec rake sequel:migrate
	STAGE=test bundle exec rspec -f d
