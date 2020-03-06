#!/usr/bin/env bash

set -euo pipefail

source variables.sh


opts=(
  -it
  --rm
  -v ${PWD}:/home/idris/hostdir/ # mount this dir
  -v ${HOME}/.bashrc:/home/idris/.bashrc # copy in bashrc
  --name idris1.3.2
  "senorsmile-idris:${IDRIS_VER}"
  $@
)

docker run ${opts[@]}

