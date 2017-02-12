#!/usr/bin/env bash

# for dotfile in dots dir
#   check if exists in home
#   if exists
#     echo warning
#   else
#     link


if [ -d "./dots" ]; then
  mydir=$(pwd)
  shopt -s dotglob # * match .fn, but not . or ..
  for rel_path in dots/*; do
    lp="$HOME/$(basename $rel_path)"
    if [ -e "$lp" ]; then
      echo "'$lp' already exists." 
    else
      echo "linking '$lp' to '$mydir/$rel_path'"
      ln -s "$mydir/$rel_path" "$lp"
    fi
  done
else
  echo "Couldn't find 'dots' dir in '$mydir'."
fi

