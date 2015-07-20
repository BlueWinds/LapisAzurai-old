Game::atSea = -> g.queue[g.queue.length - 1] instanceof Page.SailDay

Page.SetSail = class SetSail extends Page
  conditions:
    port: '|location'
  text: ->
    content = $('#content')
    x = (@port.location[0] - content.width() / 2)
    y = (@port.location[1] - content.height() / 2)

    visited = {}
    visited[g.location] = true
    locations = []

    for key, distance of @port.destinations
      distance = Math.ceil(distance / g.map.Ship.sailSpeed())
      visited[key] = true
      locations.push g.map[key].renderBlock(key, distance)

    traceNetwork = (loc)->
      for key, distance of loc.destinations
        if visited[key]
          continue
        visited[key] = true
        locations.push g.map[key].renderBlock(key, false)
        traceNetwork(g.map[key])

    for key, distance of @port.destinations
      traceNetwork(g.map[key])

    locations.push @port.renderBlock('', -1)

    page = $.render """|| speed="slow" class="screen set-sail"
      <form><div class="bg"></div>#{locations.join('').replace(/\n/g, '')}</form>
    """
    $('.bg', page).css('background-image', 'url("game/content/misc/' + g.mapImage + '")')

    # Triggering mousemove with touchmove so that dragscroll will work on touchscreen devices
    page.dragScroll({top: 1000, bottom: 2000, left: 200, right: 1750})

    setTimeout(->
      page.scrollLeft(x)
      page.scrollTop(y)
    , 1)
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
