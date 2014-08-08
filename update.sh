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

sets=("@admin" "@user" "@programming" "@display" "@world")

if [ $EUID -ne 0 ];then
	printf "Can't run as non-root user, try again..\n"
	exit -1
fi

if yn "Sync portage?"; then
	emerge --sync
fi

for i in "${sets[@]}"; do
	if yn "update $i?"; then
		emerge -av --update --deep --newuse $i
	fi
done

if yn "Build packages?";
then
	for i in "${sets[@]}"; do
		if yn "Build packages in $i set?"; then
			quickpkg --include-config=y $i
		fi
	done
fi
