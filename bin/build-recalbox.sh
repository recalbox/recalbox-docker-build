#!/bin/bash -e

if [[ -z "${RECALBOX_FORK}" ]];then
  RECALBOX_FORK="recalbox"
fi
if [[ -z "${RECALBOX_BRANCH}" ]];then
  RECALBOX_BRANCH="rb-4.1.X"
fi
if [[ -z "${RECALBOX_ARCH}" ]];then
  RECALBOX_ARCH="rpi3"
fi
if [[ -z "${RECALBOX_VERSION_LABEL}" ]];then
  RECALBOX_VERSION_LABEL="${RECALBOX_BRANCH}-${RECALBOX_ARCH}-`date +%Y-%m-%d-%Hh%M`"
fi
if [[ "$RECALBOX_DL_PARENT_FOLDER" == "1" ]] || [[ "$RECALBOX_DL_PARENT_FOLDER" == "true" ]]
  topdownload="1"
  downloaddir="../dl"
else
  topdownload="0"
  downloaddir="dl"
fi
if [[ "$RECALBOX_HOST_PARENT_FOLDER" == "1" ]] || [[ "$RECALBOX_HOST_PARENT_FOLDER" == "true" ]]
  tophost="1"
else
  tophost="0"
fi
if [[ "$RECALBOX_CLEANBUILD" == "1" ]] || [[ "$RECALBOX_CLEANBUILD" == "true" ]]
  cleanbuild="1"
else
  cleanbuild="0"
fi
if [[ "$RECALBOX_GIT_RESET" == "1" ]] || [[ "$RECALBOX_GIT_RESET" == "true" ]]
  hardreset="1"
else
  hardreset="0"
fi

build=/usr/share/recalbox/build
branch="${RECALBOX_BRANCH}"
arch="${RECALBOX_ARCH}"
builddir="${build}/${branch}/${arch}"

# Cleanning
if [[ "${cleanbuild}" == "1" ]];then
  echo "Cleaning last build"
  make clean || true
else
  echo "Soft clean recalbox packages"
  rm $downloaddir/recalbox-* || true
  rm output/build/recalbox-* || true
fi

# Cloning
if [[ ! -d "${builddir}" ]]; then
  mkdir -p "${builddir}"
  echo "Cloning recalbox in ${builddir}"
  git clone https://github.com/${RECALBOX_FORK}/recalbox-buildroot.git "${builddir}"
fi

# Branch selection
cd "${builddir}"
echo "Switching to branch $branch"
if [[ "$hardreset" == "1" ]];then
  git reset --hard HEAD
fi
git checkout $branch
git pull --rebase origin $branch

# Configuring
echo "Configuring recalbox for arch ${arch} (defconfig : recalbox-${arch}_defconfig)"
make recalbox-${arch}_defconfig

# Changing dl and host directories
if [[ "$topdownload" == "1" ]];then
  sed -i "s|BR2_DL_DIR=\"\$(TOPDIR)/dl\"|BR2_DL_DIR=\"\$(TOPDIR)/../dl\"|g" .config
fi
if [[ "$tophost" == "1" ]];then
  sed -i "s|BR2_HOST_DIR=\"\$(BASE_DIR)/host\"|BR2_HOST_DIR=\"\$(TOPDIR)/../host-${arch}\"|g" .config
fi

# Version
echo "${RECALBOX_VERSION_LABEL}" > board/recalbox/fsoverlay/recalbox/recalbox.version

# Update message
echo "${RECALBOX_UPDATE_MESSAGE}" > board/recalbox/fsoverlay/recalbox/recalbox.msg

#Building
if [[ -z "${RECALBOX_SINGLE_PKG}" ]];then
  echo "Building recalbox for arch ${arch}"
  make 
else
   echo "Only build package ${RECALBOX_SINGLE_PKG} for arch ${arch}" 
   make "${RECALBOX_SINGLE_PKG}"
fi
