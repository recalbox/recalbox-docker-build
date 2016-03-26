#!/bin/bash
if [[ -z "${RECALBOX_BRANCH}" ]];then
  RECALBOX_BRANCH="master"
fi
if [[ -z "${RECALBOX_ARCH}" ]];then
  RECALBOX_ARCH="rpi2"
fi
if [[ -z "${RECALBOX_CLEANBUILD}" ]];then
  RECALBOX_CLEANBUILD="1"
fi

build=/usr/share/recalbox/build
branch="${RECALBOX_BRANCH}"
arch="${RECALBOX_ARCH}"
builddir="${build}/${branch}/${arch}"
cleanbuild="${RECALBOX_CLEANBUILD}"

# Cleanning
if [[ "${cleanbuild}" == "1" ]];then
  echo "Cleaning last build"
  make clean
else
  echo "Soft clean recalbox packages"
  rm dl/recalbox-*
  rm output/build/recalbox-*
fi

# Cloning
if [[ ! -f "${builddir}" ]]; then
  mkdir -p "${builddir}"
  echo "Cloning recalbox in ${builddir}"
  git clone https://github.com/recalbox/recalbox-buildroot.git "${builddir}"
fi

# Branch selection
cd "${builddir}"
echo "Switching to branch $branch"
git checkout $branch
git pull origin $branch

# Building
echo "BUild recalbox for arch ${arch} (defconfig : recalbox-${arch}_defconfig)"
make recalbox-${arch}_defconfig
make

