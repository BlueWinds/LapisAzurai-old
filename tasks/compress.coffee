# Grunt - Contrib - Compress
# ==========================
#
# Compress fils and folders to archives.
#
# Link: https://github.com/gruntjs/grunt-contrib-compress

'use strict';

module.exports = (grunt)->
  nsfw:
    options:
      archive: './dist/LapisAzurai.zip'
    src: [
      './public/index.html',
      './public/dump.html',
      './Credits',
      './public/game/**/*'
    ]
  sfw:
    options:
      archive: './dist/LapisAzuraiSFW.zip'
    src: [
      './public/index.html',
      './public/dump.html',
      './Credits',
      './public/game/**/*'
    ]
