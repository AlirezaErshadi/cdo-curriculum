DEPLOY_TO=build.code.org

usage () {
  echo "Usage: $0 <staging|production|private>"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

if [[ !($1 == "production" || $1 == "staging" || $1 == "private") ]]; then
  usage
fi

ssh_cmd="ssh -q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

$ssh_cmd $DEPLOY_TO "cd ~/cdo-curriculum; ./scripts/deploy_dashboard.sh $1"
