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
        type: ['number', 'string', 'array']
        items:
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
        items: [
          type: 'function'
        ]
      matches: # Matches if matches(obj) returns truthy
        type: 'function'
        optional: true
      label: # Only used for job slots, this function must return a string which will be used as the slot label
        type: 'function'
        optional: true

    exec: (schema, item)->
      if not item.is and 'is' in Object.keys(item)
        @report '".is" is undefined'

conditionsSchema.items.properties['*'] = conditionsSchema

window.Page = class Page extends GameObject
  valueOf: ->'Page'
  @schema:
    type: @
    strict: true
    properties:
      conditions: conditionsSchema
      text: # Should not modify the game state. Returns either a string or a set of $(pages) to be displayed to the player.
        type: 'function'
        exec: (schema, text)->
          text = text.toString()
          match = text.match(/<page/g)
          if match?.length > 16
            @report "can't have more than 15 <page>s in one text block"
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

      apply: # Called once when the page is first displayed. It can modify the game state to represent the results of the event. Be absolutely sure to call super() inside this function - it will fill in the context, display the page and apply the effects.
        type: 'function'
        optional: true
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

    div = $(@text.call @context).filter('page')
    bg = null
    div.each ->
      if $(@).attr 'bg'
        bg = $(@).attr 'bg'
      if bg and bg isnt 'none'
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

    div.appendTo('#content').addTooltips()
    div.not(div[0]).css 'display', 'none'
    div.data 'page', @

  apply: ->
    if @effects
      g.applyEffects @effects, @context
    g?.setGameInfo()
    @show()

    g.last = @
    g.events[@constructor.name] or= []
    g.events[@constructor.name].unshift g.day
    if g.events[@constructor.name].length > 10
      g.events[@constructor.name].pop()
    return

Game::queue = new Collection
Game.schema.properties.queue =
  type: Collection
  items:
    type: Page

Game::events = new Collection
Game.schema.properties.events =
  type: Collection
  properties:
    '*':
      # An array of days on which this page (or job) occurred.
      type: 'array'
      minLength: 0
      maxLength: 10
      items:
        type: 'integer'

Page.randomMatch = ->
  weights = {}
  results = {}
  for page, index in @constructor.next
    if typeof page is 'function'
      page = new page
    page.contextFill()
    if page.contextMatch()
      results[index] = page
      weights[index] = Math.max(0, 8 - (g.events[page.constructor.name]?.length or 0))

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

window.PlayerOptionPage = class PlayerOptionPage extends Page
  show: ->
    element = super()
    next = @constructor.next
    $('button', element).click (e)->
      e.preventDefault()
      nextPage = next[$(@).html()]
      g.queue.unshift new nextPage
      Game.gotoPage()
      return false

    return element
  next: false
