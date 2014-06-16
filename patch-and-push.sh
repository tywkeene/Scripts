#!/bin/bash

promptyn () {
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	printf "Usage $0 <tag version> <tag message> <commit message>\n \
	Should only be used in dev branch\n"
	exit 1
fi

if [ ! -f ".patches" ]; then
	mkdir .patches/
	mkdir .patches/dev
	mkdir .patches/tags
fi

git commit -am "$1 - $3"
git tag -a $1 -m "$2"

git diff master dev | less
if promptyn "Generate this patch? "; then
	git diff -p master dev >> .patches/dev/master-dev.patch
fi

git diff master $1 | less
if promptyn "Generate this patch?"; then
	git diff -p master $1 >> .patches/tags/master-$1.patch
fi
