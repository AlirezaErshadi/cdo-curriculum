#!/bin/bash

if [ $# -lt 1 ]
then
  echo "usage: $0 <server>"
  echo "server is a clean ubuntu server which will act as a build server."
  echo "you must be able to ssh to <server> without entering a password. Meaning, you must have the pem file in your ~/.ssh directory."
  exit 0
fi

server=$1
git_url=`git config --get remote.origin.url`
ssh $server sudo apt-get install -y git
ssh $server git clone --recursive $git_url
ssh $server crontab -u ubuntu /home/ubuntu/cdo-curriculum/build_scripts/deploy.cron
scp ~/.ssh/production-code-org.pem $server:/home/ubuntu/.ssh
