fs = require 'fs'
async = require('async')
Canvas = require('canvas')

grunt = null

module.exports = (g) ->
  grunt = g
  grunt.loadNpmTasks 'grunt-debug'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-imagine'

  config = {
    coffee:
      compile:
        files: 'game/compiled.js': [
          # First the game engine
          'src/engine/feature-detect.coffee'
          'src/engine/util.coffee'
          'src/engine/classes/base.coffee'
          'src/engine/classes/page.coffee'
          'src/engine/classes/person.coffee'
          'src/engine/classes/trait.coffee'
          'src/engine/classes/job.coffee'
          'src/engine/classes/place.coffee'
          'src/engine/load.coffee'

          'src/engine/screens/port.coffee'
          'src/engine/screens/hireCrew.coffee'

          # Then the content
          'src/content/traits/basicStats.coffee'

          'src/content/people/Natalie/_Natalie.coffee'
          'src/content/people/James/_James.coffee'
          'src/content/people/Guildmaster/_Guildmaster.coffee'
          'src/content/people/Nobles/_Nobles.coffee'
          'src/content/people/Vailia/_Crew.coffee'

          'src/content/locations/Ship/_Ship.coffee'
          'src/content/locations/Vailia/_Vailia.coffee'
#           'src/content/locations/Kantis/_Kantis.coffee'

          'src/content/intro/intro.coffee'

        ]
        options:
          join: true
          sourceMap: true
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

  grunt.registerTask 'draw-sprites', ->
    done = @async()
    createAllSprites null, done

  grunt.registerTask 'validate', validateAll

  grunt.registerTask 'compile', ['coffee', 'validate', 'copy:css']
  grunt.registerTask 'sprites', ['coffee', 'draw-sprites']
  grunt.registerTask 'lib', ['uglify', 'copy:libs', 'copy:images']
  grunt.registerTask 'full-build', ['lib', 'coffeelint', 'compile', 'sprites']
  grunt.registerTask 'default', ['lib', 'coffeelint', 'compile', 'watch']


loadGameObjects = ->
  html = fs.readFileSync('index.html').toString()

  unless global.window
    window = global.window = {}
    global.$ = ->
    global.$.extend = ->

    global.Canvas = Canvas
    global.Image = Canvas.Image
    require('./game/compiled')

  return global.window

###
  Valdiate all game objects
###

validateAll = ->
  global.SchemaInspector = require './src/lib/schema-inspector'
  window = loadGameObjects()
  for name, _class of window when _class.schema and name isnt 'Game'
    for name, item of _class when item.schema
      (new item).valid()
  (new window.Game).valid()
  return true

###
  Sprite generation functions
###

createAllSprites = (names, finished)->
  try
    fs.mkdirSync('game/sprites')
  catch e
    null

  Person = loadGameObjects().Person

  people = for name, person of Person
    unless person.prototype instanceof Person and person.images then continue
    person

  names or= people.map (p)->p::name
  async.eachSeries people, (person, nextPerson)->
    unless person::name and person::name in names
      return nextPerson()
    console.log person::name
    sampleImage = new Canvas.Image
    sampleImage.onload = ->
      unless person.colors # This image doesn't need to be colorized
        return buildSingleSprite(person, sampleImage, nextPerson)

      colorCount = for layer in person.colors
        Object.keys(layer or {}).length

      size =
        width: sampleImage.width * person.images.normal.length # Each layer gets its own column
        height: sampleImage.height * Math.max.apply(null, colorCount) # Each color gets its own row
      async.eachSeries Object.keys(person.images), (image, nextSheet)-> # Each image gets its own spritesheet
        if image is 'path'
          return nextSheet()
        console.log '  ' + image
        imageInfo = person.images[image]

        createColorizedSprites size, person.colors, person.images.path, imageInfo, (sprite)->
          scale = 400 / sampleImage.width
          scaled = new Canvas(400 * person.images.normal.length, size.height * scale)
          scaled.getContext('2d').drawImage(sprite, 0, 0, 400 * person.images.normal.length, size.height * scale)

          spritePath = "game/sprites/#{person.name}-#{image}.png"
          out = fs.createWriteStream(spritePath)
          stream = scaled.pngStream()
          stream.on('data', (chunk)-> out.write chunk)
          stream.on 'end', ->
            out.end null, null, nextSheet
      , nextPerson
    sampleImage.src = person.images.path + person.images.normal[0]

  , finished

createColorizedSprites = (spriteSize, colors, path, imageInfo, done)->
  canvas = new Canvas(spriteSize.width, spriteSize.height)
  mainCtx = canvas.getContext('2d')

  async.each imageInfo, (layer, next)->
    image = new Canvas.Image
    image.onload = ->
      spriteX = image.width * imageInfo.indexOf(layer)
      spriteY = 0
      for color in colors[imageInfo.indexOf(layer)] or [[]]
        colorizedCanvas = new Canvas(image.width, image.height)
        colorCtx = colorizedCanvas.getContext('2d')
        colorCtx.drawImage(image, 0, 0)

        data = colorCtx.getImageData(0, 0, image.width, image.height)
        if color[1]?
          colorize(data.data, color[1..])

        mainCtx.putImageData(data, spriteX, spriteY)
        # Move down before copying the next image
        spriteY += image.height
      next()
    image.src = path + layer

  done canvas

buildSingleSprite = (person, sampleImage, done)->
  console.log '  ', person::name
  async.each Object.keys(person.images), (image, nextImage)-> # Each image gets its own spritesheet
    if image is 'path'
      return nextImage()
    imageInfo = person.images[image]

    canvas = new Canvas(sampleImage.width, sampleImage.height)
    mainCtx = canvas.getContext('2d')

    async.eachSeries imageInfo, (layer, nextLayer)->
      layerImage = new Canvas.Image
      path = person.images.path + layer
      try
        fs.statSync path
      catch e
        grunt.log.error "Missing file #{path} for #{person::name}"
        return nextLayer()
      layerImage.onload = ->
        mainCtx.drawImage(layerImage, 0, 0)
        nextLayer()
      layerImage.src = person.images.path + layer
    , ->
      scale = 400 / sampleImage.width
      scaled = new Canvas(400, sampleImage.height * scale)
      scaled.getContext('2d').drawImage(canvas, 0, 0, 400, sampleImage.height * scale)

      spritePath = "game/sprites/#{person.name}-#{image}.png"
      out = fs.createWriteStream(spritePath)
      stream = scaled.pngStream()
      stream.on('data', (chunk)-> out.write chunk)
      stream.on 'end', ->
        out.end null, null, nextImage
  , done

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
