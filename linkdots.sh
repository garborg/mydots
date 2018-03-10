#!/bin/sh

set -e

force=false
if [ "$1" = "-f" ]; then
  force=true
fi

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
        echo "==== Unchanged: $lpath"
        return 0
      elif $force; then
        echo "---- Original removed:"
        ls -ogd "${lpath}"
        rm "${lpath}"
      else
        echo "!!!! Link mismatch:"
        ls -og "$lpath"
        echo "vs."
        echo "=> $tpath"
        return 1
      fi
    else
      mv "$lpath" "$lpath.orig"
      echo ">>>> Original moved to:"
      ls -ogd "${lpath}.orig"
    fi
  fi
  ln -s "$tpath" "$lpath"
  echo "++++ Linked:"
  ls -og "$lpath"
}

linkDir() {
  local tdir="$1"
  local ldir="$2"

  local errs=0
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

      if [ -f "$tpath/._linkcontents" ]; then
        # link contents of dir individually

        # if dir was previously linked as a whole, remove
        if [ -L "$lpath" ]; then
          rm "$lpath"
          echo "---- Directory unlinked '$lpath'"
        fi

        mkdir -p "$lpath"
        linkDir "$tpath" "$lpath"
      else
        # link dir as a whole
        linkPath "$tpath" "$lpath" || errs=1
      fi
    elif [ -f "$tpath" ]; then
      [ "$tbn" = ".DS_Store" ] && continue
      linkPath "$tpath" "$lpath" || errs=1
    else
      echo "xxxx Ignoring '$tpath'"
    fi
  done

  return $errs
}

if [ -d "./dots" ]; then
  linkDir "$(pwd)/dots" "$HOME"
else
  echo "Couldn't find 'dots' dir in '$(pwd)'."
  exit 1
fi
