#!/usr/bin/env bash

if [[ "$#" -ne 3 ]]; then
  echo "Usage: $0 <package> <version> <build_dir>"
  exit 1
fi
# Patch packages for specific versions

scripts_dir="$(dirname $(realpath $0))"
package="$1"
version="$2"
build_dir="$3"

if [[ "$package" == "htop" ]]; then
  target="3.4.0"
  # patch version string if version >= 3.4.0 (target)
  if [ "$(printf '%s\n%s' "$target" "$version" | sort -V | head -n1)" = "$target" ]; then
    sed -i 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\)-dev/\1/g' configure.ac
  fi
fi

if [[ "$package" == "htop" ]] && [[ "$version" == "3.4.0" ]] ; then
  patch -p1 -i $scripts_dir/patch/htop-3.4.0.patch
fi
