.PHONY: build
SHELL=/bin/bash
define check_git_status
	if [[ $$(git status --porcelain 2> /dev/null) != "" ]]; then \
		echo refusing to proceed, repository contains uncommited changes; \
		exit 1; \
	fi
endef

build:
	go build


prepare:
	$(call check_git_status)