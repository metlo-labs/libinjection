
SUBDIRS=src

all:  ## build c library
	(cd src; ${MAKE} all)
check:  ## run tests
	(cd src; ${MAKE} check)
clean:  ## clean up
	@(cd src; ${MAKE} clean)
	git gc --aggressive

.PHONY: all check clean

docker-console:  ## log into the docker test image
	docker run --rm -it \
		-e COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN \
		-v $(PWD):/build \
		-w /build \
		nickg/libinjection-docker \
		sh

docker-ci:   ## run the tests in docker, as travis-ci does
	docker run --rm \
		-e COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN \
		-v $(PWD):/build \
		-w /build \
		nickg/libinjection-docker \
		./make-ci.sh

build-metlo-scripts:
	mkdir -p build
	gcc -o build/metlo-injection-test -std=c99 -Wall -Wextra src/test_xss_sqli.c src/libinjection_sqli.c src/libinjection_xss.c src/libinjection_html5.c

# https://www.client9.com/self-documenting-makefiles/
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
.DEFAULT_GOAL := help

