GO              ?= go
MAKEFILE_DIR    := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
PREFIX          ?= $(MAKEFILE_DIR)/.build
BINNAME         ?= go-error-handling

OUTPUT          := $(PREFIX)/$(BINNAME)$(shell '$(GO)' env GOEXE)
GO_BUILD_OUTPUT := $(OUTPUT)

ifeq ($(shell uname -s | grep -c -m 1 -E '^(MSYS|MINGW).*'),1)
GO_BUILD_OUTPUT := $(shell cygpath -w '$(OUTPUT)')
endif

.PHONY: all
all: build

.PHONY: build
build:
	CGO_ENABLED=0 '$(GO)' -C '$(MAKEFILE_DIR)' build -trimpath -o '$(GO_BUILD_OUTPUT)' ./cmd/go-error-handling

.PHONY: clean
clean:
	rm -f '$(OUTPUT)'
