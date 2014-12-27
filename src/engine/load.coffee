$ ->
  unless featureDetect()
    return

  if window.location.hash.match /validate/
    for name, _class of window when _class?.schema and name isnt 'Game'
      for name, item of _class when item.schema
        item = (new item)
        item.valid()
    (new window.Game).valid()

    Game.passDay.push ->
      g.valid()

  $('#new-game').click ->
    $('#content').empty()
    $('#game-info .mission').remove()
    window.g = new Game
    (new Page.Intro).show()

  $('#save-game').click ->
    unless g then return

    localStorage.setItem Date.now(), JSON.stringify(g.export())
    $('#save-game .glyphicon-ok').animate {opacity: 1}, 500
    .animate {opacity: 0}, 2000

  last = Object.keys(localStorage).sort().pop()
  if last
    window.g = new Game JSON.parse(localStorage[last])
  else
    window.g = new Game

$ ->
  if g.last
    element = g.last.show().addClass 'active'
    Page.setNav g.last, element
  else
    (new Page.Intro).show()

  for key, mission of g.missions
    mission.addAs key
  return
