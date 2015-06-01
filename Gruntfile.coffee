nsfwFiles = require('./src/loadOrder').map (f)->('src/' + f)

module.exports = (grunt) ->
  require('time-grunt')(grunt);

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-compress'

  config = {
    coffee:
      nsfw:
        files: 'public/game/compiled.js': nsfwFiles
    coffeelint:
      app: ['src/**/*.coffee']
      options:
        arrowspacing: {level: 'error'}
        colon_asignment_spacing: {level: 'error', left: 0, right: 1}
        line_endings: {level: 'error', value: 'unix'}
        max_line_length: {level: 'ignore'}
        no_standalone_at: {level: 'error'}
        space_operators: {level: 'error'}
        no_backticks: {level: 'ignore'}
        no_interpolation_in_single_quotes: {level: 'error'}
    copy:
      libs:
        files: [{
          cwd: 'src/lib/fonts'
          expand: true
          src: ['**']
          dest: 'public/game/engine/fonts'
        },
        {
          cwd: 'src/lib'
          expand: true
          src: ['*.css']
          dest: 'public/game/engine'
        }]
      static:
        files:
          'public/index.html': ['src/index.html']
          'public/game/CC-by-nc-sa-4.0.txt': ['src/content/CC-by-nc-sa-4.0.txt']
          'public/game/GPL.txt': ['src/engine/GPL.txt']
          'public/Credits.txt': ['src/Credits.txt']
          'public/README.txt': ['src/README.txt']
          'public/game/engine/style.css': ['src/engine/style.css']
      images:
        files: [{
          cwd: 'src/content/locations'
          expand: true
          src: ['**/*.png', '**/*.jpg']
          dest: 'public/game/content/locations'
        },
        {
          cwd: 'src/content/misc'
          expand: true
          src: ['**.png', '**.jpg']
          dest: 'public/game/content/misc'
        }]
    uglify:
      options:
        mangle: false
      libs:
        files:
          'public/game/engine/lib.js': ['src/lib/*.js']
    watch:
      compile:
        files: ['src/**/*']
        tasks: ['compile']
    clean:
      game: ['public', 'LapisAzurai.zip']
    compress:
      nsfw:
        options:
          archive: './LapisAzurai.zip'
        src: ['**/*']
        cwd: 'public'
        expand: true
  }
  grunt.initConfig config

  require('./tasks/sprites')(grunt)
  require('./tasks/dump')(grunt)

  grunt.registerTask 'compile', ['coffee', 'copy:static']
  grunt.registerTask 'lib', ['uglify', 'copy:libs', 'copy:images']
  grunt.registerTask 'full-compile', ['lib', 'coffeelint', 'compile', 'dump']
  grunt.registerTask 'full-build', ['clean', 'full-compile', 'sprites', 'compress']
  grunt.registerTask 'default', ['lib', 'coffeelint', 'compile', 'watch:compile']
