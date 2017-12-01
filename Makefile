all: deps build

deps-go:
	go run build.go setup

deps-js:
	yarn install --pure-lockfile --no-progress

deps: deps-js

build-go:
	go run build.go build

build-js:
	npm run build

build: build-go build-js

test-go:
	go test -v ./pkg/...

test-js:
	npm test

test: test-go test-js

run:
	./bin/grafana-server

kausal-backend:
	docker run -ti --rm \
	  -v $$GOPATH/src/github.com/grafana/grafana:/go/src/github.com/grafana/grafana \
	  golang:1.9.2 /bin/sh -c "cd /go/src/github.com/grafana/grafana; go run build.go setup && go run build.go build"

kausal-frontend:
	docker run -t --rm \
		-v $$GOPATH/src/github.com/grafana/grafana:/go/src/github.com/grafana/grafana \
		node:6.12-alpine /bin/sh -c "cd /go/src/github.com/grafana/grafana; apk add --update git && npm install -g yarn && yarn install --pure-lockfile && npm run build"

kausal-image:
	docker build -t kausal/grafana:$(shell git rev-parse --abbrev-ref HEAD)-$(shell git rev-parse --short HEAD) .
