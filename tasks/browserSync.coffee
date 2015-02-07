# Grunt - BrowserSync
# ===================
#
# Run a localserver which reloads on file updates.
#
# Link: https://github.com/shakyShane/grunt-browser-sync

module.exports = (grunt)->
  dev:
    options:
      watchTask: true
      open: true
      # browser: ['firefox']
      port: 8000
      files: [
        './public/**'
      ]
      server:
        baseDir: './public'
        # index: 'index.html'
