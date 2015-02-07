gotoPage = Game.gotoPage = (change = 1)->
  currentElement = $('page.active')

  targetDiv = if change < 0 then currentElement.prev()
  else if not currentElement.length then $('#content page').first()
  else getNextDiv()

  next = targetDiv.data 'page'

  currentElement.trigger 'leave-page'
  if change > 0
    currentElement.find('*').unbind()
    currentElement.find('input, button').attr 'disabled', 'disabled'
    $('.tooltip').remove()

  speed = 500
  if change > 0
    if targetDiv.attr('slow')? then speed = 1500
    else if targetDiv.attr('verySlow')? then speed = 4000

  $('#content page').removeClass('active').stop().css({display: 'none'})
  currentElement.css({display: 'block', opacity: 1})
  targetDiv.addClass('active').css({display: 'block', opacity: 0}).trigger('enter-page')
  $('*', currentElement).blur()

  targetDiv.animate {opacity: 1}, speed, ->
    if targetDiv.hasClass('active')
      $('#content page').not('.active').css {display: 'none'}
  setNav()

isPage = (funct)-> funct?.prototype instanceof Page


# Returns the next div after the currently active one, or generates events / passes time until there is one.
getNextDiv = ->
  $('#content .tooltip').remove()
  currentPage = $('page.active').data('page')

  until $('page.active + page').length
    currentPage = getNextPage(currentPage) or g.queue.shift()
    unless currentPage
      g.passDay()
      currentPage = g.queue.shift()

    try
      currentPage.apply()
    catch e
      $('#content').append errorPage(currentPage, e)

    # If there are too many history items, remove the top one
    while $('#content page').length > 20
      $('#content page').first().remove()

  return $('page.active + page')

# Returns either a Page instance or false. Idempotent.
getNextPage = (page)->
  unless page then return false

  if page.next instanceof Page
    return new page.constructor::next
  else if isPage page.next
    return new page.next
  else if typeof page.next is 'function'
    next = page.next()
    if isPage next
      return new next
    else if page
      return next

setNav = ->
  element = $('page.active')
  element.toggleClass 'no-prev', not element.prev().length

$.fn?.tooltip.Constructor.DEFAULTS.container = 'page.active'
$.fn?.tooltip.Constructor.DEFAULTS.html = true
$.fn?.tooltip.Constructor.DEFAULTS.trigger = 'hover click'

$.fn?.addTooltips = ->
  for stat, description of Person.stats
    $('.' + stat, @).tooltip {
      delay: {show: 300, hide: 100}
      placement: 'auto left'
      title: description
    }
  $('[title]', @).not('button').tooltip {
    delay: {show: 300, hide: 100}
    placement: 'bottom'
  }
  $('button[title]', @).tooltip {
    delay: {show: 300, hide: 100}
    placement: 'top'
  }

  $('.person-info, .location', @).dblclick ->
    $(@).toggleClass 'show-full'
  $('div.full', @).tooltip(
    title: 'Double click to sticky or hide this'
    placement: 'bottom'
    container: 'page.active'
  )

errorPage = (page, error)->
  element = $ """<page><text>
    <p>Problem in #{page.constructor.name}</p>
    <p>#{error.toString()}</p>
    <blockquote><pre></pre></blockquote>
  </text></page>"""
  $('pre', element).text(error.stack)
  return element

$ ->
  unless featureDetect()
    return

  c = $ '#content'

  $('.navbar-brand, #game-info').dblclick -> $('.navbar-brand').toggleClass 'show-info'
  $('#game-info').tooltip(
    title: 'Double click to sticky or hide this'
    placement: 'bottom'
  )

  $(window).resize ->
    c.css 'height', Math.min(window.innerHeight - $('.navbar').outerHeight(), 800)
    $('body').css 'height', window.innerHeight
  setTimeout -> $(window).resize()

  considerGoto = (upDown)->
    a = $('page.active')
    if upDown > 0 and a.next().length is 0 and a.data('page')?.next is false
      return
    if upDown < 0 and a.prev().length is 0
      return
    gotoPage(upDown)

  c.on 'click', 'page', (e)->
    page = $(e.currentTarget)

    if e.clientX >= page.offset().left + page.width() - 28 and
        e.clientY <= page.offset().top + 34
      considerGoto(-1)
    else
      considerGoto(1)

  $(window).keydown (e)->
    # Right, down
    if e.keyCode in [39, 40]
      considerGoto(1)
    # Left, up
    else if e.keyCode in [37, 38]
      considerGoto(-1)


  c.on 'enter-page', 'page[auto]', ->
    setTimeout =>
      $(@).removeAttr 'auto'
      if $(@).hasClass 'active'
        Game.gotoPage(1)
    , parseInt($(@).attr('auto'), 10)

  c.on 'click', 'button.dropdown-toggle', ->
    position = $(@).toggleClass('active').position()
    menu = $(@).next()
    menu.css 'left', position.left
    menu.css 'top', position.top - menu.height() - 3

  c.on 'change', '.dropdown-menu input', ->
    button = $(@).parent().parent().prev()
    button.html $(@).next().html()
    button.toggleClass('active')

  if window.location.hash.match /validate/
    for name, _class of window when _class?.schema and name isnt 'Game'
      for name, item of _class when item.schema
        item = (new item)
        item.valid()
    (new window.Game).valid()

    Game.passDay.push ->
      g.valid()

  $('#new-game').click ->
    c.empty()
    $('#game-info .mission').remove()
    window.g = new Game
    (new Page.Intro).apply()
    gotoPage()

  $('#save-game').click ->
    unless g then return

    localStorage.setItem Date.now(), jsyaml.safeDump(g.export())
    $('#save-game .glyphicon-ok').animate {opacity: 1}, 500
    .animate {opacity: 0}, 2000

  $('#load-game').click ->
    c.empty()
    # Show rather than apply so it doesn't mess with the current game state.
    (new Page.Load).show()
    gotoPage()

  last = Object.keys(localStorage).map((key) -> parseFloat(key) or 0).sort().pop()
  if last
    window.g = new Game jsyaml.safeLoad(localStorage[last])
    g.last.show()
    g.setGameInfo()
  else
    window.g = new Game
    (new Page.Intro).apply()

  gotoPage()

  # A game is now loaded or created. Set up the gui.

  for key, mission of g.missions
    mission.addAs key


$.fn?.help = (opts)->
  if typeof opts.target is 'string'
    opts.target = $(opts.target, @).first()

  @queue 'help', =>
    opts.target.tooltip($.extend {
      container: 'page.active'
      template: '<div class="tooltip help" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
      trigger: 'manual'
    }, opts).tooltip('show')
    setTimeout =>
      $(window).one 'click', =>
        opts.target.tooltip 'destroy'
        @dequeue 'help'
    , 0

  if @hasClass 'active'
    unless $('.tooltip.help', @).length then @dequeue 'help'
  else
    @one 'enter-page', =>
      unless $('.tooltip.help', @).length then @dequeue 'help'
  return @
