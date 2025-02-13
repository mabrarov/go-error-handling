GO              ?= go
MAKEFILE_DIR    := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
PREFIX          ?= $(MAKEFILE_DIR)/.build
BINNAME         ?= go-error-handling

# https://tensin.name/blog/makefile-escaping.html
ifeq ($(origin GO),environment)
    GO := $(value GO)
else ifeq ($(origin GO),environment override)
    GO := $(value GO)
else ifeq ($(origin GO),command line)
    override GO := $(value GO)
endif

ifeq ($(origin PREFIX),environment)
    PREFIX := $(value PREFIX)
else ifeq ($(origin PREFIX),environment override)
    PREFIX := $(value PREFIX)
else ifeq ($(origin PREFIX),command line)
    override PREFIX := $(value PREFIX)
endif

ifeq ($(origin BINNAME),environment)
    BINNAME := $(value BINNAME)
else ifeq ($(origin BINNAME),environment override)
    BINNAME := $(value BINNAME)
else ifeq ($(origin BINNAME),command line)
    override BINNAME := $(value BINNAME)
endif

escape           = $(subst ','\'',$(1))

OUTPUT          := $(PREFIX)/$(BINNAME)$(shell '$(call escape,$(GO))' env GOEXE)
GO_BUILD_OUTPUT := $(OUTPUT)

ifeq ($(shell uname -s | grep -c -m 1 -E '^(MSYS|MINGW).*'),1)
GO_BUILD_OUTPUT := $(shell cygpath -w '$(call escape,$(OUTPUT))')
endif

.PHONY: all
all: build

.PHONY: build
build:
	CGO_ENABLED=0 '$(call escape,$(GO))' build -trimpath -o '$(call escape,$(GO_BUILD_OUTPUT))' ./cmd/go-error-handling

.PHONY: clean
clean:
	rm -f '$(call escape,$(OUTPUT))'
