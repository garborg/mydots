#!/usr/bin/env bash

# Description:
# for dotfile in dots dir
#   check if exists in home
#   if exists
#     echo warning
#   else
#     link to home

linkPath() {
  local tpath="$1"
  local lpath="$2"

  if [ -e "$lpath" ]; then
    if [ -L "$lpath" ]; then
      echo "Exists:"
      ls -o "$lpath"
      return 0
    fi
    mv "$lpath" "${lpath}.orig"
    echo ">>>> Moved:"
    ls -o "${lpath}.orig"
  fi
  echo "++++ Linked:"
  ln -s "$tpath" "$lpath"
  ls -o "$lpath"
}

linkDir() {
  local tdir="$1"
  local ldir="$2"

  for tpath in $tdir/{.,}*; do
    local tbn="$(basename "$tpath")"
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
fi
