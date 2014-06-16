#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	printf "Usage $0 <tag version> <tag message> <commit message>\n \
	Should only be used in dev branch\n"
	exit 1
fi

git commit -am "$1 - $3"
git tag -a $1 -m "$2"

git diff -p master dev >> .patches/dev/master-dev.patch
git diff -p master $1 >> .patches/tags/master-$1.patch
git format-patch -n --stdout -s --ignore-all-space HEAD^ >> .patches/commits/`git rev-list \
	--max-count=1 --abbrev-commit HEAD^`.patch
