#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`
source $GIT_ROOT/build_scripts/utility.sh

if [ $# -lt 1 ]
then
  echo "usage: ./deploy.sh <target> [cdo-secrets]"
  echo "target: capistrano target you wish to deploy to."
  echo "cdo-secrets: deaults to ../../cdo-secrets"
  exit 1
fi

if [ -z $2 ]; then
  secrets=$GIT_ROOT/../cdo-secrets
else
  secrets=$2
fi

blockly=$GIT_ROOT/blockly

if [ ! -d $secrets ]; then
  echo "Cannot find cdo-secrets at path: $secrets"
  exit 1
fi

source $secrets/exports

(
  cd $GIT_ROOT
  git submodule foreach git checkout master
  git submodule foreach git pull
  git add `git submodule foreach --quiet git rev-parse --show-toplevel`
)

$GIT_ROOT/build_scripts/deploy_submodule.sh blockly-core; error_check
cp $GIT_ROOT/blockly-core/blockly_compressed.js $GIT_ROOT/blockly/lib/blockly; error_check
$GIT_ROOT/build_scripts/deploy_submodule.sh blockly; error_check

(
  cd ../dashboard
  bundle exec cap $1 deploy:setup -s secrets=$secrets
  bundle exec cap $1 deploy -s secrets=$secrets -s blockly=$blockly
)
error_check "Dashboard failed to deploy"
