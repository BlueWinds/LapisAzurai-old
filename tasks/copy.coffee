# Grunt - Contrib - Copy
# ======================
#
# Copy files and folders.
#
# Link: https://github.com/gruntjs/grunt-contrib-copy

module.exports = (grunt)->
  html:
    files:
      './public/index.html': ['./src/index.html']
      './public/Credits.txt': ['./src/Credits.txt']
      './public/CC-by-nc-sa-4.0.txt': ['./src/CC-by-nc-sa-4.0.txt']
      './public/game/GPL.txt': ['./src/engine/GPL.txt']
      './public/README.txt': ['./src/README.txt']
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
