#!/bin/bash

sudo dpkg --configure -a
sudo apt-get -f install
sudo apt-get update
sudo apt-get dist-upgrade

echo "BEGIN PACKAGE INSTALL"

# Production service dependencies.
sudo apt-get -y install \
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
  openjdk-7-jre-headless \
  build-essential
