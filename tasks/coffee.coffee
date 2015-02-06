# Grunt - Contrib - Coffee
# ========================
#
# Compile CoffeeScript files to JavaScript.
#
# Link: https://github.com/gruntjs/grunt-contrib-coffee

'use strict';

files = require '../src/loadOrder.coffee'
sfw = files.map (f)->('./src/' + f)
nsfw = sfw.concat files.nsfw.map (f)->('./src/' + f)

module.exports = (grunt)->
  sfw:
    files: './public/game/compiled.js': sfw
  nsfw:
    files: './public/game/compiled.js': nsfw
