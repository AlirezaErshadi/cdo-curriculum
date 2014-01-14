current=`git describe --abbrev=0 --tags`
new=$((current + 1))

git tag $new
git push --tags
