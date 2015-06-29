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

        if not value then return not target
        if typeof value is 'string' then return target is g.getItem value

        if target?.matches and not target.matches(value) then return false
        if not target then return value.optional

        unless partMatches(target, value) then return false

      return @

  Object.defineProperty @::, 'fill',
    value: (conditions, last = g.last?.context)->
      for key, value of conditions
        if key[0] is '|'
          continue
        else if typeof value is 'string'
          @[key] = g.getItem value
        else if value.path
          if item = g.getItem value.path
            @[key] = item
        else
          if last[key]
            @[key] = last[key]

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
      index = @length
      for item in arguments
        @[index] = item
        index++
      return @

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
      if typeof index is 'string' then index = parseInt(index, 10)

      unless typeof index is 'number'
        index = @indexOf(index)
        if index < 0 then throw new Error 'Index not found'

      while @[index + 1]
        @[index] = @[index + 1]
        index++
      delete @[index]
      @reArray()

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
    get: -> Object.keys(@).length

  Object.defineProperty @::, 'filter',
    value: (compare)->
      results = new Collection
      for key, value of @
        if compare(value) then results[key] = value
      return results

  Object.defineProperty @::, 'indexOf',
    value: (item)->
      for key, value of @
        if value is item then return Number(key)
      return -1

  Object.defineProperty @::, 'findIndex',
    value: (compare)->
      for key, value of @
        if compare(value, key) then return key
      return

  Object.defineProperty @::, 'find',
    value: (compare)-> @[@.findIndex compare]

Collection.partMatches = partMatches = (value, condition)->
  unless Collection.numericComparison(value, condition) then return false

  if condition.is and not Collection.oneOf(value, condition.is) then return false
  if condition.isnt and Collection.oneOf(value, condition.isnt) then return false

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

Collection.numericComparison = (target, val)->
  if target >= val.lt or target > val.lte then return false
  if target <= val.gt or target < val.gte then return false

  if val.eq?
    if val.eq instanceof Array
      unless val.eq.some((c)-> target is c)
        return false
    else if target isnt val.eq
      return false
  return true

Collection.oneOf = (target, items)->
  if items instanceof Array then return items.some((c)-> target is c or target instanceof c)
  return target is items or (typeof items is 'function') and target instanceof items
