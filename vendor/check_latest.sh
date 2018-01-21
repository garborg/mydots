#!/bin/sh

set -e

# hope there's nothing fancy in your global gitignore
gig2excludes() {
  local config_dir="$XDG_CONFIG_HOME"
  [ -z "$config_dir" ] && config_dir="$HOME/.config"
  local gig="$config_dir/git/ignore"
  if [ -f "$gig" ]; then
    # shellcheck disable=SC2086
     grep '^[^#]' $gig | sed "s/.*/ -x &/" | tr -d '\n'
 fi
}

ask() {
  while true; do
    echo "$1 (y/n/q)"
    local answer
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        return 1
    elif echo "$answer" | grep -iq "^n" ;then
        return 0
    elif echo "$answer" | grep -iq "^q" ;then
        exit 1
    fi
  done
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
  echo "### Change summary:"
  # shellcheck disable=2046
  diff -rq -x '.git' $(gig2excludes) "$1/reviewed/" "$1/latest/" && :
  retVal=$?
  if [ $retVal = 1 ]; then
    echo "### Diffs:"
    # Print out the diffs, should print everything before complaining about binaries
    # TODO:--paginate?, more/less?
    # shellcheck disable=2046
    diff -rN -x '.git' $(gig2excludes) "$1/reviewed/" "$1/latest/" || true
    echo ''
    ask "Do you want to vendor these changes?" && :
    local vendor=$?
    if [ $vendor = 1 ]; then
      mv "$1/reviewed" "$1/oldreviewed"
      mv "$1/latest" "$1/reviewed"
      rm -rf "$1/oldreviewed"
    fi
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

    review_latest "$vdir"
  done
}

check_all
