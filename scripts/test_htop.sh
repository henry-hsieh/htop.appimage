#!/usr/bin/env bash

htop=""
version=""
if [[ $# -eq 2 ]]; then
  htop="$(realpath $1)"
  version="$2"
else
  echo "Usage: $0 /path/to/htop.appimage version"
  exit 1
fi

if ! $($htop --appimage-help >/dev/null 2>&1); then
  echo "$htop is not an AppImage"
  exit 2
fi

appimage_version=$($htop --version)
fail=$?

if [ $fail -ne 0 ]; then
  cd $(dirname "$htop")
  ./$(basename $htop) --appimage-extract
  appimage_version=$(./squashfs-root/AppRun --version)
fi

if [[ "$appimage_version" != "htop $version" ]]; then
  echo "$htop has version info: $appimage_version, expected: htop $version"
  exit 3
fi
