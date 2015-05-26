eventFrequency = 5
howOftenLuxuryUsed = 0.125
foodPerPersonDaily = 0.25
noFoodUnhappiness = 2 # Per missing unit of food
noLuxuryUnhappiness = 1

minStormWood = 5
maxStormWood = 20
woodSavedPerSailor = 1

minStormSupplies = 4
maxStormSupplies = 10

natEnergyPerWood = 1
natEnergyPerSupplies = 2

zeroHappinessChanceToLeave = 0.75
maxHappinessToLeave = 20

Page.SetSail = class SetSail extends Page
  conditions:
    port: '|location'
  text: ->
    content = $('#content')
    x = (@port.location[0] - content.width() / 2)
    y = (@port.location[1] - content.height() / 2)

    visited = {}
    visited[g.location] = true
    locations = []

    for key, distance of @port.destinations
      distance = Math.ceil(distance / g.map.Ship.sailSpeed())
      visited[key] = true
      locations.push g.map[key].renderBlock(key, distance)

    traceNetwork = (loc)->
      for key, distance of loc.destinations
        if visited[key]
          continue
        visited[key] = true
        locations.push g.map[key].renderBlock(key, false)
        traceNetwork(g.map[key])

    for key, distance of @port.destinations
      traceNetwork(g.map[key])

    locations.push @port.renderBlock('', -1)

    page = $.render """|| slow="true" class="screen set-sail"
      <form><div class="bg"></div>#{locations.join('').replace(/\n/g, '')}</form>
    """

    # Triggering mousemove with touchmove so that dragscroll will work on touchscreen devices
    page.dragScroll().on 'touchmove', (e)->
      page.trigger('mousemove', e)

    setTimeout ->
      page.scrollLeft(x)
      page.scrollTop(y)
    , 1
    $('.location img', page).click (e)->
      e.preventDefault()
      key = $(@).parent().parent().attr 'data-key'
      unless key
        (new Page.Port).show()
        Game.gotoPage()
        return false

      g.queue.push sailing = new Page.SailDay
      sailing.context.destination = g.map[key]
      sailing.context.daysNeeded = g.location.destinations[key]

      Game.gotoPage()
      return false
    return page

  next: false

sailCost = ->
  used = {happiness: 0}
  people = 0
  for name, person of g.officers
    people += person.get 'eats'
  for name, person of g.crew
    people += person.get 'eats'

  people = Math.randomRound(people * foodPerPersonDaily)

  food = {}
  totalFood = 0
  luxury = {}
  for item, amount of g.cargo
    if Item[item] instanceof Food
      food[item] = amount
      totalFood += amount
    else if Item[item] instanceof Luxury
      luxury[item] = amount

  if Math.randomRound(howOftenLuxuryUsed)
    if $.isEmptyObject(luxury)
      used.noLuxury = 1
    else
      lux = Math.weightedChoice(luxury)
      used[lux] = -1

  # If people go hungry, they get unhappy.
  if people > totalFood
    used.noFood = people - totalFood
    people = totalFood

  for i in [0...Math.min(people, totalFood)]
    f = Math.weightedChoice food
    food[f] -= 1
    used[f] or = 0
    used[f] -= 1

  used.happiness = (used.noLuxury or 0) * noLuxuryUnhappiness + (used.noFood or 0) * noFoodUnhappiness
  unless used.happiness then delete used.happiness

  return used

Page.SailDay = class SailDay extends Page
  # "daysNeeded" and "destination" are filled in by setSail
  text: ->
    costDescription = Item.costDescription(@cost)

    other = []
    if @cost.noFood
      other.push "Because there wasn't enough food people went hungry (<span class='happiness'>-#{@cost.noFood} happiness</span>)."
    if @cost.noLuxury
      other.push "Without any luxuries to keep them happy the sailors were restless (<span class='happiness'>-1 happiness</span>)."

    ship = g.map.Ship

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    return """|| slow="true" auto="3000" class="screen sail" bg="Ship.#{img}"
      -- <em>#{costDescription}</em>
        #{if other.length then "<em>" + other.join(' ') + "</em>" else ""}
        #{if ship.damage then "<em>" + ship.damageDescription() + "</em>" else ""}
    """

  apply: ->
    @context.days or= 0
    cost = @context.cost = sailCost()
    super()
    for name, officer of g.officers
      officer.add('energy', 1)

    g.applyEffects {cargo: cost}

    if cost.happiness
      for name, person of g.crew
        person.add 'happiness', -cost.happiness

    @context.days += g.map.Ship.sailSpeed()
    if @context.days < @context.daysNeeded
      g.queue.push @
      g.passDay()

  next: ->
    if @context.days > 1 and g.day % eventFrequency is 0
      return Page.SailEvent
    else if @context.days >= @context.daysNeeded
      return Page.SailDone
    return

Page.SailDone = class SailDone extends Page
  conditions:
    destination: {}
  text: ->false
  apply: ->
    super()

    g.location = @context.destination
    g.location.arrive or= []
    g.location.arrive.unshift g.day
    if g.location.arrive.length > 10 then g.location.arrive.pop()

    Page.checkCrewLeaving()

  next: ->
    first = @context.destination.firstVisit
    if first and not g.events[first.constructor.name]
      return first
    return
