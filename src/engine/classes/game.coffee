stormStartChance = 0.02
stormEndChance = 0.75

window.Game = class Game extends GameObject
  @cargo: 100
  @schema:
    type: @
    properties:
      day:
        type: 'integer'
        gte: 0
      weather:
        type: 'string'
        match: /calm|storm/
    strict: true
  @passDay: [
    ->
      if @weather is 'calm' and Math.random() <= stormStartChance
        @weather = 'storm'
      else if @weather is 'storm' and Math.random() < stormEndChance
        @weather = 'calm'
    ->
      unless g.queue.length
        @queue.push new (g.location.constructor.port or Page.Port)
      g.queue.unshift new Page.NextDay
  ]

  constructor: (gameData)->
    objects = []
    super null, objects, ''
    for item in objects
      for key, value of item when typeof value is 'string' and value[0] is '|'
        item[key] = @getItem value
    unless gameData
      return
    # Now we recursively copy the data into our new clean game.
    recursiveCopy = (obj, data)=>
      for key, value of data when key isnt '_'
        if typeof value is 'object'
          if value._ and not obj[key]
            _class = value._.split '|'
            try
              obj[key] =  new window[_class[0]][_class[1]] {}, [], ''
            catch e
              console.error "Unable to find window.#{_class[0]}.#{_class[1]}"
          if obj[key] instanceof GameObject or obj[key] instanceof Collection
            recursiveCopy obj[key], value
          else
            obj[key] = value
        else if typeof value is 'string' and value[0] is '|'
          obj[key] = @getItem value
        else
          obj[key] = value

    recursiveCopy @, gameData

  export: ->
    super [], [], ''

  day: 0
  weather: 'calm'
  cargo: new Collection

  getItem: (path)->
    if typeof path is 'string'
      path = path.split '|'
      first = path.shift()
      if first then throw new Error(first + '|' + path.join('|') + ' is a bad path')
    target = @
    for part in path
      target = target?[part]
    return target

  passDay: ->
    @day++
    for event in Game.passDay
      event.call(@)
    return

  setGameInfo: ->
    element = $ '.nav'
    $('.day', element).html @day
    $('.money', element).html @officers.Nat.money
    wages = Math.sum((person.wages() for name, person of @officers))
    wages += Math.sum(person.wages() for name, person of @crew)
    $('.wages', element).html wages
    $('.progress-bar', element).css 'width', (Math.sumObject(g.cargo) * 100 / Game.cargo) + "%"
    cargo = Object.keys(g.cargo).map (item)->"<tr><td>#{g.cargo[item]}</td><td>#{item}</td></tr>"
    $('.cargo').tooltip('destroy').tooltip {
      placement: 'bottom'
      title: "<table class='table table-striped'>#{cargo.join "\n"}</table>"
      html: true
      template: '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner no-pad"></div></div>'
    }
    $('#game-info img').attr 'src', @location.images[if @weather is 'calm' then 'day' else 'storm']
    $('#game-info .description').html @location.description?() or @location.description

  startDay = 223
  startYear = 1271

  Object.defineProperty @::, 'year', {get: -> Math.floor((@day + startDay) / 360) + startYear}
  Object.defineProperty @::, 'dayOfYear', {get: -> (@day + startDay) % 360}
  Object.defineProperty @::, 'season', {get: -> seasons[Math.floor(@dayOfYear / 90)]}
  Object.defineProperty @::, 'dayOfSeason', {get: -> @dayOfYear % 90}
  Object.defineProperty @::, 'month', {get: -> months[Math.floor(@dayOfSeason / 30)]}
  Object.defineProperty @::, 'dayOfMonth', {get: -> @dayOfYear % 30}
  Object.defineProperty @::, 'date',
    get: -> "#{days[@dayOfMonth]} of #{@month} #{@season}, #{@year}"

  applyEffects: (effects, context)->
    if effects.add
      for key, value of effects.add
        parts = key.split '|'
        property = parts.pop()
        result = if typeof value is 'function' then new value else value

        if result.addAs then result.addAs property
        else @getItem(parts.join '|')[property] = result

    if effects.remove
      for key, value of effects.remove
        parts = key.split '|'
        property = parts.pop()

        result = @getItem(parts.join '|')[property]
        if result?.removeAs
          result.removeAs property
        else
          delete @getItem(parts.join '|')[property]
          # If it's inherited, we set it to "false" to mark it as actually gone.
          if @getItem(parts.join '|')[property]
            @getItem(parts.join '|')[property] = false

    if effects.cargo
      adding = {}
      for key, value of effects.cargo
        if typeof value is 'string'
          value = context[value]

        # Wait to add new cargo until we've removed everything (so we know we have space left)
        if value > 0
          positive[key] = value
        else
          g.cargo[key] += value
          unless g.cargo[key] > 0 then delete g.cargo[key]

      space = Game.cargo - Math.sumObject(g.cargo)
      for key, value of adding
        unless space then break
        g.cargo[key] or= 0
        g.cargo[key] += Math.min(space, value)
        space -= Math.min(space, value)

    if effects.money
      g.officers.Nat.money += effects.money[0]
      g.money.push {amount: effects.money[0], reason: effects.money[1], day: g.day}

days = ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th', '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th', '19th', '20th', '21st', '22nd', '23rd', '24th', '25th', '26th', '27th', '23rd', '24th', '25th', '26th', '27th', '28th', '29th', '30th']
months = ['Rising', 'Ascendant', 'Descending']
seasons = ['Wood', 'Fire', 'Earth', 'Water']
