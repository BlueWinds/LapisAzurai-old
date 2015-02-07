# Grunt - Contrib - Compress
# ==========================
#
# Compress fils and folders to archives.
#
# Link: https://github.com/gruntjs/grunt-contrib-compress

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
  win64:
    options:
      archive: './dist/win64-LapisAzurai.zip'
    cwd: './dist/builds/Lapis-Azurai/win64/'
    src: '**'
    expand: true
  win32:
    options:
      archive: './dist/win32-LapisAzurai.zip'
    cwd: './dist/builds/Lapis-Azurai/win32/'
    src: '**'
    expand: true
  linux64:
    options:
      archive: './dist/linux64-LapisAzurai.zip'
    cwd: './dist/builds/Lapis-Azurai/linux64/'
    src: '**'
    expand: true
  linux32:
    options:
      archive: './dist/linux32-LapisAzurai.zip'
    cwd: './dist/builds/Lapis-Azurai/linux32/'
    src: '**'
    expand: true
  osx64:
    options:
      archive: './dist/osx64-LapisAzurai.zip'
    cwd: './dist/builds/Lapis-Azurai/osx64/'
    src: '**'
    expand: true
  osx32:
    options:
      archive: './dist/osx32-LapisAzurai.zip'
    cwd: './dist/builds/Lapis-Azurai/osx32/'
    src: '**'
    expand: true
