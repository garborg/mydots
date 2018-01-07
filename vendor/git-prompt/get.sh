#!/bin/sh

set -e

if ! [ -d "$1" ]; then
  echo "Expected an existing directory as argument"
  return 1
fi

. "$(dirname "$0")/../util.sh"

url=https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
fetch "$url" "$1"
