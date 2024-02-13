#!/bin/sh

# fzf
#   homebrew install only replaces the first (git clone) step &
#   conda install is incompatible with customizing install args
fzf_dir="${XDG_CONFIG_HOME:-$HOME/.config}"/fzf
if [ ! -d "$fzf_dir" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_dir"
  # install
  # --xdg: dotfile location respects $XDG_CONFIG
  # --key-bindings, --completion: activate them
  # --no-fish: don't create config dirs for shell I don't use
  # --update-rc: no-op while lines in .rc files are current, keep on in case of changes
  "$fzf_dir"/install --xdg --key-bindings --completion --no-fish --update-rc
fi
