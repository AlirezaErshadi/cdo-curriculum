#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`

(
  cd $GIT_ROOT/blockly
  npm install
  grunt build
)

(
  cd $GIT_ROOT/dashboard
  bundle exec rake blockly:dev['../blockly']
)
