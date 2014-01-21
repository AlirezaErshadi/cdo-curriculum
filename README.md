cdo-curriculum
==============

Overview
--------

The root (umbrella) repository for the code.org branded curriculum. The submodules are

1. blockly-core: The core code for Blockly.
2. blockly: Apps built based on blockly-core. It includes a 1-Hour and a 20-Hour curricula.
3. dashboard: The system that holds blockly tutorials. It includes students' and teachers' registration and progress info, and logs their behavior.
4. cdo-i18n: The internationalization project that translates our tutorial to multiple languages using CrowdIn.
5. blockly-core-i18n: The internationalization project for blockly-core in addition to cde-i18n.


Set Up
------
1. Checkout the repository as well as submodules
  - `git clone --recursive git@github.com:code-dot-org/cdo-curriculum.git`
2. Install [nodejs](http://nodejs.org/download/)

### Set up Blockly

1. cd blockly
2. Install Homebrew (OSX)
    - ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
2. npm install -g grunt-cli
3. Build
    - npm install
    - grunt
4. Run with live-reload server
    - grunt dev
    - Go to [http://localhost:8000](http://localhost:8000) to see the blockly-only mode.

### Set up Dashboard
1. cd ../dashboard
2. Install brew packages (**follow instructions from mysql to set it up as a daemon, and rbenv info to .profile**)
    - brew install rbenv git ruby-build mysql imagemagick
    - for mysql
        1. To have launchd start mysql at login:
            + ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
        2. Then to load mysql now:
            + launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
        3. Or, if you don't want/need launchctl, you can just run:
            + mysql.server start
        4. To connect:
            + mysql -uroot

    - for rbenv add this to ~/.profile
        1. if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
        2. then source ~/.profile

3. Setup rbenv and ruby (takes a while)
    - rbenv install 2.0.0-p247
    - rbenv global 2.0.0-p247
    - rbenv local 2.0.0-p247

4. Install core gems (say “Yes” if asked to overwrite system rake)
    - gem install bundle rake

5. Rehash may be required to get new tools in the path
    - rbenv rehash

6. Install project gems
    - bundle
    - Note: if you hadn’t installed rails before this, you may need another rbenv rehash here.

7. Setup database:
    - rake db:create
    - rake db:migrate
    - rake seed:all

8. Configure Dashboard to use your development version of Blockly
    - rake blockly:dev['../blockly']

9. Start rails.
    - rails s
    - Go to [http://localhost:3000](http://localhost:3000) to see the Blockly running within Dashboard.


Git and Pull Request
--------------------
1. Checkout a new branch for a new feature
    - `git checkout -b branch_name`
2. Develop the new feature and push the changes to **your** repository
    - `git add YYY`
    - `git commit -m "ZZZ"`
    - `git push origin branch_name`
3. Go to your GitHub repo
    - [https://github.com/code-dot-org/cdo-curriculum](https://github.com/code-dot-org/cdo-curriculum)
4. Click on the "Pull Request" link, and send out a PR for others to review.

Additional Setup for I18n
-------------------------

## Set up I18n
1. cd ../cdo-i18n
2. Install crowdin-cli
    - gem install crowdin-cli
3. Install Code.org secrets files
4. Set up CrowdIn
    - secrets/path/cdo-env ./init.sh
    - That will generate crowdin.yaml and populate it with the API key
5. To see Blockly in other languages
    - Run `MOOC_LOCALIZE=1 grunt rebuild` in blockly.
    - Start Rails: `rails s` in dashboard.
    - Go to [http://localhost:3000](http://localhost:3000) to see the Blockly running within Dashboard.

## Develop
1. To populate changes from and to CrowdIn for repos except blockly-core
    - View details at [https://github.com/code-dot-org/cdo-i18n](https://github.com/code-dot-org/cdo-i18n).
2. To populate changes from and to Crowdin for blockly-core
    - cd ../blockly-core
    - ./i18n/codeorg-messages.sh ../blockly-core-i18n
    - Add and push the changed files.
    - Copy the files to blockly-core
        1. cp msg/js/*.js ../blockly/lib/blockly/
