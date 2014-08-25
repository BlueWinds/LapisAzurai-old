window.Person = class Person extends GameObject
  @stats: ['happiness', 'business', 'diplomacy', 'stealth', 'combat', 'endurance', 'fatigue']
  @mainStats: ['business', 'diplomacy', 'stealth', 'combat']
  @imgLayers: ['base', 'skin', 'eyes', 'hair', 'top']
  @schema:
    type: @
    strict: true
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
      money:
        type: 'integer'
        optional: true
      text:
        type: 'string'
        pattern: /^#[0-9A-F]{6}$/
      # Optional color names for each layer, looked up in {PersonClass}.colors
      color:
        type: 'array'
        items:
          type: 'string'
        optional: true
      description:
        # description can be a string so that random characters can have one chosen for them.
        type: ['string', 'function']
  for stat in @stats
    @schema.properties[stat] = {type: 'number', gte: 0, lte: 100}
  for stat in @mainStats
    @schema.properties[stat + 'Growth'] = {type: 'number', gte: 0, lte: 10, optional: true}

  # Each Person subclass should have @images and optionally @colors.

  happiness: 0
  business: 0
  businessGrowth: 0
  diplomacy: 0
  diplomacyGrowth: 0
  stealth: 0
  stealthGrowth: 0
  combat: 0
  combatGrowth: 0
  fatigue: 0
  endurance: 0
  level: 1
  description: 'If you see this in-game, it is a bug.'
  text: '#FFFFFF'

  constructor: (data, objects, path, imagesReady)->
    Object.defineProperty @, 'imgCache', {value: {}, enumerable: false}
    Object.defineProperty @, 'spriteCache', {value: {}, enumerable: false}
    if window.document
      for image of @constructor.images when image isnt 'path'
        @spriteCache[image] = sprite = new Image
        sprite.src = "game/sprites/#{@name}-#{image}.png"
        $(sprite).load Game.waitForInit()
    super data, objects, path

  image: (label, classes = '', useCache = true)->
    src = @constructor.images[label]
    if typeof src is 'string'
      return "<div class='person #{classes}'><img src='#{src}'></div>"
    unless src
      throw new Error "Can't find image '#{label}' for #{@}"

    unless @imgCache[label] and useCache
      if @constructor.colors
        layers = []
        colorCount = @constructor.colors.map (l)->l.length or 1
        layerHeight = @spriteCache[label].height / Math.max.apply(@, colorCount)
        for layer, path of src
          colors = @constructor.colors[layer]
          y = if colors and @color
            colors.findIndex (color)=> @color[layer] is color[0]
          else
            0
          if y is -1 then throw new Error
          layers.push {
            x: layer * 400
            y: y * layerHeight
          }
        @imgCache[label] = renderLayers @spriteCache[label], layers, layerHeight
        unless @imgCache[label].length > 10
          delete @imgCache[label]
      else
        @imgCache[label] = @spriteCache[label].src

    return "<div class='#{classes} person'><img src='#{@imgCache[label]}'></div>"

  renderBlock: (key, classes = '')->
    stats = for stat in Person.stats
      "<span class='#{stat}'>#{@[stat]}</span>"
    stats.push """<span class='money'>
      <span class="wages" title="Weekly Wages">#{@wages()}</span>
      #{if @money? then "<span class='savings' title='Total Savings'>" + @money + "</span>" else ''}
    </span>"""
    traits = for trait in (@traits?.keys() or [])
      @traits[trait].renderBlock(@)

    return """<div data-key="#{key}" class="person-info #{classes}">
      <div class="name" style="color: #{@text};">#{@name}</div>
      <div class="level">#{@level}</div>
      <div class="stats">#{stats.join ''}</div>
      <div class="full">
        <div class="name">#{@name}</div>
        <div class="level">#{@level}</div>
        <div class="stats">#{stats.join ''}</div>
        #{@image 'normal'}
        <div class="description">#{@description?() or @description}</div>
        <div class="traits">#{traits.join ''}</div>
      </div>
    </div>"""

  toString: ->@name

  wages: ->
    wage = @level / 10
    for stat in Person.mainStats
      wage += @[stat] / 30
    return Math.round wage

  isStory: -> @name is @constructor::name

Game.schema.properties.crew =
  type: Collection
  items:
    type: Person
Game.schema.properties.people =
  type: Collection
  items:
    type: Person
Game::crew = new Collection
Game::people = new Collection

$ ->
  c = $ '#content'
  # Bail out if we're not in the live game page
  unless c.length then return

  c.on 'mouseenter', '.person-info', ->
    parentWidth = $(@).parent().width()
    if $(@).position().left < parentWidth / 2
      $('.full', @).removeClass 'right'
    else
      $('.full', @).addClass 'right'


renderLayers = (sprite, layers, height)->
  baseCanvas = $ "<canvas width='400' height='#{height}'></canvas>"
  baseCtx = baseCanvas[0].getContext '2d'

  for {x, y} in layers
    baseCtx.drawImage(
      sprite,
      x, y, 400, height, # source x, y, width, height
      0, 0, 400, height # destination x, y, width, height
    )

  return baseCanvas[0].toDataURL()
