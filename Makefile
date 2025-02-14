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
