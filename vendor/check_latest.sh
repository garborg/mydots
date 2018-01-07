#!/bin/sh

set -e

# hope there's nothing fancy in your main gitignore
gig2excludes() {
  local cdir="$XDG_CONFIG_HOME"
  [ -z "$cdir" ] && cdir="$HOME/.config"
  local gig="$cdir/git/ignore"
  if [ -f "$gig" ]; then
    # shellcheck disable=SC2086
     grep '^[^#]' $gig | sed "s/.*/ -x &/" | tr -d '\n'
 fi
}

review_latest() {
  if ! [ -d "$1/reviewed/" ]; then
    echo "Can't find directory '$1/reviewed/'"
    return 1
  fi
  if ! [ -d "$1/latest/" ]; then
    echo "Can't find directory '$1/latest/'"
    return 1
  fi
  # Summary of diff, shouldn't err on binaries
  # shellcheck disable=2046
  diff -rq -x '.git' $(gig2excludes) "$1/reviewed/" "$1/latest/" && :
  retVal=$?
  if [ $retVal = 1 ]; then
    echo ''
    # Print out the diffs, should print everything before complaining about binaries
    # TODO:--paginate?, more/less?
    # shellcheck disable=2046
    diff -rN -x '.git' $(gig2excludes) "$1/reviewed/" "$1/latest/" || true
  elif [ $retVal -gt 1 ]; then
    return $retVal
  fi
}

check_all() {
  if [ "$(basename "$0")" = "check_latest.sh" ]; then
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
