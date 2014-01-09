#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`

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

git submodule foreach git checkout deploy
git submodule foreach git pull

$GIT_ROOT/build_scripts/deploy_submodule.sh blockly-core
cp $GIT_ROOT/blockly-core/blockly_compressed.js $GIT_ROOT/blockly/lib/blockly
$GIT_ROOT/build_scripts/deploy_submodule.sh blockly

(
  cd ../dashboard
  bundle exec cap $1 deploy
)
