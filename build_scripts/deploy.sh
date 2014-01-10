#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`
source $GIT_ROOT/build_scripts/utility.sh

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

git submodule foreach git checkout master
git submodule foreach git pull
git add `git submodule foreach --quiet git rev-parse --show-toplevel`

$GIT_ROOT/build_scripts/deploy_submodule.sh blockly-core; error_check
cp $GIT_ROOT/blockly-core/blockly_compressed.js $GIT_ROOT/blockly/lib/blockly; error_check
$GIT_ROOT/build_scripts/deploy_submodule.sh blockly; error_check

(
  cd ../dashboard
  bundle exec cap $1 deploy
)
error_check "Dashboard failed to deploy"

# $GIT_ROOT/build_scripts/publish_tag.sh
