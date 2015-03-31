eventFrequency = 6
howOftenLuxuryUsed = 0.125
foodPerPersonDaily = 0.25
noFoodUnhappiness = 1 # Per missing unit of food
noLuxuryUnhappiness = 1

minStormWood = 5
maxStormWood = 20
woodSavedPerSailor = 1

minStormSupplies = 4
maxStormSupplies = 10

natEnergyPerWood = 1
natEnergyPerSupplies = 2

zeroHappinessChanceToLeave = 0.5
maxHappinessToLeave = 20

Page.SetSail = class SetSail extends Page
  conditions:
    port: '|location'
  text: ->
    content = $('#content')
    x = (@port.location[0] - content.width() / 2)
    y = (@port.location[1] - content.height() / 2)

    locations = for key, distance of @port.destinations
      distance = Math.ceil(distance / g.map.Ship.sailSpeed())
      g.map[key].renderBlock(key, distance)
    locations.push @port.renderBlock('', 0, )

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
  people = g.officers.objectLength + g.crew.length
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
    unless g.location.majorPort
      return
    leaving = new Collection
    g.crew = g.crew.filter (sailor)->
      if sailor.happiness + Math.random() * maxHappinessToLeave / zeroHappinessChanceToLeave < maxHappinessToLeave
        leaving.push sailor
        return false
      return true

    unless leaving.length
      return
    g.queue.push next = if leaving.length is 1
      new Page.OneCrewLeaving
    else
      new Page.ManyCrewLeaving
    next.context = leaving

  next: ->
    if @context.destination.firstVisit and @context.destination.arrive.length is 1
      return @context.destination.firstVisit
    return

Page.OneCrewLeaving = class OneCrewLeaving extends Page
  # context[0] will be filled in when this event is triggered
  text: ->"""|| bg="marketDay|marketStorm"
    #{@[0].image 'sad', 'right'}
    --
      #{q}I'm sorry, but I think it's time for me to look for another berth,</q> #{@[0]} maintained a bit of politeness, but not too much.
  ||
    #{g.officers.Nat.image 'serious', 'left'}
    -->
      #{q}Good luck.</q> She nodded sadly. It was clear that #{@[0]} had been planning to leave for some time, and this was as good a time as any. The Lapis had been having a rough time recently - it was hard to hold it against #{him @[0]}.
  """

Page.ManyCrewLeaving = class ManyCrewLeaving extends Page
  # context[0 -> n] will be filled in when this event is triggered
  text: ->
    names = @toArray()
    name.shift()
    """|| bg="marketDay|marketStorm"
      #{@[0].image 'sad', 'right'}
      -- #{q}I'm sorry, Natalie, but we've talked it over and we think it's time to go our separate ways.</q> #{@[0]} spoke quietly, glancing over #{his} shoulder at the other#{if @length > 2 then 's who were' else 'who was'} also departing. #{names.wordJoin()} nodded in agreement. They were also leaving.

    ||
      #{g.officers.Nat.image 'serious', 'left'}
      --> #{q}I'm sorry to see you all go, but if that's what you have to do, then good luck.</q> She nodded sadly. It had been clear that they were already decided, and trying to hold onto them was a losing proposition. The Lapis had been having a rough time recently - it was hard to hold it against them.
    """
