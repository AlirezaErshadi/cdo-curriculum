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
  sudo aptitude -y install \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    gettext \
    libz-dev \
    libssl-dev
  if [[ ! -d ./git-1.8.4.4 ]]; then
    wget git-core.googlecode.com/files/git-1.8.4.4.tar.gz
    tar -zxf git-1.8.4.4.tar.gz
    cd git-1.8.4.4
    make prefix=/usr/local all
    sudo make prefix=/usr/local install
    git config --global user.name "Dashboard-build"
    git config --global user.email site@code.org
  fi
  if [[ ! -d node-0.10.20 ]]; then
    wget https://s3.amazonaws.com/cdo-dist/nodejs/nodejs-v0.10.20.tar.gz
    tar -xzvf nodejs-v0.10.20.tar.gz
    (
      cd node-0.10.20
      ./configure
      make
      sudo make install
    )
  fi
  sudo apt-get install -y git
  git clone --recursive $git_url
EOF

scp ~/.ssh/production-code-org.pem $server:/home/ubuntu/.ssh
scp -r $GIT_ROOT/../cdo-secrets $server:/home/ubuntu
