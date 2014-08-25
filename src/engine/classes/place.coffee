window.Place = class Place extends GameObject
  @schema:
    type: @
    strict: true
    properties:
      name:
        type: 'string'
      description:
        type: 'function'
      images:
        # Required images for every location
        properties:
          day: {}
          night: {}
          storm: {}
      jobs:
        type: Collection
        items:
          type: Job

  jobs: new Collection

  image: (tag)-> "<img src='#{@images[tag]}'>"

Game::map = new Collection
Game.schema.properties.map =
  type: Collection
  items:
    type: Place

Game.schema.properties.location =
  type: Place
