# #!/bin/bash
# set -eu

DT_IMG_NAME=devtainer

DT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

dt_build() {
  docker build -t $DT_IMG_NAME "$DT_DIR"
}

dt_run() {
  if [ -z "$1" ]; then
    echo "Please supply container name as an argument"
    return 1
  fi
  if [ -n "$2" ]; then
    echo "Too many arguments"
    return 1
  fi

  local ctr="$1"

  local pid
  pid=$(docker ps -aq --filter "name=$ctr")
  if [ -n "$pid" ]; then
    if docker inspect -f '{{.State.Running}}' "$ctr"; then
      docker stop "$ctr"
    fi
    docker rm "$ctr"
  fi

  docker run -it --name "$ctr" \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/usr/src/$(basename "$(pwd)")" \
    $DT_IMG_NAME
}
