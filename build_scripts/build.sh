#!/bin/bash
GIT_ROOT=`git rev-parse --show-toplevel`

(
  cd $GIT_ROOT/blockly-core
  ./deploy.sh $1
  if [[ $1 == "debug" ]]; then
    target=blockly_debug.js
  else
    target=blockly_compressed.js
  fi
  cp $target $GIT_ROOT/blockly/lib/blockly
)

(
  cd $GIT_ROOT/blockly
  npm install
  grunt build
)
