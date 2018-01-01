#!/bin/sh

set -e

if ! [ -d "$1" ]; then
  echo "Expected an existing directory as argument"
  return 1
fi

url=https://github.com/gpakosz/.tmux/archive/master.tar.gz
curl -LsS $url | tar xz -C "$1"
