cdo-curriculum
==============

The root (umbrella) repository for the code.org branded curriculum.

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

9. Start rails10.
  - rails s
  - Go to [http://localhost:3000](http://localhost:3000) to see the Blockly running within Dashboard.


Git and Pull Request
--------------------
1. Fork the repo, by clicking on the "Fork" button at the right corner.
2. Add tracking of your remote repo
  - `git remote add XXX git@@ithub.com:XXX/cdo-curriculum.git`
3. Checkout a new branch for a new feature
  - `git checkout -b branch_name`
4. Develop the new feature and push the changes to **your** repository
  - `git add YYY`
  - `git commit -m "ZZZ"`
  - `git push XXX branch_name`
5. Go to your GitHub repo
  - [https://github.com/XXX/cdo-curriculum](https://github.com/XXX/cdo-curriculum)
6. Click on the "Pull Request" link, and send out a PR for others to review.