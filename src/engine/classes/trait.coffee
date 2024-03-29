window.Trait = class Trait extends GameObject
  @schema:
    strict: true
    type: @
    properties:
      label:
        type: ['string', 'function']
        optional: true
        description: 'How this trait is labeled for the player. If absent, the class name is used. A function is invoked with the person as an argument, and should return a string.'
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
      description: "An amount to add to the stat, or a function that takes (object, number) and returns an adjusted number."
    @schema[stat + 'Set'] =
      type: ['integer', 'function']
      gte: -10
      lte: 10
      description: "A rate to multiply changes to the stat by, or a function that takes (object, delta) and returns a new delta."

  renderBlock: (person)->"""<div class="trait">
    <div class="name">#{@label?(person) or @label or @constructor.name}</div>
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

baseRate =
  eats: 1
  repairRate: 0
  luxuryHappiness: 0
  shipyardPay: 0
  restEnergy: 0
  navigator: 0
  cargo: 0

genderCount = (gender)->
  count = g.crew.filter((p)-> p.gender is gender).objectLength
  return count + g.officers.filter((p)-> p.gender is gender).objectLength

Person::get = (stat)->
  value = if baseRate[stat]? then baseRate[stat]
  else if @[stat]? then @[stat]
  else throw new Error "#{@} doesn't have the stat #{stat}"

  if Person.stats[stat] and @traits?.Slut
    value += @traits.Slut.bonus * genderCount(if @gender is 'm' then 'f' else 'm')

  if Person.stats[stat] and @traits?.GaySlut
    value += @traits.GaySlut.bonus * (genderCount(@gender) - 1)

  for key, trait of @traits when trait[stat]
    if typeof trait[stat] is 'function'
      value = trait[stat](@, value)
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
