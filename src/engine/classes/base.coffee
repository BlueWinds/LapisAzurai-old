isGameObjectClass = (obj)-> typeof obj is 'function' and obj.prototype?.valid

window.GameObject = class GameObject
  @schema:
    strict: true

  constructor: (data, objects, path)->
    objects?.push @
    for key, value of @ when key isnt 'constructor'
      if value instanceof Collection
        @[key] = Object.create(@[key])
        if objects
          @[key].init(value, objects, path + '|' + key)
      else if isGameObjectClass value
        @[key] = new value null, objects, path + '|' + key
    for key, value of data
      if @[key] instanceof Collection
        $.extend(@[key], value)
      else
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
    while not level.schema
      level = level.__super__?.constructor

    result = SchemaInspector.validate level.schema, @
    unless result.valid
      _class = @constructor.__super__.constructor.name
      throw new Error(_class + " " + @constructor.name + " is invalid: \n" + result.format())
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
        if typeof data[key] is 'object' and $.isEmptyObject(data[key])
          delete data[key]
    return data

  matches: (conditions)->
    if typeof conditions is 'string'
      return g.getItem(conditions) is @
    return partMatches(@, conditions)

partMatches = (value, condition)->
  unless value? or condition.optional
    return false
  if value >= condition.lt or value > condition.lte
    return false
  if value <= condition.gt or value < condition.gte
    return false
  if condition.eq?
    if condition.eq instanceof Array
      unless condition.eq.some((c)-> value is c)
        return false
    else if value isnt condition.eq
      return false
  if condition.is
    if condition.is instanceof Array
      unless condition.is.some((c)-> value instanceof c)
        return false
    else unless value is condition.is or value instanceof condition.is
      return false
  if condition.matches and not condition.matches(value)
    return false
  return true

simpleMatch = (parent, child)->
  if parent is child
    return true
  unless parent and child
    return false
  for key, value of parent
    if child[key] isnt value
      return false
  for key, value of child
    if parent[key] isnt value
      return false

  return true

window.Collection = class Collection
  constructor: (data)->
    $.extend @, data

  Object.defineProperty @::, 'init',
    value: (data, objects, path)->
      objects.push @
      for key, value of data
        if isGameObjectClass value
          @[key] = new value(null, objects, path + '|' + key)
        else if value instanceof GameObject
          @[key] = value
        else if typeof value is 'object' and value._
          _class = value._.split '|'
          @[key] = new window[_class[0]][_class[1]] value, objects, path + '|' + key
          delete @[key]._
        else
          @[key] = value

  Object.defineProperty @::, 'export',
    value: (ids, paths, path)->
      if @ in ids then return paths[ids.indexOf @]
      ids.push @
      paths.push path
      data = {}
      proto = Object.getPrototypeOf(@)

      for key, value of @
        data[key] = value.export?(ids, paths, path + '|' + key) or value
        unless data[key]?
          delete data[key]
        else
          try
            if simpleMatch(proto[key], data[key])
              delete data[key]
          catch e
            console.log key, proto, data
            throw e
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
          if target?.matches
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

  Object.defineProperty @::, 'reArray',
    value: (index)->
      values = []
      for key in Object.keys(@)
        values.push @[key]
        delete @[key]
      $.extend @, values

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

  Object.defineProperty @::, 'indexOf',
    value: (item)->
      for key, value of @
        if value is item then return key
      return -1
