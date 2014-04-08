window.Page = class Page extends Contextual
  @schema: $.extend true, {}, Contextual.schema,
    type: @
    properties:
      text:
        type: 'function'
      apply:
        type: 'function'
        optional: true
        # A function called once when the page is first displayed with a single argument, the page element (already fulled with the event's text, if any). It can modify the game state or DOM. @ is the current context.
      transition:
        # Defaults to fade
        type: 'string'
        optional: true
        pattern: /^wink$/
      next:
        # Either a new Page instance or Page subclass to display, or a function that returns one. It should not modify either the game state or the DOM.
        # If not defined for the given page (or the function returns null), next defaults to "game decides what happens next."
        # false is a special value which means "hang on, I'll call another event later (from within @apply) to continue the game. Don't go on without me."
        optional: true
        type: [@, 'function', 'boolean']

  show: ->
    context = @match()
    unless context then return false
    $.extend @, context

    last = $('#content').children().last()
    last.find('*').unbind()
    last.find('input, button').attr 'disabled', 'disabled'

    g?.last = @

    div = $ "<div></div>"
    div.append @text()
    div.appendTo '#content'
    div.data 'page', @
    @apply?(div)
    return div

Game.schema.properties.queue =
  type: 'array'
  items:
    type: Page

$ ->
  c = $ '#content'

  centerNav = ->
    height = window.innerHeight + $('.navbar').outerHeight() * 2
    top = height - $('#nav-arrows').outerHeight()
    $('#nav-arrows').css 'top', top / 2

  $(window).resize ->
    c.css 'height', window.innerHeight - $('.navbar').outerHeight()
    centerNav()
  setTimeout -> $(window).resize()

  $('#next').click -> gotoPage()
  $('#prev').click -> gotoPage(-1)

  $(window).keypress (e)->
    if e.keyCode in [39, 40]
      gotoPage()
    else if e.keyCode in [37, 38]
      gotoPage(-1)

  $(window).mousewheel (e)->
    if e.deltaY < 0
      gotoPage()
    else if e.deltaY > 0
      gotoPage(-1)

  c.css 'height', window.innerHeight - $('.navbar').outerHeight()
  centerNav()

gotoPage = Game.gotoPage = (change = 1)->

  current = $('#content .active').trigger 'leave-page'
  page = current.data('page')

  if change < 0
    target = current.prev()
    next = target.data 'page'
    unless target.length
      return
  else
    target = current.next()
    next = target.data 'page'
    unless target.length
      [next, target] = getNextPage page
      unless next then return

  # If there are too many history items, remove the top one and reset #content positioning
  if $('#content').children().length > 10
    $('#content > div:first-child').remove()

  switch next.transition
    when 'wink'
      target.stop(true).winkIn 500
    else # fade
      target.stop(true).css('opacity', 0).show().animate {opacity: 1}, 500

  current.find('*').stop(true)
  switch page.transition
    when 'wink'
      current.stop(true).winkOut 500
    else
      current.stop(true).animate {opacity: 0}, 500, -> $(@).hide().css 'opacity', ""

  current.removeClass 'active'
  target.addClass 'active'
  Page.setNav next, target

isPage = (funct)-> funct?.prototype instanceof Page

Page.setNav = (page, element)->
  if element.prev().length
    $('#prev').removeClass 'disabled'
  else
    $('#prev').addClass 'disabled'

  if element.next().length or page.next isnt false
    $('#next').removeClass 'disabled'
  else
    $('#next').addClass 'disabled'

getNextPage = (page)->
  next = if typeof page.next is 'function' and not isPage page.next
    page.next()
  else
    page.next

  if next is false
    return [false]

  if isPage next
    next = new next
  target = next?.show()
  # If target is still undefined, pull the next page from the game queue.
  while not target
    next = g.queue.pop()
    target = next.show()

  # We've reduced next to either a Page or a Page subclass.
  if typeof next is 'function'
    next = new next

  return [next, target]
