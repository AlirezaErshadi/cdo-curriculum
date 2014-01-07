#!/bin/bash
(
  cd ../blockly
  npm install
  grunt build
)

(
  cd ../dashboard
  bundle exec rake blockly:dev['../blockly']
)
