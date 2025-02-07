GO     ?= go
PREFIX ?= $(shell pwd)/.build

.PHONY: all
all: build

.PHONY: build
build:
	$(GO) build -C cmd/go-error-handling -o $(PREFIX)/
