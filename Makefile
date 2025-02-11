GO              ?= go
PREFIX          ?= $(shell pwd)/.build
BINNAME         ?= go-error-handling

OUTPUT          := $(PREFIX)/$(BINNAME)$(shell go env GOEXE)
GO_BUILD_OUTPUT := $(OUTPUT)

ifeq ($(shell uname -s | grep -c -m 1 -E '^(MSYS|MINGW).*'),1)
GO_BUILD_OUTPUT := $(shell cygpath -w "$(OUTPUT)")
endif

SRC             := $(shell find . -type f -name '*.go' -print) go.mod

.PHONY: all
all: build

.PHONY: build
build: $(OUTPUT)

$(OUTPUT): $(SRC)
	CGO_ENABLED=0 $(GO) build -trimpath -o '$(GO_BUILD_OUTPUT)' ./cmd/go-error-handling

.PHONY: clean
clean:
	rm -f '$(OUTPUT)'
