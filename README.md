# Code.org Curriculum

## Overview

This is the root (umbrella) repository for the code.org branded curriculum. The submodules are

1. [blockly-core](https://github.com/code-dot-org/blockly-core): The core code for Blockly.
2. [blockly](https://github.com/code-dot-org/blockly): Apps built based on blockly-core. It includes a 1-Hour and a 20-Hour curricula.
3. [dashboard](https://github.com/code-dot-org/dashboard): The system that holds blockly tutorials. It includes students' and teachers' registration and progress info, and logs their behavior.
4. [cdo-i18n](https://github.com/code-dot-org/cdo-i18n): The internationalization project that translates our tutorial to multiple languages using CrowdIn.
5. [blockly-core-i18n](https://github.com/code-dot-org/blockly-core-i18n): The internationalization project for blockly-core in addition to cde-i18n.

## Set Up

1. Checkout the repository as well as submodules
  - `git clone --recursive https://github.com/code-dot-org/cdo-curriculum.git`
2. Install [nodejs](http://nodejs.org/download/)
3. (OSX) Install Homebrew
    - `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`

### Set up Blockly

1. `cd <repo_dir>/projects/blockly`
2. Install the [Grunt CLI](http://gruntjs.com/getting-started#installing-the-cli) (you may need to prefix with `sudo`): `npm install -g grunt-cli`
3. Install the [node-canvas](https://github.com/LearnBoost/node-canvas) dependencies (Instructions for [OS X](https://github.com/LearnBoost/node-canvas/wiki/Installation---OSX), [Ubuntu](https://github.com/LearnBoost/node-canvas/wiki/Installation---Ubuntu))
    - OS X: as noted in the install guide, you may need to install the libpng [OS X binary](http://ethan.tira-thompson.com/Mac_OS_X_Ports.html)
4. Build
    - `npm install`
    - `grunt`
        + you can safely ignore any test timeouts
5. Run with live-reload server
    - `MOOC_DEV=1 grunt dev`
    - Go to [http://localhost:8000](http://localhost:8000) to see the blockly-only mode.
    - If you get the error `Uncaught Error: Cannot find module 'ejs'`, you may need to swap out an old version of your node-browserify's browserify module. For now, contact Brent for an old copy.

### Set up Dashboard

1. `cd <repo_dir>/projects/dashboard`
2. Install Ruby (using [rbenv](https://github.com/sstephenson/rbenv#installation)) and MySQL
    - OSX: Use Homebrew to install:
      + `brew install rbenv git ruby-build mysql`
      + configure mysql:
        1. To have launchd start mysql at login:
            + `ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents`
        2. Then to load mysql now:
            + `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist`
        3. Or, if you don't want/need launchctl, you can just run:
            + `mysql.server start`
        4. To connect:
            + `mysql -uroot`
      + to configure rbenv, add this to ~/.profile
        1. `if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi`
        2. then `source ~/.profile`
    - Ubuntu:
      + install MySQL packages (leave root password blank when prompted): `sudo apt-get install mysql-client mysql-server libmysqlclient-dev`
      + Start service (should auto-start on system boot): `sudo start mysql`
      + To connect:
        - `mysql`
      + Since the repository packages are out of date, you need to install rbenv and ruby-build from source (follow these [instructions](http://gorails.com/setup#ruby-rbenv))

3. Install ruby version through rbenv (takes a while)
    - `rbenv install 2.0.0-p247`
    - `rbenv global 2.0.0-p247`
    - `rbenv local 2.0.0-p247`

4. Install core gems (say “Yes” if asked to overwrite system rake)
    - `gem install bundle rake mailcatcher`

5. Rehash may be required to get new tools in the path
    - `rbenv rehash`

6. Install project gems
    - `bundle`
    - Note: if you hadn’t installed rails before this, you may need another rbenv rehash here.

7. Setup database:
    - `rake db:create`
    - `rake db:migrate`
    - `rake seed:all`

8. Configure Dashboard to use your development version of Blockly
    - `rake blockly:dev['../blockly']`

9. Start [mailcatcher](http://mailcatcher.me/) (installed during core gem install phase)
    - `mailcatcher`

10. Start rails.
    - `rails s`
    - Go to [http://localhost:3000](http://localhost:3000) to see the Blockly running within Dashboard.


## Submitting Pull Requests

If you do not have repository privileges, you can [create a fork and issue a pull request](https://help.github.com/articles/using-pull-requests) from it.

1. Checkout a new branch for a new feature
    - `git checkout -b branch_name`
2. Develop the new feature and push the changes to **your** repository
    - `git add YYY`
    - `git commit -m "ZZZ"`
    - `git push origin branch_name`
3. Go to your GitHub repo
    - [https://github.com/code-dot-org/cdo-curriculum](https://github.com/code-dot-org/cdo-curriculum)
4. Click on the "Pull Request" link, and send out a PR for others to review.

# Internationalization (I18n)

## I18n Setup

1. `cd ../cdo-i18n`
2. Install crowdin-cli
    - `gem install crowdin-cli`
3. Install Code.org secrets files
4. Set up CrowdIn
    - `secrets/path/cdo-env ./init.sh`
    - That will generate crowdin.yaml and populate it with the API key
5. To see Blockly in other languages
    - Run `MOOC_LOCALIZE=1 grunt rebuild` in blockly.
    - Start Rails: `rails s` in dashboard.
    - Go to [http://localhost:3000](http://localhost:3000) to see the Blockly running within Dashboard.

## I18N Development

1. To populate changes from and to CrowdIn for repos except blockly-core
    - View details at [https://github.com/code-dot-org/cdo-i18n](https://github.com/code-dot-org/cdo-i18n).
2. To populate changes from and to Crowdin for blockly-core
    - `cd ../blockly-core`
    - `./i18n/codeorg-messages.sh ../blockly-core-i18n`
    - Add and push the changed files.
    - Copy the files to blockly-core
        1. `cp msg/js/*.js ../blockly/lib/blockly/`

## Gotchas

1. If you see a Encoding::InvalidByteSequenceError:
    - force Ruby to use UTF-8 encoding `export RUBYOPT=-Ku`
2. If you see an error related to enforce_available_locales= being undefined:
    - install an older version of crowdin-cli `gem install crowdin-cli -v 0.2.2`

