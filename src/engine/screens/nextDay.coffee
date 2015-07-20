Page.NextDay = class NextDay extends Page
  text: ->
    location = if g.atSea()
      location = 'Sailing to ' + g.queue[g.queue.length - 1].context.destination.name
    else
      g.location.name
    return """|| speed="slow" auto="2000" class="nextDay"
      <h2>#{g.date}</h2>
      <h3>Day #{g.day}</h3>
      <h3>#{location}</h3>
    """
  apply: ->
    g.day++
    for event in Game.passDay
      event()
    super()
