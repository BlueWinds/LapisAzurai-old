window.Place = class Place extends Contextual
  @schema: $.extend true, {}, Contextual.schema,
    type: @
    properties:
      name:
        type: 'string'
      description:
        type: 'function'
      images:
        # Required images for every location
        properties:
          port: {}
          business: {}
      people:
        type: 'object'
        items:
          type: Person
      jobs:
        type: 'object'
        items:
          type: Job

  toString: -> return @name

  people: new CopyOnCreate
  jobs: new CopyOnCreate

Game.schema.properties.location =
  type: Place

Game::map = new CopyOnCreate
Game.schema.properties.map =
  type: 'object'
  items:
    type: Place
