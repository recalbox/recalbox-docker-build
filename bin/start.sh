#!/bin/bash

if [[ "${RECALBOX_AUTO_BUILD}" == "1" ]];then
  echo "Starting recalbox build"
  /usr/local/bin/build-recalbox.sh
fi
