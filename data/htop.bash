#!/usr/bin/env bash

APPIMAGE_DIR=$(dirname $(realpath $0))
TERMINFO_DIRS=${APPIMAGE_DIR}/usr/share/terminfo${TERMINFO_DIRS:+:$TERMINFO_DIRS} \
LD_LIBRARY_PATH=${APPIMAGE_DIR}/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} \
${APPIMAGE_DIR}/usr/bin/htop $@
