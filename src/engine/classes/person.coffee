color =
  type: 'array'
  items: [
    {type: 'number', gte: -180, lte: 180}
    {type: 'number', gte: -100, lte: 100}
    {type: 'number', gte: -100, lte: 100}
  ]
  exactLength: 3
  optional: true

imgLayer =
  type: ['string', 'array']
  optional: true
  items: [
    {type: 'string'} # A reference to the file
    {type: 'integer', gte: 0} # x-start
    {type: 'integer', gte: 0} # y-start
    {type: 'integer', gte: 1} # width
    {type: 'integer', gte: 1} # height
  ]

window.Person = class Person extends Validated
  @stats: ['business', 'diplomacy', 'stealth', 'combat', 'happiness', 'endurance']
  @mainStats: ['business', 'diplomacy', 'stealth', 'combat']
  @imgLayers: ['base', 'skin', 'eyes', 'hair', 'top']
  @schema: $.extend true, {}, Validated.schema,
    type: @
    properties:
      name:
        type: 'string'
      gender:
        type: 'string'
        pattern: /^[mf]$/
      level:
        type: 'integer'
        gte: 1
        lte: 100
      growth: {}
      color:
        type: 'object'
        strict: true
        properties:
          text:
            type: 'string'
            pattern: /^#[0-9A-F]{6}$/
          # Optional HSL arrays to recolor images
          hair: color
          eyes: color
          skin: color
      images:
        type: 'object'
        items:
          # Can be either a single image path, or an object containing layers
          type: ['string', 'object']
          exact: true
          someKeys: @imgLayers
          properties: {}
  for stat in @stats
    @schema.properties[stat] = {type: 'number', gte: -100, lte: 100}
    @schema.properties.growth[stat] = {type: 'number', gte: -1, lte: 10, optional: true}
  for layer in @imgLayers
    @schema.properties.images.items[layer] = imgLayer

  @base: {}
  constructor: (base, data, type = Person)->
    return super base, data, type

  renderedCache = {}
  image: (label, classes = '', cache = true)->
    src = @images[label]
    if typeof src is 'string'
      return "<div class='person #{classes}'><img src='#{src}'></div>"
    unless src
      throw new Error "Can't find image \"#{label}\" for #{@}"

    unless cache and renderedCache[@id]?[label]
      renderedCache[@id] or= {}
      layers = []
      for layer in Person.imgLayers when src[layer]
        layers.push {
          src: src[layer]
          color: @color[layer]
        }
      renderedCache[@id][label] = renderLayers(layers)

    return "<div class='#{classes} person'>" + renderedCache[@id][label] + '</div>'

  match: (conditions)->
    if conditions.base and not @ instanceof conditions.base
      return false
    if conditions.path and (@ isnt g.getItem conditions.path)
      return false
    for stat in Person.stats
      if conditions[stat]?.gte > @[stat]
        return false
      if conditions[stat]?.lte < @[stat]
        return false
    return @

  renderBlock: (context, key, classes = '')->
    stats = for stat in Person.mainStats
      "<span class='#{stat}'>#{@[stat]}</span>"

    return """<div data-key="#{key}" class="person-info #{classes}"
    style="color: #{@color.text};">
      <div class="person-name">#{@name}</div>
      <div class="person-level">#{@level}</div>
      <div class="person-stats">#{stats.join ''}</div>
    </div>"""

  toString: -> return @name

Game.schema.properties.player =
  type: Person

Game.schema.properties.crew =
  type: 'object'
  items:
    type: Person

conditions = Contextual.schema.properties.context.items.properties
for stat in Person.stats
  conditions[stat] =
    type: 'object'
    strict: true
    optional: true
    properties:
      gte: {type: 'number'}
      lte: {type: 'number'}

Person.imageLocations = (base, width, height, labels)->
  images = {}
  for i, label of labels
    images[label] =
      base: [base + 'Base.png', 0, 0, width, height]
      skin: [base + 'Skin.png', i * width, 0, width, height]
      eyes: [base + 'Eyes.png', i * width, 0, width, height]
      hair: [base + 'Hair.png', i * width, 0, width, height]
      top: [base + 'Top.png', i * width, 0, width, height]
  return images

$ ->
  srcs = {}
  for id, person of Person when person?.prototype instanceof Person
    for label, image of person::images when typeof image is 'object'
      for layer, value of image when typeof value[0] is 'string'
        src = value[0]
        unless srcs[src]
          img = new Image
          img.src = src
          srcs[src] = img
        value[0] = srcs[src]
  return

renderLayers = (layers)->
  width = layers[0].src[3]
  height = layers[0].src[4]
  canvas = $ "<canvas width='#{width}' height='#{height}'></canvas>"
  baseCtx = canvas[0].getContext '2d'

  for {src, color} in layers
    img = if color
      color =
        hue: color[0]
        saturation: color[1]
        lightness: color[2]
      Pixastic.process(src[0], "hsl", color)
    else
      src[0]
    baseCtx.drawImage(
      img,
      src[1], src[2], # x, y
      src[3], src[4], # width, height
      0, 0, width, height # paste onto full canvas
    )
  return "<img src='#{canvas[0].toDataURL()}'>"
