eventFrequency = 5
foodPerPersonDaily = 0.25
noFoodUnhappiness = 2
noFoodEnergy = 1

sailCost = ->
  used = {}
  people = 0
  for name, person of g.officers
    people += person.get 'eats'
  for name, person of g.crew
    people += person.get 'eats'

  people = Math.randomRound(people * foodPerPersonDaily)

  food = {}
  totalFood = 0
  for item, amount of g.cargo when (Item[item] instanceof Food)
    food[item] = amount
    totalFood += amount

  # If people go hungry, they get unhappy and tired.
  if totalFood is 0
    used.happiness = noFoodUnhappiness
    used.energy = noFoodEnergy

  for i in [0...Math.min(people, totalFood)]
    f = Math.weightedChoice food
    food[f] -= 1
    used[f] = (used[f] or 0) - 1

  return used

Page.SailDay = class SailDay extends Page
  # "daysNeeded" and "destination" are filled in by setSail
  text: ->
    costDescription = Item.costDescription(@cost)

    other = []
    if @cost.happiness
      other.push "Because there wasn't enough food people went hungry (<span class='happiness'>-#{@cost.happiness} happiness</span> sailors, <span class='energy'>-#{@cost.energy} energy</span> for officers)."

    ship = g.map.Ship

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    return """|| speed="slow" auto="3000" class="screen sail" bg="Ship.#{img}"
      -- <em>#{costDescription}</em>
        #{if other.length then "<em>" + other.join(' ') + "</em>" else ""}
        #{if ship.damage then "<em>" + ship.damageDescription() + "</em>" else ""}
    """

  apply: ->
    @context.days or= 0
    cost = @context.cost = sailCost()
    super()
    for name, officer of g.officers
      officer.add 'energy', 0.5

    g.applyEffects {cargo: cost}

    if cost.happiness
      for i, person of g.crew
        person.add 'happiness', -cost.happiness
      for i, person of g.officers
        person.add 'energy', -cost.energy

    @context.days += g.map.Ship.sailSpeed() * (if Page.sumStat('navigator', g.crew) then 1.1 else 1)
    if @context.days > @context.daysNeeded
      g.location = @context.destination
      g.location.arrive or= []
      g.location.arrive.unshift g.day
      if g.location.arrive.length > 10 then g.location.arrive.pop()

      Page.checkCrewLeaving()

      first = g.location.firstVisit
      if first and not g.events[first.constructor.name]
        g.queue.push first
      g.queue.push new Page.Port
    else
      if g.day % eventFrequency is 0
        g.queue.push new Page.SailEvent
      g.queue.push new Page.NextDay
      g.queue.push @

  setTimeout(Game.gotoPage, 0)
