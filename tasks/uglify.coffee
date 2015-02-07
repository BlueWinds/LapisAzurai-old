# Grunt - Contrib - Uglify
# ========================
#
# Minify code.
#
# Link: https://github.com/gruntjs/grunt-contrib-uglify

module.exports = (grunt)->
  options:
    mangle: false
  libs:
    files:
      './public/game/engine/lib.js': ['./src/lib/*.js']
