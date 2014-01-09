# Checks submodules to see if they have been updated since last deploy,
# in which case we run their build script.

GIT_ROOT=`git rev-parse --show-toplevel`
source $GIT_ROOT/build_scripts/utility.sh

if [ -z "$1" ]
then
  echo "usage: ./$0 <submodule>"
  echo "Where submodule is a submodule that knows how to build itself with a"
  echo "script named build.sh at it's top level"
  exit 1
fi

time_of_commit () {
  echo `git show $1 --format="%at" | head -n1`
}

tag=`git describe --abbrev=0 --tags`
last_deploy_commit=`git rev-list $tag | head -n 1`
last_deploy_time=$(time_of_commit $last_deploy_commit)

last_commit=`git rev-list --all $GIT_ROOT/$1 | head -n 1`
last_commit_time=$(time_of_commit $last_commit)
# check if last_commit is newer than last_tagged_commit
if [[ last_commit_time -gt last_deploy_time ]] ; then
  $1/deploy.sh # Tell submodule to build itself.
  error_check "$1 couldn't deploy."
fi
