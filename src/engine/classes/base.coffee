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
    level = @constructor
    while !level.schema
      level = level.__super__?.constructor

    result = SchemaInspector.validate level.schema, @
    unless result.valid
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

  matches: (conditions)->
    if typeof conditions is 'string'
      return g.getItem(conditions) is @
    for key, condition of conditions when key not in ['path', 'optional']
      value = @
      for part in key.split('|')
        value = value[part]
      unless partMatches(value, condition)
        return false
    return true

partMatches = (value, condition)->
  unless value? or condition.optional
    return false
  if value >= condition.lt or value > condition.lte
    return false
  if value <= condition.gt or value < condition.gte
    return false
  if condition.eq? and value isnt condition.eq
    return false
  if condition.is
    if typeof condition.is is 'array'
      unless condition.is.some((c)-> value instanceof c)
        return false
    else unless value is condition.is or value instanceof conditions.is
      return false
  if condition.matches and not condition.matches(value)
    return false
  return true

window.Collection = class Collection
  constructor: (data, objects, path)->
    if objects
      objects.push @
      for key, value of data
        if isGameObjectClass value
          @[key] = new value(null, objects, path + '|' + key)
        else if value instanceof GameObject
          @[key] = value
        else if value instanceof Collection
          @[key] = new Collection value, objects, path + '|' + key
        else if typeof value is 'object' and value._
          _class = value._.split '|'
          @[key] = new window[_class[0]][_class[1]] value, objects, path + '|' + key
          delete @[key]._
        else
          @[key] = value
    else
      $.extend @, data

  Object.defineProperty @::, 'export',
    value: (ids, paths, path)->
      if @ in ids then return paths[ids.indexOf @]
      ids.push @
      paths.push path
      data = {}
      for key, value of @
        data[key] = value.export?(ids, paths, path + '|' + key) or value
        unless data[key]?
          delete data[key]
      return data

  Object.defineProperty @::, 'matches',
    value: (conditions)->
      for key, value of conditions
        target = if key[0] is '|' then g.getItem(key) else @[key]

        if not value
          if target then return false
        else if typeof value is 'string'
          unless target is g.getItem value then return false
        else
          unless target or value.optional then return false
          if target.matches
            unless target.matches(value) then return false
          else
            unless partMatches(target, value) then return false

      return @

  Object.defineProperty @::, 'fill',
    value: (conditions)->
      for key, value of conditions
        if key[0] is '|'
          continue
        else if typeof value is 'string'
          @[key] = g.getItem value
        else if value.path
          if item = g.getItem value.path
            @[key] = item
        else
          if g.last.context[key]
            @[key] = g.last.context[key]

      for key, value of conditions when value.fill
        @[key] = value.fill.call(@)

      return @

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
      index = 0
      while @[index] then index++
      @[index] = item
  Object.defineProperty @::, 'pop',
    value: ->
      index = 0
      while @[index + 1] then index++
      item = @[index]
      delete @[index]
      return item

  Object.defineProperty @::, 'shift',
    value: ->
      first = @[0]
      delete @[0]
      index = 0
      while @[index + 1]
        @[index] = @[index + 1]
        delete @[index + 1]
        index++
      return first

  Object.defineProperty @::, 'unshift',
    value: (item)->
      index = 0
      while @[index]
        [@[index], item] = [item, @[index]]
        index++
      @[index] = item

  Object.defineProperty @::, 'remove',
    value: (index)->
      while @[index + 1]
        @[index] = @[index + 1]
        index++
      delete @[index]

  Object.defineProperty @::, 'length',
    get: ->
      index = 0
      while @[index]
        index++
      return index
  Object.defineProperty @::, 'objectLength',
    get: ->Object.keys(@).length

  Object.defineProperty @::, 'filter',
    value: (compare)->
      results = new Collection
      for key, value of @
        if compare(value) then results[key] = value
      return results
