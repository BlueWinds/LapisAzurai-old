Page.NextDay = class NextDay extends Page
  text: ->
    location = g.location.name
    if g.queue[g.queue.length - 1] instanceof Page.SailDone
      location = 'Sailing to ' + g.queue[g.queue.length - 1].context.destination.name
    return """|| speed="slow" auto="2000" class="nextDay"
      <h2>#{g.date}</h2>
      <h3>Day #{g.day}</h3>
      <h3>#{location}</h3>
    """
