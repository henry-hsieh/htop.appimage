#!/usr/bin/env bash

file_name=""
dir_name=""
if [[ $# -eq 2 ]]; then
  file_name="$(basename $2)"
  dir_name="$(dirname $2)"
elif [[ $# -eq 1 ]]; then
  file_name="$(basename $1)"
  dir_name="."
else
  echo "Usage: $0 url [output_file]"
  exit 1
fi

if [[ ! -e "$file_name" ]]; then
  mkdir -p $dir_name
  pushd $dir_name
  if [[ -f "$file_name" ]]; then
    curl -L "$1" -z "$file_name" -o "$file_name"
  else
    curl -L "$1" -o "$file_name"
  fi
  if [[ 0 -ne $? ]]; then
    echo "Download \"$file_name\" failed"
    exit 2
  fi
  popd
fi
