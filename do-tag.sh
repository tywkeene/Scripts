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

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
	printf "Usage $0 <tag version> <tag message>\n \
		Should only be used in dev branch\n"
	exit 1
fi

git tag -a $1 -m "$2"

if yn "Push new tag?"
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

if [ $patch_commits == 1 ]; then
	printf "Generating by-commit patch\n"
	if [ $review_patches == 1 ]; then
		git format-patch -n --stdout -s --ignore-all-space HEAD^ | less
		if yn "Generate this patch?"; then
			git format-patch -n --stdout -s --ignore-all-space HEAD^ >> $patch_dir/commits/`git rev-list \
				--max-count=1 --abbrev-commit HEAD^`.patch
		fi
	else
		git format-patch -n --stdout -s --ignore-all-space HEAD^ >> $patch_dir/commits/`git rev-list \
			--max-count=1 --abbrev-commit HEAD^`.patch
	fi
fi
