# Grunt - CoffeeLint
# ==================
#
# Lint CoffeeScript files.
#
# Link: https://github.com/vojtajina/grunt-coffeelint

module.exports = (grunt)->
  app: ['./src/**/*.coffee']
  options:
    arrowspacing: {level: 'error'}
    colon_asignment_spacing: {level: 'error', left: 0, right: 1}
    ensure_comprehensions: {level: 'error'}
    line_endings: {level: 'error', value: 'unix'}
    max_line_length: {level: 'ignore'}
    no_empty_param_list: {level: 'error'}
    no_interpolation_in_single_quotes: {level: 'error'}
    no_standalone_at: {level: 'error'}
    prefer_english_operator: {level:  'error'}
    space_operators: {level: 'error'}
    spacing_after_comma: {level: 'error'}
