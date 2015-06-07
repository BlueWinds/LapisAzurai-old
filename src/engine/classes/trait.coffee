window.Trait = class Trait extends GameObject
  @schema:
    strict: true
    type: @
    properties:
      label:
        type: 'string'
        optional: true
        description: 'How this trait is labeled for the player. If absent, the class name is used.'
      description:
        type: ['string', 'function']
        description: 'A string describing the flavor of the trait, or a function taking (person) returning the same.'
      daily:
        type: 'function'
        description: 'A function taking (person), called once per day that passes.'
        optional: true
      eats:
        type: 'integer'
        description: 'Adds (or subtracts) from how much the person eats. {eats: 3} means the person eats as much as 4 normal people (3 extra servings) while sailing.'
        optional: true
  # A subclass can also have @randomPoints, in which case it can be assigned to randomly generated sailors.
  # If it does, it can also have @opposed, which is an array of strings that the trait can't be paired with.

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

  renderBlock: (person)->"""<div class="trait">
    <div class="name">#{@label or @constructor.name}</div>
    <div class="description">#{@description?(person) or @description}</div>
  </div>"""

Game.passDay.push ->
  for name, person of g.officers
    for key, trait of person.traits
      trait.daily?(person)
  for name, person of g.crew
    for key, trait of person.traits
      trait.daily?(person)

Person.schema.properties.traits =
  type: Collection
  optional: true
  items:
    type: Trait

Person::traits = new Collection

Person::get = (stat, context)->
  value = if stat is 'eats' then 1
  else if @[stat]? then @[stat]
  else throw new Error "#{@} doesn't have the stat #{stat}"

  for key, trait of @traits when trait[stat]
    if typeof trait[stat] is 'function'
      value = trait[stat](@, context, value)
    else
      value += trait[stat]
  return value

Person::add = (stat, amount)->
  for key, trait of @traits when trait[stat + 'Set']
    amount = if typeof trait[stat + 'Set'] is 'function'
      trait[stat + 'Set'](@, amount)
    else
      amount * trait[stat + 'Set']

  @[stat] += amount
  # Randomly round non-whole number stats
  @[stat] = Math.floor(@[stat]) + (Math.random() < @[stat] % 1)
  if stat is 'energy'
    @energy = Math.min @energy, @endurance
  else
    @[stat] = Math.max 0, Math.min(@[stat], 100)
  return
