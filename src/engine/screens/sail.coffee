eventFrequency = 5
howOftenLuxuryUsed = 0.25
foodPerPersonDaily = 0.3333
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
      g.map[key].renderBlock([x, y], key, distance)
    locations.push @port.renderBlock([x, y], '', 0, )

    page = $ """<page slow class="screen set-sail" style="background-position: #{-x}px #{-y}px;">
      <form>
        #{locations.join ''}
      </form>
    </page>"""
    $('.location img', page).click (e)->
      e.preventDefault()
      key = $(@).parent().parent().attr 'data-key'
      unless key
        (new Page.Port).show()
        return false

      location = g.map[key]
      distance = g.location.destinations[key]

      for page in [1...distance]
        g.queue.push new Page.SailDay
        unless page % eventFrequency then g.queue.push new Page.SailEvent

      g.queue.push(done = new Page.SailDone)
      done.contextFill()
      done.context.destination = location

      Game.gotoPage(1, true)
    return page

  next: false

sailCost = ->
  cargo = g.map.Ship.cargo
  used = {happiness: 0}
  people = g.officers.objectLength + g.crew.length
  people = Math.randomRound(people * foodPerPersonDaily)

  food = {}
  totalFood = 0
  luxury = {}
  for item, amount of cargo
    if Item[item] instanceof Food
      food[item] = amount
      totalFood += amount
    else if Item[item] instanceof LuxuryGood
      luxury[item] = amount

  if Math.randomRound(howOftenLuxuryUsed)
    if $.isEmptyObject(luxury)
      used.noLuxury = 1
    else
      lux = Math.weightedChoice(luxury)
      used[lux] = 1

  # If people go hungry, they get unhappy.
  if people > totalFood
    used.noFood = people - totalFood
    people = totalFood

  for i in [0...people]
    f = Math.weightedChoice food
    food[f] -= 1
    used[f] or = 0
    used[f] += 1

  if g.weather is 'storm'
    wood = Math.floor(Math.random() * maxStormWood) + minStormWood - g.crew.length
    wood = Math.max(minStormWood, wood)
    used.wood = Math.min(wood, cargo.wood or 0)

    supplies = Math.floor(Math.random() * (maxStormSupplies - minStormSupplies)) + minStormSupplies
    used.navalSupplies = Math.min(supplies, cargo.navalSupplies or 0)

    if used.wood < wood
      used.natEnergy = (used.wood - wood) * natEnergyPerWood
    if used.navalSupplies < supplies
      used.natEnergy or= 0
      used.natEnergy += (used.navalSupplies - supplies) * natEnergyPerSupplies
    if used.natEnergy
      used.natEnergy = Math.floor(natEnergy)

  unless used.happiness then delete used.happiness
  return used

Page.SailDay = class SailDay extends Page
  conditions:
    Ship: '|map|Ship'
    cost: {fill: sailCost}
  text: ->
    costDescription = for item, amount of @cost when Item[item]
      left = @Ship.cargo[item] - amount
      item = Item[item]
      "#{item.name.capitalize()}: #{-amount} (#{item.amount(left)} left)"

    other = []
    if @cost.noFood
      other.push "Because there wasn't enough food, people went hungry (<span class='happiness'>-#{@cost.noFood} happiness</span>)."
    if @cost.noLuxury
      other.push "Without any luxuries to keep them happy, the sailors were restless (<span class='happiness'>-1 happiness</span>)."
    if @cost.natEnergy
      other.push "Natalie exhausted and hurt herself keeping the ship afloat despite a lack of wood or naval supplies (<span class='happiness'>-#{@cost.natEnergy}</span>, <class='energy'>-#{@cost.natEnergy}</span>)."

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    page = $ """<page slow class="screen sail" bg="#{@Ship.images[img]}"><text>
      <p><em>#{costDescription.join ', '}</em></p>
      #{if other.length then "<p><em>" + other.join(' ') + ".</em></p>" else ""}
    </text></page>"""
    page.delay(3000).queue 'fx', (next)->
      if page.hasClass 'active'
        Game.gotoPage(1)
    return page

  apply: ->
    for name, officer of g.officers
      officer.add('energy', 1)

    cost = @context.cost
    for item, amount of cost when Item[item]
      @context.Ship.cargo[item] -= amount
      unless @context.Ship.cargo[item] then delete @context.Ship.cargo[item]

    happiness = (cost.noLuxury or 0) * noLuxuryUnhappiness + (cost.noFood or 0) * noFoodUnhappiness
    if happiness
      for name, person of g.crew
        person.add 'happiness', -happiness
      for name, person of g.officers
        person.add 'happiness', -happiness
    if cost.natEnergy
      g.officers.Nat.energy -= cost.natEnergy
      g.officers.Nat.add('happiness', -cost.natEnergy)

    g.passDay()

Page.SailDone = class SailDone extends Page
  text: ->
    if @destination.arrive?[0] is g.day then return ''
    page = $ """
      <page slow bg="#{@destination.images.day}">
        <text class="short">#{@destination.description?() or @destination.description}</text>
      </page>"""
    page.delay(2500).queue 'fx', (next)->
      if page.hasClass 'active'
        Game.gotoPage(1)
    return page

  apply: ->
    if @context.destination.firstVisit and not @context.destination.arrive
      g.queue.push new @context.destination.firstVisit
    g.location = @context.destination
    g.location.arrive or= []
    g.location.arrive.unshift g.day
    if g.location.arrive.length > 10 then g.location.arrive.pop()
  next: ->
    unless g.location.majorPort
      return Page.Port
    leaving = new Context
    g.crew = g.crew.filter (sailor)->
      if sailor.happiness + Math.random() * maxHappinessToLeave / zeroHappinessChanceToLeave < maxHappinessToLeave
        leaving.push sailor
        return true
      return false

    unless leaving.length
      return Page.Port
    next = if leaving.length is 1
      new Page.OneCrewLeaving
    else
      new Page.ManyCrewLeaving
    next.context = leaving
    return next

Page.SailEvent = class SailEvent extends Page
  conditions:
    Ship: '|map|Ship'
  text: ->

    jobs = for key, job of @Ship.jobs when job instanceof Job or job.prototype instanceof Job
      if typeof job is 'function'
        job = @Ship.jobs[key] = new job
      job.contextFill()
      unless job.contextMatch()
        continue
      job.renderBlock key

    jobs.sort Job.jobSort

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    return sailClick $("""<page verySlow class="screen sail" bg="#{@Ship.images[img]}">
      <div class="col-xs-8 col-xs-offset-2">
        <div class="col-xs-6">#{jobs.join('</div>\n<div class="col-xs-6">')}</div>
      </div>
    </page>""")

  next: false

sailClick = (element)->
  $('.job', element).click (e)->
    key = $(@).attr('data-key')
    g.queue.unshift g.map.Ship.jobs[key]

    setTimeout((->Game.gotoPage(1, true)), 0)

    e.preventDefault()
    return false
  return element


Page.OneCrewLeaving = class OneCrewLeaving extends Page
  # context[0] will be filled in when this event is triggered
  text: ->
    img = if g.weather is 'calm' then g.location.images.marketDay else g.location.images.marketStorm
    """<page bg=#{img}>
      #{@[0].image 'upset', 'right'}
      <text><p>#{q}I'm sorry, but I think it's time for me to look for another berth,</q> #{@[0]} maintained a bit of politeness, but not too much. #{}</p></text>
    <page>
      #{g.officers.Nat.image 'serious', 'left'}
      <text continue><p>#{q}Good luck.</q> She nodded sadly. It was clear that #{@[0]} had been planning to leave for some time, and this was as good a time as any. The Lapis had been having a rough time recently - it was hard to hold it against #{him @[0]}.</p></text>
    </page>"""

Page.ManyCrewLeaving = class ManyCrewLeaving extends Page
  # context[0 -> n] will be filled in when this event is triggered
  text: ->
    img = if g.weather is 'calm' then g.location.images.marketDay else g.location.images.marketStorm
    names = @toArray()
    name.shift()
    """<page bg=#{img}>
      #{@[0].image 'upset', 'right'}
      <text><p>#{q}I'm sorry, Natalie, but we've talked it over and we think it's time to go our separate ways.</q> #{@[0]} spoke quietly, glancing over #{his} shoulder at the other#{if @length > 2 then 's who were' else 'who was'} also departing. #{names.wordJoin()} nodded in agreement. They were also leaving.</p></text>
    <page>
      #{g.officers.Nat.image 'serious', 'left'}
      <text continue><p>#{q}I'm sorry to see you all go, but if that's what you have to do, then good luck.</q> She nodded sadly. It had been clear that they were already decided, and trying to hold onto them was a losing proposition. The Lapis had been having a rough time recently - it was hard to hold it against them.</p></text>
    </page>"""
