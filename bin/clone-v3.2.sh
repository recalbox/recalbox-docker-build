#!/bin/bash
branch='recalbox-rpi2'
git clone https://github.com/recalbox/recalbox-buildroot.git $REPO/$branch
ls $RECALBOXDIR
cd $REPO/${branch}
git checkout $branch
git pull origin $branch
make ${branch}_defconfig
