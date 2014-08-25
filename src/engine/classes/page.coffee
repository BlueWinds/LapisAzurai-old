# Setting up a whole bunch of global functions to make rendering pages more convenient.
# lastP is always the most recent person one of these functions has been called with - using this as a default argument makes possible things like "#{He @CrewMember} hands #{his} cup to her." - notice how the second use doesn't require an argument.
lastP = null
q = (person = lastP)->
  lastP = person
  return "<q style='color: #{person.text}' title='#{person}'>"
q.toString = q

bq = (person = lastP)->
  if typeof person is 'string'
    return "<blockquote style='color: #{person}'>"
  lastP = person
  return "<blockquote style='color: #{person.text}' title='#{person}'>"
bq.toString = bq

window.he = (p = lastP)-> lastP = p; if p.gender is 'f' then 'she' else 'he'
window.He = (p = lastP)-> lastP = p; if p.gender is 'f' then 'She' else 'He'
window.him = (p = lastP)-> lastP = p; if p.gender is 'f' then 'her' else 'him'
window.his = (p = lastP)-> lastP = p; if p.gender is 'f' then 'her' else 'his'
window.His = (p = lastP)-> lastP = p; if p.gender is 'f' then 'Her' else 'His'
window.boy = (p = lastP)-> lastP = p; if p.gender is 'f' then 'girl' else 'boy'
window.man = (p = lastP)-> lastP = p; if p.gender is 'f' then 'woman' else 'man'
window.he.toString = window.he
window.He.toString = window.He
window.him.toString = window.him
window.his.toString = window.his
window.His.toString = window.His
window.boy.toString = window.boy
window.man.toString = window.man

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
    type: ['string', 'object']
    # If a condition is a string, then it simply looks up that path in the global game object, and matches if it's present.
    # conditions.location: 'map|Vailia' -> context.location = game.map.Vailia.
    pattern: /^\|[a-zA-Z0-9\|]+$/

    # A rule can also be a more complex set of properties for pulling in an object conditionally.
    properties:
      path:
        # The path at which to find the object we're comparing against. {path: 'crew|Nat'} is the "long form" of just 'crew|Nat'.
        type: 'string'
        optional: true
        pattern: /^\|[a-zA-Z0-9\|]+$/
      optional:
        # If present, then this part of the context is optional (the context as a whole can still match even if this part of it doesn't).
        eq: true
        optional: true
      # Other properties will be compared against the matching property of the object (conditions.stealth vs. person.stealth, for example)
      '*':
        type: 'object'
        strict: true
        properties:
          eq: # Equal to
            type: 'number'
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

GameObject::matches = (conditions)->
  if typeof conditions is 'string'
    return g.getItem(conditions) is @
  for key, condition of conditions when key not in ['path', 'optional']
    value = @
    for part in key.split('|')
      value = value[part]
    if value >= condition.lt or value > condition.lte
      return false
    if value <= condition.gt or value < condition.gte
      return false
    if condition.eq? and value isnt condition.eq
      return false
  return true

window.Page = class Page extends GameObject
  @schema:
    type: @
    strict: true
    properties:
      conditions: conditionsSchema
      text:
        type: 'function'
      apply:
        type: 'function'
        optional: true
        # Called once when the page is first displayed with a single argument, the page element (already fulled with the event's text). It can modify the game state or DOM. @ is the current context.
      next:
        # Either another Page class to display, or a function that returns one (with no side effects).
        # If not defined for the given page (or the function returns null), next defaults to "game decides what happens next."
        # false is a special value which means "hang on, I'll call another event later (from within @apply) to continue the game. Don't go on without me."
        optional: true
        type: [@, 'function', 'boolean']
      context:
        # A set of objects built using this page's conditions.
        type: Collection

  # If a page's context hasn't been filled in, then we don't need to export it.
  export: (ids, paths, path)->
    if @hasOwnProperty 'context' then super(ids, paths, path)

  contextMatch: (context = {})->
    newContext = new Collection
    $.extend newContext, @context
    for key, value of @conditions
      if typeof value is 'string'
        newContext[key] = g.getItem value
        continue

      target = context[key]
      if value.path
        target = g.getItem value.path
        if context[key] and context[key] isnt target
          return false
      else if not target
        target = g.last.context[key]

      if target? and target.matches value
        newContext[key] = target
      else if not value.optional
        return false
    @context = newContext
    return newContext

  context: new Collection

  show: ->
    @contextMatch()
    g.last = @

    # Disable all previous pages
    last = $('#content').children().last()
    last.find('*').unbind()
    last.find('input, button').attr 'disabled', 'disabled'

    div = $ @text.call @context
    div.appendTo '#content'
    div.data 'page', @
    @apply?(div)
    g.setGameInfo()
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

gotoPage = Game.gotoPage = (change = 1, ignoreFalseNext)->

  currentElement = $('page.active').trigger 'leave-page'
  currentPage = currentElement.data('page')
  unless currentPage
    target = $('#content page').first()
    next = target.data 'page'

  else if change < 0
    $('body').addClass 'backscroll'
    target = currentElement.prev()
    next = target.data 'page'
    unless target.length
      return
  else
    $('body').removeClass 'backscroll'
    target = currentElement.next()
    next = target.data 'page'
    unless target.length
      [next, target] = getNextPage currentPage, ignoreFalseNext
      unless next then return

  # If there are too many history items, remove the top one
  while $('#content').children().length > 20
    $('#content page').first().remove()

  currentElement.removeClass 'active'
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
