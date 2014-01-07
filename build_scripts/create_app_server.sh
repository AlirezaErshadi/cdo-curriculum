#!/bin/bash

if [ $# -lt 1 ]
then
  echo "usage: $0 <server>"
  echo "server is a clean ubuntu server which will act as an app server."
  echo "you must be able to ssh to <server> without entering a password. Meaning, you must have the pem file in your ~/.ssh directory."
  exit 0
fi

server=$1
ssh $server 'sudo bash -s' < ./install_deps.sh
