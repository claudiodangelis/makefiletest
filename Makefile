.PHONY: build
SHELL=/bin/bash
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
	git checkout master
	git pull origin master
	git checkout -b release-$$(echo $$v | sed s/'\.'/-/g)
	git push origin release-$$(echo $$v | sed s/'\.'/-/g)
	git checkout master

release:
	$(call check_git_status)
	$(call check_version)
	git checkout release-$$(echo $$v | sed s/'\.'/-/g)
	git pull origin release-$$(echo $$v | sed s/'\.'/-/g)
	git checkout master
	git merge --ff-only release-$$(echo $$v | sed s/'\.'/-/g)
	git tag $$v
	git push origin master
	git push --tags
