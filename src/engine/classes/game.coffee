classes = {}
$ ->
  # Builds a list of all items like Job.hireCrew, so that they can be found easily when loading a game.
  for name, _class of window when _class?.prototype instanceof Validated
    for key, value of _class when value.prototype instanceof _class
      classes[key] = value
  classes.Game = Game

window.Game = class Game extends Validated
  @schema: $.extend true, {}, Validated.schema,
    type: @
    properties:
      day:
        type: 'integer'
        gte: 0

  constructor: (data)->
    if typeof data is 'string'
      data = jsyaml.safeLoad data
      ids = {}

      gatherIds = (obj)->
        for key, val of obj when typeof val is 'object'
          obj[key] = gatherIds val
        if typeof obj.constructor is 'string'
          _class = classes[obj.constructor]
          delete obj.constructor
          obj = ids[obj.id] = new _class obj
        return obj

      replaceRefs = (obj)->
        for own key, val of obj
          if typeof val is 'string' and val.match /^~id~/
            id = val.match(/(0\.[0-9]+)/)[1]
            obj[key] = ids[id]
          else if typeof val is 'object'
            replaceRefs val
        return obj

      data = replaceRefs gatherIds(data)

    super data

  prepareSave: ->
    ids = {}

    deepCopy = (obj)->
      copy = if obj instanceof Array then [] else {}
      if obj instanceof Validated
        if ids[obj.id]
          return '~id~' + obj.id
        copy.constructor = obj.constructor.name
        if obj.constructor.parent then copy.constructor
        ids[obj.id] = copy
      for own key, value of obj
        if typeof value is 'object'
          copy[key] = deepCopy value
        # Don't copy anything that hasn't been changed from the prototype
        else if value isnt obj.__proto__[key]
          copy[key] = value
      return copy

    return deepCopy @

  getItem: (path)->
    target = @
    for link in path.split '|'
      target = target[link]
    return target

  dump: -> jsyaml.safeDump @prepareSave()
