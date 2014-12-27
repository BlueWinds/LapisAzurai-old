window.Place = class Place extends GameObject
  @schema:
    type: @
    strict: true
    properties:
      name:
        type: 'string'
      description:
        type: ['string', 'function']
        maxLength: 220
      images:
        # Required images for every location
        properties:
          '*':
            type: 'string'
          day: {}
          night: {}
          storm: {}
      jobs:
        type: Collection
        items:
          type: [Job, 'function']
      location:
        type: 'array'
        items: [
          {type: 'integer', gte: 0, lte: 4000}
          {type: 'integer', gte: 0, lte: 3000}
        ]
      arrive: # An array of days on which the ship arrived in this port
        type: 'array'
        optional: true
        items: {type: 'integer'}
      destinations: # Where a person can sail from here, in location: distance format
        type: Collection
        items:
          type: 'integer'
          gte: 0
      firstVisit: # A page displayed when the player first visits this location
        type: Page
        optional: true

  jobs: new Collection

  image: (tag, title)-> "<img src='#{@images[tag]}' #{if title then 'title="' + title + '"' else ''}>"

  renderBlock: (center, key, distance)->
    x = center[0] - @location[0] # Half the width of the label
    y = center[1] - @location[1] # Space above it for the dot

    return """<div data-key="#{key}" class="location" style="left: #{-x}px; top: #{-y}px;">
      <div class="name">#{@name}</div>
      <div class="full">
        <div class="name">#{@name} - #{distance} #{if distance is 1 then 'day' else 'days'}</div>
        #{@image 'day', (if distance then 'Sail to ' else 'Return to ') + @name}
        <div class="description">#{@description?() or @description}</div>
      </div>
    </div>"""

  toString: -> return @name

Game::map = new Collection
Game.schema.properties.map =
  type: Collection
  items:
    type: Place

Game.schema.properties.location =
  type: Place
