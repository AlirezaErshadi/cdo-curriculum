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
GIT_ROOT=`git rev-parse --show-toplevel`


ssh $server << EOF
  if [[ ! -d $CDO_BUILD_PATH/node-0.10.20 ]]; then
    wget -P $CDO_BUILD_PATH https://s3.amazonaws.com/cdo-dist/nodejs/nodejs-v0.10.20.tar.gz
    tar -C $CDO_BUILD_PATH -xzvf $CDO_BUILD_PATH/nodejs-v0.10.20.tar.gz
    (
      cd $CDO_BUILD_PATH/node-0.10.20
      ./configure
      make
      make install
    )
  fi
  sudo apt-get install -y git
  git clone --recursive $git_url
  crontab -u ubuntu /home/ubuntu/cdo-curriculum/build_scripts/deploy.cron
EOF

scp ~/.ssh/production-code-org.pem $server:/home/ubuntu/.ssh
scp -r $GIT_ROOT/../cdo-secrets $server:/home/ubuntu
