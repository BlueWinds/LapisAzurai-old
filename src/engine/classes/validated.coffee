window.CopyOnCreate = class CopyOnCreate
  constructor: (data)->
    $.extend @, data

window.Validated = class Validated
  @schema =
    type: @
    properties: {}
    strict: true

  constructor: (data)->
    $.extend @, data
    @id or= Math.random()
    for key, value of @ when value instanceof CopyOnCreate
      @[key] = Object.create value
#       for property, item of @[key]
#         @[key][property] = new item

  validate: ->
    result = SchemaInspector.validate @constructor.schema, @
    unless result.valid
      console.log @
      throw new Error(@constructor.name + " is invalid: \n" + result.format())
