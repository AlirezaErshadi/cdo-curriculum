aptitude update

# Production service dependencies.
aptitude -y install \
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
  libmagickwand-dev

export CDO_BUILD_PATH=/usr/src

if [[ ! -f $CDO_BUILD_PATH/ruby-2.0.0-p247.tar.gz ]]; then
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

# Configure Node.js
if [[ $CDO_DEV ]]; then
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

  npm install -g grunt-cli

  su -c $DASH_ROOT/dev_setup.sh $CDO_USER
fi
