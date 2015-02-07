# Grunt - node-webkit-builder
# ===========================
#
# Create packages with standalone builds. Settings are defined at the end of the 'package.json'.
#
# Link: https://github.com/mllrsohn/grunt-node-webkit-builder
#       https://github.com/nwjs/nw.js/wiki
#

'use strict';

module.exports = (grunt)->
  options:
    platforms: [
      'win',
      'linux'
      # 'osx'
    ]
    cacheDir: './dist/cache'
    buildDir: './dist/builds'
  src: [
    './package.json',
    './public/**'
  ]
