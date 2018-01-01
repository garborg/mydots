#!/bin/sh

set -e

review_latest() {
  if ! [ -d "$1/reviewed/" ]; then
    echo "Can't find directory '$1/reviewed/'"
    return 1
  fi
  if ! [ -d "$1/latest/" ]; then
    echo "Can't find directory '$1/latest/'"
    return 1
  fi
  #diff --brief -Nr "$1/latest/" "$1/reviewed/"
  # TODO: --paginate?, more/less?
  diff -Nr --exclude=".git" "$1/reviewed/" "$1/latest/" && :
  retVal=$?
  if [ $retVal -gt 1 ]; then
    return $retVal
  fi
}

check_all() {
  if [ -f "$0" ]; then
    cd "$(dirname "$0")"
  else
    echo "Exec me. Don't source me."
    return 1
  fi
  for vdir in * .[^.]*; do
    # directories only
    [ -d "$vdir" ] || continue

    echo "### Getting latest '$vdir'..."
    local latest="$vdir/latest"
    [ -d "$latest" ] && rm -rf "$latest"
    mkdir "$latest"
    "$vdir/get.sh" "$latest"

    echo "### Changes to '$vdir':"
    review_latest "$vdir"
    # TODO: ask user y(es) n(o) q(uit)
  done
}

check_all
