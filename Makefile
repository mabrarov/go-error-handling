GO          ?= go
PREFIX      ?= $(shell pwd)/.build
OUTPUT_NAME ?= go-error-handling

OUTPUT          = $(PREFIX)/$(OUTPUT_NAME)$(shell go env GOEXE)
GO_BUILD_OUTPUT = $(OUTPUT)

ifneq ($(shell uname -s | grep -E '^(MSYS|MINGW).*'),)
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
