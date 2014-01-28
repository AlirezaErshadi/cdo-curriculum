DEPLOY_TO=ec2-54-197-63-203.compute-1.amazonaws.com

git submodule foreach git fetch origin
export status=0
git submodule foreach << EOF
  local=`git rev-parse HEAD`
  remote=`git rev-parse origin/master`
EOF

ssh_cmd="ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/production-code-org.pem"

$ssh_cmd $DEPLOY_TO "~/cdo-curriculum/build_scripts/deploy_dashboard.sh" $1
