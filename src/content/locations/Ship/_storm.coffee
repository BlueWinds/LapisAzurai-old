stormDamageMin = 5
stormDamageMax = 30

sailPerDamageSaved = 40
battenDownMultiplier = 2 / 3

stormDamage = ->
  damage = Math.random() * (stormDamageMax - stormDamageMin) + stormDamageMin
  damage -= Page.sumStat('sailing', g.crew) / sailPerDamageSaved
  damage -= Page.sumStat('sailing', g.officers) / sailPerDamageSaved
  damage = Math.round(damage)
  return damage

intensity = (damage)->
  switch
    when damage <= 7 then 'weak, but still destructive storm'
    when damage <= 15 then 'an intense storm'
    when damage <= 20 then 'a dangerous storm'
    when damage <= 25 then 'a deadly storm'
    else 'a Grandmother Storm'

Place.Ship::jobs.storm = ShipJob.Storm = class Storm extends ShipJob
  label: "Storm"
  type: 'plot'
  conditions:
    chance:
      matches: -> return Math.random() <= 0.1 and g.events.Storm?[0] < g.day - 28
      optional: true
    '|events|FirstStorm': {}
    damage: {fill: stormDamage}
    sailing: '|last'
  text: ->"""The sky is darkening, winds blowing in. It looks like you're in for <b>#{intensity @context.damage}</b>. Time to either run for shore or batten down the hatches and pray."""

ShipJob.Storm::next = Page.Storm = class Storm extends Page
  conditions:
    Ship: '|map|Ship'
    sailing: {}
    damage: {}
  text: ->
    sail = @sailing.context

    buttons = ['Run for ' + g.location, 'Run for ' + sail.destination, 'Batten Down']

    originDays = Math.ceil(sail.days / @Ship.sailSpeed())
    destinationDays = Math.ceil((sail.daysNeeded - sail.days) / @Ship.sailSpeed())
    titles = [
      g.location + ' is ' + if sail.days <= @Ship.sailSpeed() then 'one day away. You could make it back to the port in time to avoid the storm.' else (originDays.toWord() + ' days away. You could turn around and make for safe harbor.')

      sail.destination + ' is ' + if destinationDays <= 1 then 'one day away. You could make it to port in time to avoid the storm.' else (destinationDays.toWord() + ' days away. You could make a full day\'s progress riding the storm winds.')

      "Preparing for the storm will reduce the damage to #{String.rate battenDownMultiplier}."
    ]

    page = $.render """|| slow="true" class="screen sail" bg="Ship.deckStorm"
      --. Dark clouds on the horizon and growing waves - a storm was rolling in. Natalie felt it in her bones. This was going to be <b>#{intensity @damage}</b>. There were still a few hours before it arrived though, time to make preparations.
        <em>Your crew's <span class="sailing">sailing</span> reduces the damage from a storm</em>
        #{options buttons, titles}
    """

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

    arrive = =>
      if sail.days >= sail.daysNeeded
        @destination = sail.destination
        g.queue.unshift new Page.SailDone
        g.queue[0].contextFill()
        g.queue.pop()
      else
        g.queue.unshift new Page.StormRun
      Game.gotoPage()

    return page

  next: false

damageDescription = (damage)-> switch
  when damage <= 5 then "This was a light enough storm, though, and the ship suffered no more than a few snapped ropes and smashed planks. The leaks below deck were minor enough to patch with tar until they reached the shore."
  when damage <= 10 then "The ship creaked and groaned, one of the masts splintering as the sail ripped away. Thankfully nothing gave way below the waterline, though it would take days to repair the damage and dry out the cargo from the multitude of small leaks. Sailing would be significantly slowed until there was time to replace the sail."
  when damage <= 15 then "Natalie clung to the wheel as waves crashed over the deck continually. There was only so much she could do to keep the bow facing forward in a tempest like this, and it wasn't enough. She felt her strength draining as she held the ship together, storm energy coursing through her blood. It was like grasping lightning by the tail."
  else "All human effort was useless in the face of a storm like this. Mountains and valleys made of foaming water crashed around them, and any ship not of sturdy Vailian construction would have shattered in minutes. Even the Azurai would likely have sunk if Natalie weren't bound to it, turning herself into a conduit for barely controlled storm energy. It burned her mind, like trying to hold her hand in a fire, but grimly she clung to the wheel and poured out magic."

Page.StormBatten = class StormBatten extends Page
  conditions:
    damage: {}
  text: ->"""|| bg="Ship.storm"

  ||
    -- With enough warning to tie down everything that could be tied down and bring in the sails, the Lapis Azurai was as ready as any ship could be to survive a storm on the open ocean. Waves tossed it to and fro, and even with the crew doing all they could to weather the tempest and waves, some damage was inevitable.

  ||
    --> #{damageDescription (@damage * battenDownMultiplier)}
  """
  apply: ->
    super()
    g.map.Ship.applyDamage Math.round(@context.damage * battenDownMultiplier)

Page.StormRun = class StormRun extends Page
  conditions:
    damage: {}
  text: ->"""|| bg="Ship.storm"
  ||
    -- Running on the wings of the storm, the Lapis Azurai fairly flew through the water, picking up speed even as the waves grew taller and the winds more intense. It made a full day's progress, ropes humming and sails straining before, finally, the groaning of the masts and hull convinced Natalie that she could push no further.

  ||
    --> #{damageDescription @damage}
  """
  apply: ->
    super()
    g.map.Ship.applyDamage Math.round @context.damage
