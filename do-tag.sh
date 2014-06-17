#!/bin/bash

yn () {
	while true; do
		read -p "$1 " yn
		case $yn in
			[Yy]* ) return 0;;
		[Nn]* ) return 1;;
	* ) echo "Please answer yes or no.";;
esac
    done
}

if [ ! -f .patch_settings ]; then
	printf "Couldn't find settings files, exiting\n"
	exit -1
fi

source .patch_settings

if [ -z "$1" ] || [ -z "$2" ]; then
	printf "Usage $0 <tag version> <tag message>\n \
		Should only be used in dev branch\n"
	exit 1
fi

printf "Creating tag $1 with message \"$2\"\n"
git tag -a $1 -m "$2"

if yn "Push new tag?"; then
	git push --tags
fi

if [ $patch_dev == 1 ]; then
	printf "Generating by-branch patch\n"
	if [ $review_patches == 1 ]; then
		git diff -p master dev | less
		if yn "Generate this patch?"; then
			git diff -p master dev > $patch_dir/dev/master-dev.patch
		fi
	else
		git diff -p master dev > $patch_dir/dev/master-dev.patch
	fi
fi

if [ $patch_tags == 1 ]; then
	printf "Generating by-tag patch\n"
	if [ $review_patches == 1 ]; then
		git diff -p master $1 | less
		if yn "Generate this patch?"; then
			git diff -p master $1 > $patch_dir/tags/master-$1.patch
		fi
	else
		git diff -p master $1 > $patch_dir/tags/master-$1.patch
	fi
fi
