DEPLOY_TO=ec2-54-197-63-203.compute-1.amazonaws.com

ssh_cmd="ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

$ssh_cmd $DEPLOY_TO "cd ~/cdo-curriculum; ./build_scripts/deploy_dashboard.sh $1"
