fetch() {
  if [ -z "$2" ]; then
    echo "Expected uri and directory as args to fetch"
    return 1
  fi

  if command -v curl > /dev/null; then
    case $1 in
      *.tar.gz|*.tgz)
        curl -fLsS "$1" | tar -xz -C "$2";;
      *)
        curl -fLsSo "$2/$(basename "$1")" "$1"
    esac
  else
    case $1 in
      *.tar.gz|*.tgz)
        wget -nv -O - "$1" | tar -xz -C "$2";;
      *)
        wget -nv -P "$2" "$1"
    esac
  fi
}
