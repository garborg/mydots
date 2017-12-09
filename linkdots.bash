#!/usr/bin/env bash

# Description:
# for dotfile in dots dir
#   check if exists in home
#   if exists
#     echo warning
#   else
#     link

linkIf() {
  tp="$1"
  lp="$2"
  if [ -e "$lp" ]; then
    if [ -L "$lp" ]; then
      echo "Link exists:"
      ls -o "$lp"
      return 0
    fi
    mv "$lp" "${lp}.orig"
    echo "Moved:"
    ls -o "${lp}.orig"
  fi
  echo "Linked:"
  ln -s "$tp" "$lp"
  ls -o "$lp"
}

if [ -d "./dots" ]; then
  mydir=$(pwd)
  shopt -s dotglob # * match .fn, but not . or ..
  for rel_path in dots/*; do
    # i have commented '._* junk in there right now
    if [[ $rel_path != "dots/._"* ]] && [[ "$rel_path" != "dots/.DS_Store" ]]; then
      lp="$HOME/$(basename "$rel_path")"
      tp="$mydir/$rel_path"
      linkIf "$tp" "$lp"

      # Special cases

      # # link to .profile to ~/.bash_profile as well.
      # #   don't lose .profile when osx or a tool creates .bash_profile unasked
      # #   one less file check for bash on unix
      # if [ "$rel_path" = "dots/.profile" ]; then
      #   lp="$HOME/.bash_profile"
      #   if [ -e "$lp" ]; then
      #     echo "'$lp' already exists."
      #   else
      #     echo "linking '$lp' to '$mydir/$rel_path'"
      #     ln -s "$mydir/$rel_path" "$lp"
      #   fi

      # make vimrc available to neovim
      if [ "$rel_path" = "dots/.vimrc" ]; then
        nvdir="$HOME/.config/nvim"
        lp="$nvdir/init.vim"
        mkdir -p "$nvdir"
        linkIf "$tp" "$lp"
      fi
    fi
  done
else
  echo "Couldn't find 'dots' dir in '$mydir'."
fi

