waiting = 0
Game.waitForInit = ->
  waiting++
  return ->
    waiting--
    unless waiting
      ready()


$ ->
  unless featureDetect()
    return
  $('#new-game').click ->
    $('#content').empty()
    window.g = new Game

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

ready = ->
  if g.last
    element = g.last.show().addClass 'active'
    Page.setNav g.last, element
  else
    (new Page.Intro).show()
