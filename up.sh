#!/bin/sh

set -eu

img=idebvim
ctr=debvim

pid=$(docker ps -aq --filter "name=$ctr")
if [ -n "$pid" ]; then
  if docker inspect -f '{{.State.Running}}' $ctr; then
    docker stop $ctr
  fi
  docker rm $ctr
fi

docker build -t $img .

  #-u "$(id -u):$(id -g)" \
docker run -it --name $ctr \
  -v "$(pwd):/usr/src/$(basename "$(pwd)")" \
  $img
