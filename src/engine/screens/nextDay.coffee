Page.NextDay = class NextDay extends Page
  text: ->
    location = g.location.name
    if g.queue[g.queue.length - 1] instanceof Page.SailDone
      location = 'Sailing to ' + g.queue[g.queue.length - 1].context.destination.name
    element = $ """<page slow class="nextDay">
      <h2>#{g.date}</h2>
      <h3>Day #{g.day}</h3>
      <h3>#{location}</h3>
    </page>"""

    setTimeout ->
      if element.hasClass 'active' then Game.gotoPage(1)
    , 2000

    return element
