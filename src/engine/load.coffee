$ ->
  $('#save-game').addClass 'disabled'

  unless featureDetect()
    return
  $('#new-game').click ->
    $('#save-game').addClass 'disabled'
    $('#content').empty()
    intro = new Page.Intro
    intro.show()

  $('#save-game').click ->
    unless g then return

    localStorage.setItem Date.now(), g.dump()
    $('#save-game .glyphicon-ok').animate {opacity: 1}, 500
    .animate {opacity: 0}, 2000

  last = Object.keys(localStorage).sort().pop()
  if last
    window.g = new Game localStorage[last]
    element = g.last.show().addClass 'active'
    Page.setNav g.last, element
    $('#save-game').removeClass 'disabled'
