window.Trait = class Trait extends GameObject
  @schema:
    strict: true
    type: @
    properties:
      description:
        type: ['string', 'function']
        description: 'A string describing the flavor of the trait, or a function taking (person) returning the same.'

  renderBlock: (person)->"""<div class="trait">
    <div class="name">#{@constructor.name}</div>
    <div class="description">#{@description?(person) or @description}</div>
  </div>"""

  for stat of Person.stats
    @schema[stat] =
      type: ['integer', 'function']
      gte: -100
      lte: 100
      description: "An amount to add to the stat, or a function that takes (object, context, number) and returns an adjusted number."
    @schema[stat + 'Set'] =
      type: ['integer', 'function']
      gte: -10
      lte: 10
      description: "A rate to multiply changes to the stat by, or a function that takes (object, delta) and returns a new delta."

Person.schema.properties.traits =
  type: Collection
  optional: true
  items:
    type: Trait

Person::get = (stat, context)->
  value = @[stat]
  if @traits
    for key, trait of @traits when trait[name]
      value = if typeof trait[name] is 'function'
        trait[name](@, context, value)
      else
        value + trait[name]
  return value

Person::add = (stat, amount)->
  if @traits
    for key, trait of @traits when trait[stat + 'Set']
      amount = if typeof trait[name + 'Set'] is 'function'
        trait[name + 'Set'](@, amount)
      else
        amount * trait[name + 'Set']
  @[stat] += amount
  if stat is 'energy'
    @energy = Math.min @energy, @endurance
  else
    @[stat] = Math.max 0, Math.min(@[stat], 100)
  return
