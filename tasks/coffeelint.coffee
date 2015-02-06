# Grunt - CoffeeLint
# ==================
#
# Lint CoffeeScript files.
#
# Link: https://github.com/vojtajina/grunt-coffeelint

'use strict';

module.exports = (grunt)->
  app: ['./src/**/*.coffee']
  options:
    arrowspacing: {level: 'error'}
    colon_asignment_spacing: {level: 'error', left: 0, right: 1}
    line_endings: {level: 'error', value: 'unix'}
    max_line_length: {level: 'ignore'}
    no_standalone_at: {level: 'error'}
    space_operators: {level: 'error'}
    no_backticks: {level: 'ignore'}
    no_interpolation_in_single_quotes: {level: 'error'}
