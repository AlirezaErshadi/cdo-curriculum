DEPLOY_TO=build.code.org

ssh_cmd="ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

$ssh_cmd $DEPLOY_TO "cd ~/cdo-curriculum; ./build_scripts/deploy_dashboard.sh $1"
