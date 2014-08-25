isGameObjectClass = (obj)-> typeof obj is 'function' and obj.prototype?.valid

window.GameObject = class GameObject
  @schema:
    strict: true

  constructor: (data, objects, path)->
    objects?.push @
    for key, value of @ when key isnt 'constructor'
      if value instanceof Collection
        @[key] = new Collection value, objects, path + '|' + key
      else if isGameObjectClass value
        @[key] = new value null, objects, path + '|' + key
    for key, value of data
      @[key] = value

  className: ->
    target = @constructor
    until target.schema.type is target
      target = target.__super__.constructor
    if target is @constructor
      return target.name
    return target.name + '|' + @constructor.name

  valid: ->
    result = SchemaInspector.validate @constructor.schema, @
    unless result.valid
      console.log @
      throw new Error(@constructor.name + " is invalid: \n" + result.format())
    return true

  export: (ids, paths, path)->
    if @ in ids then return paths[ids.indexOf @]
    ids.push @
    paths.push path

    data = {
      '_': @className()
    }
    for own key, value of @
      if value instanceof Collection or value instanceof GameObject
        value = value.export(ids, paths, path + '|' + key)
      if value? and typeof value isnt 'function'
        data[key] = value
    return data

window.Collection = class Collection
  constructor: (data, objects, path)->
    if objects
      objects.push @
      for key, value of data
        if isGameObjectClass value
          @[key] = new value(null, objects, path + '|' + key)
        else if value instanceof GameObject
          @[key] = value
        else if typeof value is 'object'
          _class = value._.split '|'
          delete value._
          @[key] = new window[_class[0]][_class[1]] value, objects, path + '|' + key
    else
      $.extend @, data

  Object.defineProperty @::, 'export',
    value: (ids, paths, path)->
      data = {}
      for key in @keys()
        data[key] = @[key].export(ids, paths, path + '|' + key)
        unless data[key]?
          delete data[key]
      return data

  Object.defineProperty @::, 'keys',
    value: ->
      list = for key, value of @ when value instanceof GameObject
        key
      return list.sort()
  Object.defineProperty @::, 'asArray',
    value: ->
      list = []
      i = 0
      while @[i]
        list.push @[i]
        i++
      return list
  Object.defineProperty @::, 'push',
    value: (item)->
      key = 0
      while @[key] then key++
      @[key] = item
  Object.defineProperty @::, 'shift',
    value: ->
      first = @[0]
      delete @[0]
      key = 0
      while @[key + 1]
        @[key] = @[key + 1]
        key++
      return first
  Object.defineProperty @::, 'unshift',
    value: (item)->
      index = 0
      while @[index]
        [@[index], item] = [item, @[index]]
        index++
      @[index] = item

  Object.defineProperty @::, 'length',
    get: ->
      key = 0
      while @[key]
        key++
      return key

window.Game = class Game extends GameObject
  @schema:
    type: @
    properties:
      content:
        type: 'string'
        pattern: /sfw|nsfw|lewd/
      day:
        type: 'integer'
        gte: 0
      weather:
        type: 'string'
        match: /calm|storm/
    strict: true
  @passDay: []

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
      for key, value of data
        if typeof value is 'object'
          if value._ and not obj[key]
            _class = value._.split '|'
            obj[key] =  new window[_class[0]][_class[1]] {}, [], ''
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

  content: 'sfw'
  animation: true
  day: 0
  weather: 'calm'

  getItem: (path)->
    if typeof path is 'string'
      path = path.split '|'
      first = path.shift()
      if first then throw new Error(first + '|' + path.join('|') + ' is a bad path')
    target = @
    for part in path
      target = target[part]
    unless target
      console.error @
      throw new Error 'Unable to find ' + path
    return target

  passDay: ->
    @day++
    for event in Game.passDay
      event.call(@)
    return

  setGameInfo: ->
    element = $ '#game-info'
    $('img', element).attr 'src', @location.images[if @weather is 'calm' then 'day' else 'storm']
    $('.location', element).html @location.name
    $('.day', element).html @day
    $('.crew-count', element).html Object.keys(@crew).length
    $('.money', element).html "<span>#{@crew.Nat.money}</span>"
    $('.wages', element).html "<span>#{Math.sum(person.wages() for name, person in @crew)}</span>"
    $('.description', element).html @location.description()
