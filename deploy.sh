#!/bin/bash

# build blockly-core
# build blockly
# release blockly
# run cap arg1 deploy

if [ -z "$1" ]
then
  echo "usage: ./deploy.sh <target>"
  echo "where target is the capistrano target you wish to deploy to."
fi

(
  cd blockly-core
  ./build_fast.sh
  cp blockly_compressed.js ../blockly/lib/blockly
)

(
  cd blockly
  npm install
  grunt build
  ./script/release
)

(
  cd dashboard
  cap $1 deploy
)
