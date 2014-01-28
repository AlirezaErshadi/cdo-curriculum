#!/bin/bash
GIT_ROOT=`git rev-parse --show-toplevel`
PROJECTS="$GIT_ROOT/projects"

if [[ $1 == "debug" ]]; then
  export target=blockly_debug.js
  export MOOC_DEV=1
else
  export target=blockly_compressed.js
fi
(
  cd $PROJECTS/blockly-core
  ./deploy.sh $1
  cp $target $PROJECTS/blockly/lib/blockly
)

(
  cd $PROJECTS/blockly
  npm install
  grunt build
)
