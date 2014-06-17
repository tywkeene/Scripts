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
	printf "Usage $0 <commit type [BUGFIX/FEATURE/CLEANUP]> <commit message >\n"
	exit 1
fi

git commit -m "[$1]: $2"

if [ $patch_commits == 1 ]; then
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
