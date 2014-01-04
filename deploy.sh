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

git submodule update --recursive
./dashboard/build_deps.sh

(
  cd blockly-core
  chmod +x ../closure-library-read-only/closure/bin/build/closurebuilder.py
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
  bundle exec cap $1 deploy
)
