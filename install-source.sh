#!/bin/sh

# asdf (homebrew install is problematic: https://github.com/asdf-vm/asdf/issues/785)
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  cd ~/.asdf && git checkout "$(git describe --abbrev=0 --tags)"
  asdf plugin-add nodejs
  asdf plugin-add julia
fi
