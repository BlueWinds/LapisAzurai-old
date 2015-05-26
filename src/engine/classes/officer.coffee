injuredThreshold = -6

Person.stats.endurance = "Endurance<br>How much energy this person has when fully rested."
Person.stats.energy = "Energy<br>When this reaches 0, a person cannot perform any jobs except resting."

window.Officer = class Officer extends Person
  @schema:
    type: @
    strict: true
    properties:
      name:
        type: 'string'
      gender:
        type: 'string'
        pattern: /^[mf]$/
      text:
        type: 'string'
        pattern: /^#[0-9A-F]{6}$/
      # Optional color names for each layer, looked up in {PersonClass}.colors
      color:
        type: 'array'
        items:
          type: ['string', 'boolean']
        optional: true
      description:
        # description can be a string so that random characters can have one chosen for them.
        type: ['string', 'function']
  for stat in @stats
    @schema.properties[stat] = {type: 'number', gte: 0, lte: 100}

  happiness: 0
  business: 0
  diplomacy: 0
  sailing: 0
  combat: 0
  energy: 0
  endurance: 0

  Object.defineProperty @::, 'sick',
    get: -> @energy <= injuredThreshold

  renderBlock: (key, classes = '')->
    classes += ' officer'
    if @energy <= injuredThreshold then classes += ' injured'
    super(key, classes)


Game.schema.properties.officers =
  type: Collection
    items:
      type: Officer
Game::officers = new Collection
