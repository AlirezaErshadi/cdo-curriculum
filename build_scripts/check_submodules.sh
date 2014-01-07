# Checks submodules to see if they have been updated since last deploy,
# in which case we run their build script.

for submodule in blockly blockly-core
do
  last_commit=`git rev-list --all ../$submodule | HEAD -n1`
done
