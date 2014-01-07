#!/bin/bash
# build blockly-core
# build blockly
# release blockly
# run cap arg1 deploy

if [ -z "$1" ]
then
  echo "usage: ./deploy.sh <target>"
  echo "where target is the capistrano target you wish to deploy to."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" -o -z "$AWS_ACCESS_KEY_ID" ]; then
  echo 'AWS environment is not defined. Use cdo-env for secrets' > /dev/stderr
  exit 1
fi

git submodule update --recursive

(
  cd ../blockly-core
  chmod +x ../closure-library-read-only/closure/bin/build/closurebuilder.py
  ./build_fast.sh
  cp blockly_compressed.js ../blockly/lib/blockly
)

(
  cd ../blockly
  LAST_TAG=`git describe --abbrev=0 --tags`
  LAST_TAGGED_COMMIT=`git rev-list $LAST_TAG | head -n 1`
  LAST_COMMIT=`git log --format="%H" | head -n1`
  if [[ $LAST_COMMIT -ne $LAST_TAGGED_COMMIT ]]; then
    npm install
    grunt build
    ./script/release
  fi
)

(
  cd ../dashboard
  bundle exec cap $1 deploy
)
