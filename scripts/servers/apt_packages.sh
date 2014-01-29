#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

until sudo apt-get install -y build-essential
do
  echo "Waiting on apt-get update to work."
  sudo apt-get update
done

# Production service dependencies.
sudo aptitude -y install \
  git \
  mysql-client \
  libssl-dev \
  mysql-server \
  libmysqlclient-dev \
  libreadline-dev \
  libncurses-dev \
  nginx \
  libmagickcore-dev \
  libmagickwand-dev \
  openjdk-7-jre-headless
