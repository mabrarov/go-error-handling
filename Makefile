GO           ?= go
MAKEFILE_DIR := $(abspath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
PREFIX       ?= $(MAKEFILE_DIR)/.build
BINNAME      ?= go-error-handling

# https://tensin.name/blog/makefile-escaping.html
ifeq ($(origin GO),command line)
    override GO := $(value GO)
else
    GO := $(value GO)
endif
ifeq ($(origin PREFIX),command line)
    override PREFIX := $(value PREFIX)
else
    PREFIX := $(value PREFIX)
endif
ifeq ($(origin BINNAME),command line)
    override BINNAME := $(value BINNAME)
else
    BINNAME := $(value BINNAME)
endif

escape        = $(subst ','\'',$(1))

OUTPUT       := $(PREFIX)/$(BINNAME)$(shell '$(call escape,$(GO))' env GOEXE)

.PHONY: all
all: build

.PHONY: build
build:
	CGO_ENABLED=0 '$(call escape,$(GO))' build -C '$(call escape,$(MAKEFILE_DIR))' -trimpath -o '$(call escape,$(OUTPUT))' ./cmd/go-error-handling

.PHONY: run
run:
	CGO_ENABLED=0 '$(call escape,$(GO))' run -C '$(call escape,$(MAKEFILE_DIR))' ./cmd/go-error-handling

.PHONY: clean
clean:
	rm -f '$(call escape,$(OUTPUT))'
