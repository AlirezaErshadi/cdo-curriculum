#!/bin/bash

sudo dpkg --configure -a
sudo apt-get -f install
sudo apt-get update
sudo apt-get dist-upgrade

# Production service dependencies.
sudo apt-get -y install \
  build-essential \
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
