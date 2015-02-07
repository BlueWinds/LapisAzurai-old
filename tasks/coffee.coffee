# Grunt - Contrib - Coffee
# ========================
#
# Compile CoffeeScript files to JavaScript.
#
# Link: https://github.com/gruntjs/grunt-contrib-coffee

files = require '../src/loadOrder.coffee'
sfw = files.map (f)->('./src/' + f)
nsfw = sfw.concat files.nsfw.map (f)->('./src/' + f)

module.exports = (grunt)->
  options:
    sourceMap: true
  sfw:
    files: './public/game/compiled.js': sfw
  nsfw:
    files: './public/game/compiled.js': nsfw
