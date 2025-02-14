# https://clarkgrubb.com/makefile-style-guide
MAKEFLAGS     += --warn-undefined-variables
SHELL         := bash
.SHELLFLAGS   := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

GO           ?= go
MAKEFILE_DIR := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
PREFIX       ?= $(MAKEFILE_DIR)/.build
BINNAME      ?= go-error-handling

OUTPUT       := $(PREFIX)/$(BINNAME)$(shell '$(GO)' env GOEXE)

.PHONY: all
all: build

.PHONY: build
build:
	CGO_ENABLED=0 '$(GO)' build -C '$(MAKEFILE_DIR)' -trimpath -o '$(OUTPUT)' ./cmd/go-error-handling

.PHONY: run
run:
	CGO_ENABLED=0 '$(GO)' run -C '$(MAKEFILE_DIR)' ./cmd/go-error-handling

.PHONY: clean
clean:
	rm -f '$(OUTPUT)'
