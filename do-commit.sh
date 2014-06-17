#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
	printf "Usage $0 <commit type [BUGFIX/FEATURE/CLEANUP]> <commit message >\n"
	exit 1
fi

git commit -m "[$1]: $2"

git format-patch -n --stdout -s --ignore-all-space HEAD^ >> .patches/commits/`git rev-list \
		--max-count=1 --abbrev-commit HEAD^`.patch
