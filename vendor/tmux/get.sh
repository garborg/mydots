#!/bin/sh

set -e

if ! [ -d "$1" ]; then
  echo "Expected an existing directory as argument"
  return 1
fi

. "$(dirname "$0")/../util.sh"

url=https://github.com/gpakosz/.tmux/archive/master.tar.gz
fetch "$url" "$1"
