GO          ?= go
PREFIX      ?= $(shell pwd)/.build
OUTPUT_NAME ?= go-error-handling

OUTPUT          = $(PREFIX)/$(OUTPUT_NAME)$(shell go env GOEXE)
GO_BUILD_OUTPUT = $(OUTPUT)

ifeq ($(shell uname -s | grep -c -m 1 -E '^(MSYS|MINGW).*'),1)
GO_BUILD_OUTPUT = $(shell cygpath -w "$(OUTPUT)")
endif

.PHONY: all
all: build

.PHONY: build
build:
	$(GO) build -C cmd/go-error-handling -o "$(GO_BUILD_OUTPUT)"

.PHONY: clean
clean:
	rm -f "$(OUTPUT)"
