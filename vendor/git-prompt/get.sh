#!/bin/sh

set -e

if ! [ -d "$1" ]; then
  echo "Expected an existing directory as argument"
  return 1
fi

url=https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
curl -LsSo "$1/git-prompt.sh" $url
