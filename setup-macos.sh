#!/bin/sh

set -e

. ./setup-base.sh

./install-brew.sh
./install-source.sh
./install-omz.sh

git config credential.helper osxkeychain
