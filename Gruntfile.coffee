fs = require 'fs'
async = require('async')
Canvas = require('canvas')

files = require './src/loadOrder'

grunt = null

module.exports = (g) ->
  grunt = g
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  config = {
    coffee:
      compile:
        files: 'game/compiled.js': files.map (f)->('src/' + f)
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
      images:
        files: [{
          cwd: 'src/content/locations'
          expand: true
          src: ['**/*.png', '**/*.jpg']
          dest: 'game/content/locations'
        },
        {
          cwd: 'src/content/misc'
          expand: true
          src: ['**.png', '**.jpg']
          dest: 'game/content/misc'
        }]
    uglify:
      options:
        mangle: false
      libs:
        files:
          'game/engine/lib.js': ['src/lib/*.js']
    watch:
      compile:
        files: ['src/**/*']
        tasks: ['compile']

    pngnq:
      src: ['game/**/*.png']
      dest: 'game'
  }
  grunt.initConfig config

  grunt.registerTask 'sprites', (name)->
    done = @async()
    createAllSprites name, done

  grunt.registerTask 'compile', ['coffee', 'copy:css']
  grunt.registerTask 'lib', ['uglify', 'copy:libs', 'copy:images']
  grunt.registerTask 'full-build', ['lib', 'coffeelint', 'compile', 'sprites']
  grunt.registerTask 'default', ['lib', 'coffeelint', 'compile', 'watch']


loadGameObjects = ->
  html = fs.readFileSync('index.html').toString()

  unless global.window
    global.window = global
    global.$ = ->
    global.$.extend = ->

    require('./game/compiled')

  return global.window

###
  Sprite generation functions
###

createAllSprites = (runFor, finished)->
  try
    fs.mkdirSync('game/sprites')
  catch e
    null

  {Person, Officer} = loadGameObjects()

  people = for name, person of Officer
    unless person.prototype instanceof Person and person.images then continue
    person

  for name, person of Person
    unless person.prototype instanceof Person and person.images then continue
    people.push person

  names = if runFor then [runFor] else people.map (p)->p::name
  grunt.log.writeln "Generating sprites for #{names.length} people"
  async.eachSeries people, (person, nextPerson)->
    unless person::name and person::name in names
      return nextPerson()
    grunt.log.subhead person::name
    try
      fs.mkdirSync("game/sprites/#{person.name}")
    catch e
      null
    sampleImage = new Canvas.Image
    sampleImage.onload = ->
      async.eachSeries Object.keys(person.images), (image, nextImage)->
        if image in ['path', 'scale'] then return nextImage()

        logNext = (err)->
          grunt.log.ok image
          nextImage err

        imageInfo = person.images[image]

        unless person.colors
          path = person.images.path
          target = "game/sprites/#{person.name}/#{image}.png"
          scale = person.images.scale or 1
          return buildSingleSprite scale, path, imageInfo, target, logNext

        async.each [0...imageInfo.length], (layer, nextLayer)->
          path = person.images.path + imageInfo[layer]
          unless path then return nextLayer()
          target = "game/sprites/#{person.name}/#{image}-#{layer}-"
          scale = person.images.scale or 1
          createColorizedSprites person.colors[layer], scale, path, target, nextLayer
        , logNext
      , nextPerson

    sampleImage.src = person.images.path + person.images.normal[0]

  , finished


createColorizedSprites = (colors, scale, path, target, done)->
  image = new Canvas.Image
  image.onload = ->
    async.each Object.keys(colors), (color, next)->
      canvas = new Canvas 700, 700
      canvas.antialias = 'subpixel'
      ctx = canvas.getContext '2d'
      ctx.imageSmoothingEnabled = true

      left = (700 - image.width * scale * 0.5) / 2
      top = 700 - image.height * scale * 0.5 + 1
      ctx.drawImage(image, left, top, image.width * 0.5 * scale, image.height * 0.5 * scale)

      data = ctx.getImageData 0, 0, image.width, image.height
      if colors[color]
        colorize(data.data, colors[color])
        ctx.putImageData data, 0, 0

      out = fs.createWriteStream(target + color + '.png')
      stream = canvas.pngStream()
      stream.on('data', (chunk)-> out.write chunk)
      stream.on('end', -> out.end null, null, next)
    , done

  image.src = path

buildSingleSprite = (scale, path, imageInfo, target, done)->
  canvas = null
  ctx = null

  async.each [0...imageInfo.length], (layer, nextLayer)->
    unless imageInfo[layer] then return nextLayer()
    image = new Canvas.Image
    image.onload = ->
      unless canvas
        canvas = new Canvas 700, 700
        canvas.antialias = 'subpixel'
        ctx = canvas.getContext '2d'
        ctx.imageSmoothingEnabled = true

      left = (700 - image.width * scale * 0.5) / 2
      top = 700 - image.height * scale * 0.5 + 1

      ctx.drawImage(image, left, top, image.width * 0.5 * scale, image.height * 0.5 * scale)
      nextLayer()

    image.src = path + imageInfo[layer]
  , ->
    out = fs.createWriteStream(target)
    stream = canvas.pngStream()
    stream.on('data', (chunk)-> out.write chunk)
    stream.on('end', -> out.end null, null, done)

colorize = (data, color)->
  hue = color[0] / 360
  saturation = color[1] / 100
  lightness = color[2] / 100

  for i in [0..data.length - 3] by 4 when data[i + 3] isnt 0
    r = data[i]
    g = data[i + 1]
    b = data[i + 2]
    lum = rgbToLum r, g, b

    if lightness > 0
      lum *= 1 - lightness
      lum += 1 - (1 - lightness)
    else
      lum *= lightness + 1

    if saturation is 0
      r = lum
      g = lum
      b = lum
    else
      if lum <= 0.5
        n2 = lum * (1 + saturation)
      else
        n2 = lum + saturation - lum * saturation
      n1 = 2 * lum - n2

      r = hslValue n1, n2, hue * 6 + 2
      g = hslValue n1, n2, hue * 6
      b = hslValue n1, n2, hue * 6 - 2


    data[i] = Math.floor(r * 255)
    data[i + 1] = Math.floor(g * 255)
    data[i + 2] = Math.floor(b * 255)
  return

rgbToLum = (r, g, b)-> r * 0.2126 / 255 + g * 0.7152 / 255 + b * 0.0722 / 255

hslValue = (n1, n2, hue)->
  if hue > 6
    hue -= 6
  else if hue < 0
    hue += 6

  return if hue < 1
    n1 + (n2 - n1) * hue
  else if hue < 3
    n2
  else if hue < 4
    n1 + (n2 - n1) * (4 - hue)
  else
    n1
