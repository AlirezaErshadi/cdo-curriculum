#!/bin/bash

export CDO_BUILD_PATH=/usr/src

if [[ ! -f $CDO_BUILD_PATH/ruby-2.0.0-p247.tar.gz ]]; then
  echo "installing ruby"
  wget -P $CDO_BUILD_PATH https://s3.amazonaws.com/cdo-dist/ruby/ruby-2.0.0-p247.tar.gz
  tar -C $CDO_BUILD_PATH -xzvf $CDO_BUILD_PATH/ruby-2.0.0-p247.tar.gz
  (
    cd $CDO_BUILD_PATH/ruby-2.0.0-p247
    ./configure
    make
    make install
  )
fi

gem install bundler
gem install unicorn
