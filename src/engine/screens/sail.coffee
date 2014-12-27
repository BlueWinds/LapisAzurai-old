eventFrequency = 5

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

    page = $ """<page class="screen set-sail verySlowFadeOut" style="background-position: #{-x}px #{-y}px;">
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
        g.queue.push new Page.SailNothing
        if page % eventFrequency then g.queue.push new Page.SailSomething

      g.queue.push(done = new Page.SailDone)
      done.contextFill()
      done.context.destination = location

      Game.gotoPage(1, true)
    return page

  next: false

sailDay = ->
  remaining = g.queue.filter (page)-> page.constructor.name in ['SailNothing', 'SailSomething']
  desti = g.queue[g.queue.length - 1].destination
  total = g.location.destinations[dest.constructor.name]
  return [remaining, total]

sailCost = ->
  cargo = g.map.ship.cargo
  used = {happiness: 0}
  people = g.officers.objectLength + g.crew.length
  people = Math.floor(people / 4)

  food = {}
  totalFood = 0
  luxury = {}
  for item, amount in cargo
    if Item[item] instanceof Food
      food[item] = amount
      totalFood += amount
    else if Item[item] instanceof LuxuryItem
      luxury[item] = amount

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
    wood = Math.floor(Math.random() * 10) + 3 - g.crew.length
    wood = Math.max(2, wood)
    used.wood = Math.min(wood, cargo.wood or 0)

    supplies = Math.floor(Math.random() * 4) + 1
    used.navalSupplies = Math.min(supplies, cargo.navalSupplies or 0)

    if used.wood < wood
      used.natEnergy = used.wood - wood
    if used.navalSupplies < supplies
      used.natEnergy or= 0
      used.natEnergy += (used.navalSupplies - supplies) * 2

  unless used.happiness then delete used.happiness
  return used

Page.SailDay = class SailDay extends Page
  conditions:
    Ship: '|map|Ship'
    cost: {fill: sailCost}
  text: ->
    costDescription = for item, amount of @cost when Item[item]
      "#{item.capitalize}: #{-amount}"

    other = []
    if @cost.noFood
      other.push "Because there wasn't enough food, everyone aboard goes hungry (<span class='happiness'>-#{@cost.noFood} happiness</span>)."
    if @cost.noLuxury
      other.push "Without any luxuries to keep them happy, the crew is restless (<span class='happiness'>-1 happiness</span>)."
    if @cost.natEnergy
      other.push "Natalie exhausted and hurt herself keeping the ship afloat despite a lack of wood or naval supplies (<span class='happiness'>-#{@cost.natEnergy}</span>, <class='energy'>-#{@cost.natEnergy}</span>)."

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    page = $ """<page class="screen sail verySlowFadeIn verySlowFadeOut" bg="#{@Ship.images[img]}"><text>
      <p><em>#{costDescription.join ', '}</em></p>
      #{if other.length then "<p><em>" + other.join(' ') + ".</em></p>" else ""}
    </text></page>"""
    page.delay(3500).queue 'fx', (next)->
      if page.hasClass 'active'
        Game.gotoPage(1)
    return page

  apply: ->
    for name, officer in g.officers
      officer.add('energy', 1)

    cost = @context.cost
    for item, amount of cost when Item[item]
      @context.Ship.cargo[item] -= amount
      unless @context.Ship.cargo[item] then delete @context.Ship.cargo[item]

    happiness = (cost.noLuxury or 0) + (cost.noFood or 0)
    if happiness
      for name, person in g.crew
        person.add 'happiness', -happiness
      for name, person in g.officers
        person.add 'happiness', -happiness
    if cost.natEnergy
      g.officers.Nat.energy -= cost.natEnergy
      g.officers.Nat.add('happiness', -cost.natEnergy)

    g.passDay()

Page.SailDone = class SailDone extends Page
  text: ->
    if @destination.arrive?[0] is g.day then return ''
    page = $ """
      <page class="verySlowFadeOut" bg="#{@destination.images.day}">
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
  next: Page.Port

Page.SailSomething = class SailSomething extends Page
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
    return sailClick $("""<page class="screen sail verySlowFadeIn verySlowFadeOut" bg="#{@Ship.images[img]}">
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
