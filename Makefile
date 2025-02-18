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

# https://tensin.name/blog/makefile-escaping.html
define noexpand
    ifeq ($$(origin $(1)),environment)
        $(1) := $$(value $(1))
    else ifeq ($$(origin $(1)),environment override)
        $(1) := $$(value $(1))
    else ifeq ($$(origin $(1)),command line)
        override $(1) := $$(value $(1))
    endif
endef

$(eval $(call noexpand,GO))
$(eval $(call noexpand,PREFIX))
$(eval $(call noexpand,BINNAME))

escape        = $(subst ','\'',$(1))
squote        = '$(call escape,$(1))'

OUTPUT       := $(PREFIX)/$(BINNAME)$(shell $(call squote,$(GO)) env GOEXE)

.PHONY: all
all: build

.PHONY: build
build:
	CGO_ENABLED=0 $(call squote,$(GO)) build -C $(call squote,$(MAKEFILE_DIR)) -trimpath -o $(call squote,$(OUTPUT)) ./cmd/go-error-handling

.PHONY: run
run:
	CGO_ENABLED=0 $(call squote,$(GO)) run -C $(call squote,$(MAKEFILE_DIR)) ./cmd/go-error-handling

.PHONY: clean
clean:
	rm -f $(call squote,$(OUTPUT))
