#!/bin/sh

set -e

. ./setup-base.sh
./install-brew.sh

git config credential.helper osxkeychain
