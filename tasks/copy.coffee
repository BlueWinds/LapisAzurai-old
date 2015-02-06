# Grunt - Contrib - Copy
# ======================
#
# Copy files and folders.
#
# Link: https://github.com/gruntjs/grunt-contrib-copy

'use strict';

module.exports = (grunt)->
  html:
    files:
      './public/index.html': ['./src/index.html']
  libs:
    files: [{
      cwd: './src/lib/fonts'
      expand: true
      src: ['**']
      dest: './public/game/engine/fonts'
    },
    {
      cwd: './src/lib'
      expand: true
      src: ['*.css']
      dest: './public/game/engine'
    }]
  css:
    files:
      './public/game/engine/style.css': ['./src/engine/style.css']
  images:
    files: [{
      cwd: './src/content/locations'
      expand: true
      src: ['**/*.png', '**/*.jpg']
      dest: './public/game/content/locations'
    },
    {
      cwd: './src/content/misc'
      expand: true
      src: ['**.png', '**.jpg']
      dest: './public/game/content/misc'
    }]
