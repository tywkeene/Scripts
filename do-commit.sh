#!/bin/bash

if [ -z "$1" ]; then
	printf "Usage $0 <commit message>\n"
	exit 1
fi

git commit -am $1

git format-patch -n --stdout -s --ignore-all-space HEAD^ >> .patches/commits/`git rev-list \
		--max-count=1 --abbrev-commit HEAD^`.patch
