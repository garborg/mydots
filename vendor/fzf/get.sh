#!/bin/sh

set -e

if ! [ -d "$1" ]; then
  echo "Expected an existing directory as argument"
  return 1
fi

# url=https://github.com/junegunn/fzf.git
# git clone --depth 1 $url "$1/fzf"

url=https://github.com/junegunn/fzf/archive/master.tar.gz
curl -LsS $url | tar xz -C "$1"
