.PHONY: build
SHELL=/bin/bash
MAIN_BRANCH = main

define check_git_status
	if [[ $$(git status --porcelain 2> /dev/null) != "" ]]; then \
		echo "refusing to proceed, repository contains uncommited changes"; \
		exit 1; \
	fi
endef

define check_version
	if 	! [[ "$$v" =~ ^[0-9]\.[0-9]\.[0-9]$$ ]]; then \
		echo "malformed version"; \
		exit 1; \
	fi
endef

build:
	go build

prepare:
	$(call check_git_status)
	$(call check_version)
	git checkout $(MAIN_BRANCH)
	git pull origin $(MAIN_BRANCH)
	git checkout -b release-$$(echo $$v | sed s/'\.'/-/g)
	git push origin release-$$(echo $$v | sed s/'\.'/-/g)
	git checkout $(MAIN_BRANCH)

release:
	$(call check_git_status)
	$(call check_version)
	git checkout release-$$(echo $$v | sed s/'\.'/-/g)
	git pull origin release-$$(echo $$v | sed s/'\.'/-/g)
	git checkout $(MAIN_BRANCH)
	git merge --ff-only release-$$(echo $$v | sed s/'\.'/-/g)
	git tag $$v
	git push origin $(MAIN_BRANCH)
	git push --tags
