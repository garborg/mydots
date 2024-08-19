#!/bin/sh

set -e

. ./setup-base.sh

./install-brew.sh
./install-source.sh
./install-omz.sh

git config --global credential.helper osxkeychain

# Configure delta diff viewer diff pager installed by brew
git config --global delta.syntax-theme zenburn
git config --global delta.navigate true
git config --global pager.diff delta
git config --global pager.log delta
git config --global pager.reflog delta
git config --global pager.show delta
git config --global interactive.diffFilter "delta --color-only"

# apps:
# chrome, firefox, notion, etc.
# Code:
# - from: https://code.visualstudio.com/download
# - extensions: Julia, Python, Vim, etc.
