#!/bin/sh

set -e

# Description:
# for dotfile in dots dir
#   check if exists in home
#   if exists
#     if different
#       if symlink
#         warn & skip to next dotfile
#       else
#         move original and link to home
#   else
#     link to home

# symlink, move orig file out of way, but err if mismatching link is found
linkPath() {
  local tpath="$1"
  local lpath="$2"

  if [ -e "$lpath" ] || [ -L "$lpath" ]; then
    if [ -L "$lpath" ]; then
      local ltarget
      # TODO: ensure works on osx (inluding w/ broken links)
      ltarget="$(readlink "$lpath")"
      if [ "$ltarget" = "$tpath" ]; then
        echo "==== Unchanged: ${lpath}"
        return 0
      else
        echo "!!!! Link mismatch:"
        ls -og "${lpath}"
        return 1
      fi
    else
      mv "$lpath" "$lpath.orig"
      echo ">>>> Original moved:"
      ls -og "${lpath}.orig"
    fi
  fi
  ln -s "$tpath" "$lpath"
  echo "++++ Linked:"
  ls -og "$lpath"
}

linkDir() {
  local tdir="$1"
  local ldir="$2"

  for tpath in $tdir/* $tdir/.[^.]*; do
    # globs are returned when they match nothing
    [ -e "$tpath" ] || continue

    local tbn
    tbn="$(basename "$tpath")"
    local lpath="$ldir/$tbn"
    if [ "$tbn" = "." ] || [ "$tbn" = ".." ] || [ "$tbn" = "*" ]; then
      continue
    fi
    if [ -d "$tpath" ]; then
      # TODO: iff under $HOME
      if [ "$tbn" = ".config" ] && [ -n "$XDG_CONFIG_HOME" ]; then
        echo "Installing config under \$XDG_CONFIG_HOME: '$XDG_CONFIG_HOME'"
        local lpath="$XDG_CONFIG_HOME"
      fi

      mkdir -p "$lpath"
      linkDir "$tpath" "$lpath"
    elif [ -f "$tpath" ]; then
      [ "$tbn" = ".DS_Store" ] && continue
      linkPath "$tpath" "$lpath"
    else
      echo "---- Ignoring '$tpath'"
    fi
  done
}

if [ -d "./dots" ]; then
  linkDir "$(pwd)/dots" "$HOME"
else
  echo "Couldn't find 'dots' dir in '$(pwd)'."
  exit 1
fi
