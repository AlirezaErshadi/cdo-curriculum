#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`
PROJECTS="$GIT_ROOT/projects"
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

blockly=$PROJECTS/blockly

if [ ! -d $secrets ]; then
  echo "Cannot find cdo-secrets at path: $secrets"
  exit 1
fi

source $secrets/exports

git submodule update --init --remote --checkout $GIT_ROOT/projects/*
git add projects
git commit -m "Updated submodules with latest master commit from origin." -- projects || true

$GIT_ROOT/build_scripts/deploy_submodule.sh blockly-core; error_check
cp $PROJECTS/blockly-core/blockly_compressed.js $PROJECTS/blockly/lib/blockly; error_check
$GIT_ROOT/build_scripts/deploy_submodule.sh blockly; error_check

(
  cd ../dashboard
  bundle install
  bundle exec cap $1 deploy:setup -s secrets=$secrets
  bundle exec cap $1 deploy:migrations -s secrets=$secrets -s blockly=$blockly
)
error_check "Dashboard failed to deploy"
