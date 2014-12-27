Page.NextDay = class NextDay extends Page
  text: ->
    location = g.location.name
    if g.queue[g.queue.length - 1] instanceof Page.SailDone
      location += ' -> ' + g.queue[g.queue.length - 1].context.destination.name
    element = $ """<page class="nextDay slowFadeIn verySlowFadeOut">
      <h2>#{g.date}</h2>
      <h3>Day #{g.day}</h3>
      <h3>#{location}</h3>
    </page>"""

    $('page').last().removeClass('verySlowFadeOut').addClass('slowFadeOut')
    element.delay(3000).queue 'fx', (next)->
      if element.hasClass 'active'
        Game.gotoPage(1)
      next()
    return element
