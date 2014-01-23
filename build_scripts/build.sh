#!/bin/bash
GIT_ROOT=`git rev-parse --show-toplevel`

if [[ $1 == "debug" ]]; then
  export target=blockly_debug.js
  export MOOC_DEV=1
else
  export target=blockly_compressed.js
fi
(
  cd $GIT_ROOT/blockly-core
  ./deploy.sh $1
  cp $target $GIT_ROOT/blockly/lib/blockly
)

(
  cd $GIT_ROOT/blockly
  npm install
  grunt build
)
