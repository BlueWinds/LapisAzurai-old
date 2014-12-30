window.toggle = (options, selected)->
  options = optionList options, selected
  return """<span class="btn-group toggle">#{options.join ''}</span>"""

window.bigOptions = (options, selected)->
  options = optionList options, selected
  join = '</div><div class="col-md-4 col-xs-6">'
  return """<div class="bigOptions row"><div class="col-md-4 col-xs-6">#{options.join join}</div></div>"""

window.dropdown = (options, selected)->
  lis = optionList options, selected
  return """<button type="button" class="btn btn-default dropdown-toggle inline">#{options[selected]}</button>
  <span class="dropdown-menu inline">
    <span>#{lis.join '</span><span>'}</span>
  </span>"""

conditionsSchema =
  # A "conditions" object is a set of (key: rule) pairs for filling in a collection at run-time (called a context).
  # It's used by a page to pull in GameObjects to edit of show information about.
  optional: true
  type: 'object'
  items:
    type: ['string', 'object', 'boolean']
    # If a condition is a string, then it simply looks up that path in the global game object, and matches if it's present.
    # conditions.location: 'map|Vailia' -> context.location = game.map.Vailia.
    # A 'false' value means that the matching part must *not* exist. Eg: {'|events|MtJuliaMarket': false} means the event must not have occurred.
    pattern: /^\|[a-zA-Z0-9\|]+$/

    # A rule can also be a more complex set of properties for pulling in an object conditionally.
    properties:
      path:
        # The path at which to find the object we're comparing against. {path: 'crew|Nat'} is the "long form" of just 'crew|Nat'.
        type: 'string'
        optional: true
        pattern: /^\|[a-zA-Z0-9\| ]+$/
      fill: # The context is filled in here with this function's return value. Eg: conditions: {fish: {fill: -> return 3}} will turn into context: {fish: 3}
        # Called with the current context as @, after all non-"fill" properties have been filled.
        type: 'function'
        optional: true
      optional:
        # If present, then this part of the context is optional (the context as a whole can still match even if this part of it doesn't).
        eq: true
        optional: true
      eq: # Equal to
        type: ['number', 'string']
        optional: true
      lt: # Less than
        type: 'number'
        optional: true
      lte: # Less than or equal
        type: 'number'
        optional: true
      gt: # Greater than
        type: 'number'
        optional: true
      gte: # Greaten than or equal
        type: 'number'
        optional: true
      is: # The object is an instanceof this class or one of these classes
        type: ['array', 'function']
        optional: true
      matches: # Matches if matches(obj) returns truthy
        type: 'function'
        optional: true

    exec: (schema, item)->
      if not item.is and 'is' in Object.keys(item)
        @report '".is" is undefined'

conditionsSchema.items.properties['*'] = conditionsSchema

window.Page = class Page extends GameObject
  @schema:
    type: @
    strict: true
    properties:
      conditions: conditionsSchema
      text: # Should not modify the game state. Returns either a string or a set of $(pages) to be displayed to the player.
        type: 'function'
      effects:
        type: 'object'
        optional: true
        properties:
          add:
            # Each key is a path (must start with '|'), and the value is a class to add a new instance of at that location
            type: 'object'
            optional: true
            properties:
              '*':
                type: 'function'
          remove:
            # Each key is a path, each value the type of object that will be found there and removed (it's an error if the wrong object is at that location)
            type: 'object'
            optional: true
            properties:
              '*':
                type: 'function'
          cargo:
            # Each key is an item, the value the amount to add or subtract from the ship's cargo.
            type: 'object'
            optional: true
            properties:
              '*':
                type: ['integer', 'string'] # Either an amount to add, or a property to pull out of the current context and add.
          money: # Give or take money from the player - [amount, reason]
            type: 'array'
            items: [
                type: 'integer'
              ,
                type: 'string'
            ]
            exactLength: 2
            optional: true

      apply:
        type: 'function'
        optional: true
        # Called once when the page is first displayed. It can modify the game state to represent the results of the event.
      next:
        # Either another Page class to display, or a function that returns one (with no side effects).
        # If not defined for the given page (or the function returns null), next defaults to "game decides what happens next."
        # false is a special value which means "hang on, I'll call another event later (from within @text) to continue the game. Don't go on without me."
        optional: true
        type: [@, 'function', 'boolean']
      context:
        # A set of objects built using this page's conditions.
        type: Collection
        optional: true

  # If a page's context hasn't been filled in, then we don't need to export it.
  export: (ids, paths, path)->
    if @hasOwnProperty 'context' then super(ids, paths, path)

  context: new Collection

  contextMatch: -> return @context.matches @conditions

  contextFill: -> @context = (new Collection).fill @conditions

  show: ->
    if @conditions and not @context.objectLength
      @contextFill()

    # Disable all previous pages
    last = $('#content').children().last()
    last.find('*').unbind()
    last.find('input, button').attr 'disabled', 'disabled'

    div = try
      $(@text.call @context)
    catch e
      errorPage(@, e)

    unless g.last is @
      if @effects
        g.applyEffects @effects, @context
      g.last = @
      g.events[@constructor.name] or= []
      g.events[@constructor.name].unshift g.day
      if g.events[@constructor.name].length > 10
        g.events[@constructor.name].pop()

      try
        @apply?(div)
      catch e
        div.push errorPage(@, e)

    bg = null
    div.filter('page').each ->
      if $(@).attr 'bg'
        bg = $(@).attr 'bg'
      if bg
        $(@).css('background-image', 'url("' + bg + '")')

    $('text', div).each ->
      if $(@).attr('continue')?
        last = $(@).parent().prev().children('text')
        $(@).prepend(last.children().clone())
      if $(@).attr('continue-inline')?
        last = $(@).parent().prev().children('text')
        text = $(@).html()
        $(@).empty().prepend(last.children().clone())
        final = $(@).children().last()
        final.html(final.html() + text)

    div.appendTo '#content'
    div.not(div[0]).css 'display', 'none'
    div.data 'page', @
    g.setGameInfo()
    addTooltips(div)
    gotoPage()
    return div.first()

optionList = (options, selected)->
  name = 'o-' + Math.random()
  options = for key, option of options
    _id = 'o-' + Math.random()
    checked = if selected is key then 'checked' else ''
    """<input type="radio" id="#{_id}" value="#{key}" #{checked} name="#{name}"><label for="#{_id}">#{option}</label>"""
  return options

Game::queue = new Collection
Game.schema.properties.queue =
  type: Collection
  items:
    type: Page

Game::events = {}
Game.schema.properties.events =
  type: 'object'
  properties:
    '*':
      # An array of days on which this page (or job) occurred.
      type: 'array'
      minLength: 0
      maxLength: 10
      items:
        type: 'integer'

$ ->
  c = $ '#content'
  # Bail out if we're not in the live game page
  unless c.length then return

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
    # Right, down
    if e.keyCode in [39, 40]
      gotoPage()
    # Left, up
    else if e.keyCode in [37, 38]
      gotoPage(-1)

  $(window).on 'mousewheel', (e)->
    if e.deltaY < 0
      gotoPage()
    else if e.deltaY > 0
      gotoPage(-1)

  c.css 'height', window.innerHeight - $('.navbar').outerHeight()
  centerNav()

  $('#content').on 'click', 'button.dropdown-toggle', ->
    position = $(@).toggleClass('active').position()
    menu = $(@).next()
    menu.css 'left', position.left
    menu.css 'top', position.top - menu.height() - 3

  $('#content').on 'change', '.dropdown-menu input', ->
    button = $(@).parent().parent().prev()
    button.html $(@).next().html()
    button.toggleClass('active')

gotoPage = Game.gotoPage = (change = 1, ignoreFalseNext)->

  currentElement = $('page.active').last()
  currentPage = currentElement.data('page')
  unless currentPage
    target = $('#content page').first()
    next = target.data 'page'

  else if change < 0
    target = currentElement.prev()
    next = target.data 'page'
    unless target.length
      return
  else
    target = currentElement.next()
    next = target.data 'page'
    unless target.length
      [next, target] = getNextPage currentPage, ignoreFalseNext
      unless next then return

  currentElement.trigger 'leave-page'
  if next instanceof Job
    return

  # If there are too many history items, remove the top one
  while $('#content').children().length > 20
    $('#content page').first().remove()

  speed = 500
  if change > 0 and target.attr('slow')? then speed = 1500
  else if change > 0 and target.attr('verySlow')? then speed = 4000

  $('#content page').removeClass('active')
  target.addClass('active').css({display: 'block', opacity: 0}).trigger('enter-page')

  target.animate {opacity: 1}, speed, ->
    if target.hasClass('active')
      $('#content page').not('.active').css {display: 'none'}
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

getNextPage = (page, ignoreFalseNext)->
  next = if typeof page.next is 'function' and not isPage page.next
    page.next()
  else
    page.next

  if next is false and not ignoreFalseNext
    return [false]

  if isPage next
    next = new next
  target = next?.show?()
  # If target is still undefined, pull the next page from the game queue
  while not target and not next
    next = g.queue.shift()
    target = next?.show()
    unless target or g.queue.length
      g.passDay()

  # We've reduced next to either a Page or a Page subclass.
  if typeof next is 'function'
    next = new next

  return [next, target]

$.fn?.tooltip.Constructor.DEFAULTS.container = 'body'
$.fn?.tooltip.Constructor.DEFAULTS.html = true
$.fn?.tooltip.Constructor.DEFAULTS.viewport = '#content'
$.fn?.tooltip.Constructor.DEFAULTS.trigger = 'hover click'

addTooltips = (element)->
  for stat, description of Person.stats
    $('.' + stat, element).tooltip {
      delay: {show: 300, hide: 100}
      placement: 'auto left'
      title: description
    }
  $('[title]', element).tooltip {
    delay: {show: 300, hide: 100}
    placement: 'bottom'
  }

  $('.person-info, .location', element).dblclick -> $(@).toggleClass 'show-full'

errorPage = (page, error)->
  console.log page, error
  console.trace()
  return $("""<page><text>
    <p>Probelm in #{page.constructor.name}</p>
    <p>#{error.toString()}</p>
  </text></page>""")

Page.randomMatch = ->
  weights = {}
  results = {}
  for page, index in @constructor.next
    if typeof page is 'function'
      page = new page
    page.contextFill()
    if page.contextMatch()
      results[index] = page
      weights[index] = 11 - (g.events[page.constructor.name]?.length or 0)

  return results[Math.weightedChoice weights]

Page.firstMatch = ->
  for page in @constructor.next
    if typeof page is 'function' then page = new page
    page.contextFill()
    if page.contextMatch()
      return page

Page.firstNew = ->
  for page in @constructor.next
    if typeof page is 'function' then page = new page
    page.contextFill()
    if page.contextMatch() and not g.events[page.constructor.name]
      return page

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
      $(window).one 'click focus', =>
        opts.target.tooltip 'destroy'
        @dequeue 'help'
    , 0

  if @hasClass 'active'
    unless $('.tooltip.help', @).length then @dequeue 'help'
  else
    @one 'enter-page', =>
      unless $('.tooltip.help', @).length then @dequeue 'help'
  return @
