#!/bin/sh

set -e

if ! [ -d "$1" ]; then
  echo "Expected an existing directory as argument"
  return 1
fi

. "$(dirname "$0")/../util.sh"

url=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

fetch "$url" "$1"
