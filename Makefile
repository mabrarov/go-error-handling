GO          ?= go
PREFIX      ?= $(shell pwd)/.build
OUTPUT_NAME ?= go-error-handling

ifeq ($(OS),Windows_NT)
OUTPUT          = $(PREFIX)/$(OUTPUT_NAME).exe
ifneq ($(shell uname -s | grep -E '^(MSYS|MINGW).*'),)
GO_BUILD_OUTPUT = $(shell cygpath -w "$(OUTPUT)")
else
GO_BUILD_OUTPUT = $(OUTPUT)
endif
else
OUTPUT          = $(PREFIX)/$(OUTPUT_NAME)
GO_BUILD_OUTPUT = $(OUTPUT)
endif

.PHONY: all
all: build

.PHONY: build
build:
	$(GO) build -C cmd/go-error-handling -o "$(GO_BUILD_OUTPUT)"

.PHONY: clean
clean:
	rm -f "$(OUTPUT)"
