window.Trait = class Trait extends Validated
  @schema: $.extend true, {}, Validated.schema,
    type: @
    properties:
      text:
        type: ['string', 'function']
        description: 'A string describing the flavor of the trait, or a function taking (person) returning the same.'

  constructor: (base, data, type = Trait)->
    return super base, data, type

for key in Person.stats
  Trait.schema[key] =
    type: ['integer', 'function']
    gte: -100
    lte: 100
    description: "An amount to add to the stat, or a function that takes (object, context, number) and returns an adjusted number."
  Trait.schema[key + 'Set'] =
    type: ['integer', 'function']
    gte: -10
    lte: 10
    description: "A rate to multiply changes to the stat by, or a function that takes (object, delta) and returns a new delta."

Person::get = (stat, context)->
  value = @[stat]
  if @traits
    for trait in @traits when trait[name]
      value = if typeof trait[name] is 'function'
        trait[name](@, context, value)
      else
        value + trait[name]
  return value

Person.schema.properties.traits =
  type: 'array'
  optional: true
  items:
    type: Trait
