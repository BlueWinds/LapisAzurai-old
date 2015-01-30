stormDamageMin = 5
stormDamageMax = 30

minEnergy = -15

sailPerDamageSaved = 40
battenDownMultiplier = 2 / 3

originalNext = Page.SailDay::next
Page.SailDay::next = ->
  if g.weather is 'storm' and g.events.FirstStorm
    return Page.Storm
  originalNext.call(@)

stormDamage = ->
  damage = Math.random() * (stormDamageMax - stormDamageMin) + stormDamageMin
  damage -= Person.sumStat('sailing', g.officers, g.crew) / sailPerDamageSaved
  damage -= Person.sumStat('sailing', g.officers, g.officers) / sailPerDamageSaved
  damage = Math.round(damage)

  return damage

Page.Storm = class Storm extends Page
  conditions:
    Ship: '|map|Ship'
    damage: {fill: stormDamage}
    sailing: '|last'
  text: ->
    sail = @sailing.context
    intensity = switch
      when @damage <= 7 then 'weak, but still destructive'
      when @damage <= 15 then 'intense'
      when @damage <= 20 then 'dangerous'
      when @damage <= 25 then 'deadly'
      else 'a Grandmother Storm'


    buttons = ['Run for ' + g.location, 'Run for ' + sail.destination, 'Batten Down']

    originDays = Math.ceil(sail.days / g.map.Ship.sailSpeed())
    destinationDays = Math.ceil((sail.daysNeeded - sail.days) / g.map.Ship.sailSpeed())
    titles = [
      g.location + ' is ' + if sail.days <= g.map.Ship.sailSpeed() then 'one day away. You could make it back to the port in time to avoid the storm.' else (originDays.toWord() + ' days away. You could turn around and make for safe harbor.')

      sail.destination + ' is ' + if destinationDays <= 1 then 'one day away. You could make it to port in time to avoid the storm.' else (destinationDays.toWord() + ' days away. You could make a full day\'s progress riding the storm winds.')

      "Preparing for the storm will reduce the damage to #{String.rate battenDownMultiplier}."
    ]

    page = $ """<page slow short class="screen sail" bg="#{@Ship.images.deckStorm}"><text>
      <p>Dark clouds on the horizon and growing waves - a storm was rolling in. Natalie felt it in her bones - this was going to be <b>#{intensity}</b>. There were still a few hours before it arrived though, time to make preparations.</p>
      <p><em>Your crew's <span class="sailing">sailing</span> reduces the damage from a storm</em></p>
      #{options buttons, titles}
    </text></page>"""

    arrive = =>
      if sail.days >= sail.daysNeeded
        @destination = sail.destination
        g.queue.unshift new Page.SailDone
        g.queue[0].contextFill()
        g.queue.pop()
      else
        g.queue.unshift new Page.StormRun
      Game.gotoPage()

    $('button', page).eq(0).click ->
      [g.location, sail.destination] = [sail.destination, g.location]
      sail.days = sail.daysNeeded - sail.days + g.map.Ship.sailSpeed()
      arrive()

    $('button', page).eq(1).click ->
      sail.days += g.map.Ship.sailSpeed()
      arrive()

    $('button', page).eq(2).click ->
      g.queue.unshift new Page.StormBatten
      Game.gotoPage()

    return page

  next: false

damageDescription = (d)->
  switch
    when d <= 5 then "This was a light enough storm though, and the ship suffered no more than a few snapped ropes and smashed planks. The leaks below decks were minor enough to patch with tar until they reached the shore."
    when d <= 10 then "The ship creaked and groaned, one of the masts splintering as the sail ripped away. Thankfully nothing gave way below the waterline, though it would take days to repair the damage and dry out the cargo again from the multitude of small leaks. Sailing would be significantly slowed, until there was time to replace the sail."
    when d <= 15 then "Natalie clung to the wheel as waves crashed over the deck continually - there was only so much she could do to keep the bow facing forward in a tempest like this, and it wasn't enough. She felt her strength draining as she held the ship together, storm energy coursing through her blood. It was like grasping lightning by the tail."
    else "All human effort was useless in the face of a storm like this. Mountains and valleys made of foaming water crashed around them, and any ship not of sturdy Vailian construction would have shattered in minutes. Even the Azurai would likely have sank, if Natalie weren't bound to it, turning herself into a conduit for barely controlled storm energy. It burned her mind, like trying to hold her hand in a fire, but grimly she clung to the wheel and poured out magic."

Page.StormBatten = class StormBatten extends Page
  conditions:
    damage: {}
  text: ->"""<page bg="#{g.map.Ship.images.storm}"></page>
  <page>
    <text><p>With enough warning to tie down everything that could be tied down and bring in the sails, the Lapis Azurai was as ready as any ship could be to survive a storm on the open ocean. Waves tossed it to and fro, and even with the crew doing all they could to weather the tempest and waves, some damage was inevitable.</p></text>
  </page>
  <page>
    <text continue>#{damageDescription (@damage * battenDownMultiplier)}</text>
  </page>"""
  apply: ->
    super()
    applyDamage Math.round(@context.damage * battenDownMultiplier)

Page.StormRun = class StormRun extends Page
  conditions:
    damage: {}
  text: ->"""<page bg="#{g.map.Ship.images.storm}"></page>
  <page>
    <text><p>Running on the wings of the storm, the Lapis Azurai fairly flew through the water, picking up speed even as the waves grew taller and the winds more intense - it made a full day's progress, ropes humming and sails straining before finally the groaning of the masts and hull convinced Natalie that she could push no further.</p></text>
  </page>
  <page>
    <text continue>#{damageDescription @damage}</text>
  </page>"""
  apply: ->
    super()
    applyDamage Math.round @context.damage

applyDamage = (damage)->
  damage += g.map.Ship.damage
  if damage >= Place.Ship.heavyDamage
    g.officers.Nat.add('energy', (Place.Ship.heavyDamage - g.map.Ship.damage) * 2)
    g.officers.Nat.energy = Math.max(g.officers.Nat.energy, minEnergy)

  g.map.Ship.damage = Math.min(Place.Ship.maxDamage, damage)
