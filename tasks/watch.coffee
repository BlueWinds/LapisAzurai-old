# Grunt - Contrib - Watch
# =======================
#
# Watch files for changes and trigger tasks.
#
# Link: https://github.com/gruntjs/grunt-contrib-watch

module.exports = (grunt)->
  compile:
    files: ['./src/**/*']
    tasks: ['compile']
  sfw:
    files: ['./src/**/*']
    tasks: ['compile-sfw']
