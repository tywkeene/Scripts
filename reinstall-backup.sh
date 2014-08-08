#!/bin/bash

mkdir -p backup/{root,portage,portage/sets,configs,}

cp -r /root/.vim backup/root/vim
cp -r /root/.vimrc backup/root/vimrc

cp /etc/X11/xorg.conf backup/configs/

cp /etc/portage/make.conf backup/portage/
cp /etc/portage/package.use backup/portage/
cp /etc/portage/sets/* backup/portage/sets/
cp /var/lib/portage/world backup/portage/sets/

tar -czf backup.tar.gz backup/

rm -rf backup/
