fs = require 'fs'
xml2js = require 'xml2js'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'rmbuild', ->
    fs.unlinkSync 'game/compiled.src'

  config = {
    coffee:
      compile:
        files: 'game/compiled.js': [
          # First the game engine
          'src/engine/feature-detect.coffee'
          'src/engine/util.coffee'
          'src/engine/classes/validated.coffee'
          'src/engine/classes/contextual.coffee'
          'src/engine/classes/game.coffee'
          'src/engine/classes/person.coffee'
          'src/engine/classes/trait.coffee'
          'src/engine/classes/page.coffee'
          'src/engine/classes/job.coffee'
          'src/engine/classes/place.coffee'

          'src/engine/screens/port.coffee'
          'src/engine/screens/hireCrew.coffee'

          # Then the content
          'src/content/traits/basicStats.coffee'
          'src/content/locations/Vailia/Vailia.coffee'
          'src/content/locations/Vailia/Friend/Friend.coffee'
          'src/content/locations/Vailia/Guildmaster/Guildmaster.coffee'
          'src/content/locations/Kantis/Kantis.coffee'
          'src/content/intro/intro.coffee'
          'src/content/intro/guild.coffee'
          'src/content/intro/utc.coffee'

          'src/engine/load.coffee'
        ]
        options:
          join: true
          sourceMap: true
          joinExt: '.src'
    coffeelint:
      app: ['src/**/*.coffee']
      options:
        arrowspacing: {level: 'error'}
        colon_asignment_spacing: {level: 'error', left: 0, right: 1}
        line_endings: {level: 'error', value: 'unix'}
        max_line_length: {level: 'ignore'}
        newlines_after_classes: {level: 'error', value: 2}
        no_standalone_at: {level: 'error'}
        space_operators: {level: 'error'}
        no_backticks: {level: 'ignore'}
    imagemin:
      crush:
        files: [{
          cwd: 'src/'
          expand: true
          src: ['**/*.{jpg,png,gif}']
          dest: 'game/'
        }]
        options:
          pngquant: true
          optimizationLevel: 1
    copy:
      libs:
        files: [{
          cwd: 'src/lib/fonts'
          expand: true
          src: ['**']
          dest: 'game/engine/fonts'
        },
        {
          cwd: 'src/lib'
          expand: true
          src: ['*.css']
          dest: 'game/engine'
        }]
      css:
        files:
          'game/engine/style.css': ['src/engine/style.css']
    uglify:
      options:
        mangle: false
      libs:
        files: {
          'game/engine/lib.js': ['src/lib/*.js']
        }
    watch:
      compile:
        files: ['src/**/*']
        tasks: ['compile']
  }
  grunt.initConfig config

  grunt.registerTask 'compile', ['coffeelint', 'coffee', 'rmbuild', 'imagemin', 'copy:css']
  grunt.registerTask 'lib', ['uglify', 'copy:libs']
  grunt.registerTask 'default', ['compile', 'watch']
