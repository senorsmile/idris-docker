#!/usr/bin/env bash

set -euo pipefail

source variables.sh

set +u
bashrc="$BASHRC:-$HOME/.bashrc"
set -u

opts=(
  -it
  --rm
  -v ${PWD}:/home/idris/hostdir/ # mount this dir
  -v ${HOME}/.bashrc:/home/idris/.bashrc # copy in bashrc
  --name "idris${IDRIS_VER}"
  "senorsmile-idris:${IDRIS_VER}-${BUILD_NUM}"
  $@
)

docker run ${opts[@]}

