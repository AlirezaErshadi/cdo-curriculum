GIT_ROOT=`git rev-parse --show-toplevel`

current=`cat $GIT_ROOT/VERSION`
new=$((current + 1))

echo $new > $GIT_ROOT/VERSION
git add $GIT_ROOT/VERSION
git tag $new
git commit -m "[Deployed version $new]"
git push --tags
