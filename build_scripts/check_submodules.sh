# Checks submodules to see if they have been updated since last deploy,
# in which case we run their build script.

GIT_ROOT=`git rev-parse --show-toplevel`

time_of_commit () {
  return `git show $1 --format="%at" | head -n1`
}

tag=`git describe --abbrev=0 --tags`
last_deploy_commit=`git rev-list $tag | head -n 1`
last_deploy_time=`time_of_commit $last_deploy_commit`
for submodule in blockly blockly-core
do
  last_commit=`git rev-list --all $GIT_ROOT/$submodule | head -n 1`
  last_commit_time=`time_of_commit $last_commit`
  # check if last_commit is newer than last_tagged_commit
  if [[ last_commit_time -gt last_deploy_time ]] ; then
    echo "submodule $submodule is out of date"
  fi
done
