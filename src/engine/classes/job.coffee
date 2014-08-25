sumStat = (stat, workers, context)->
  sum = 0
  for key, person of context when workers[key]
    sum += person.get stat, context
  return sum

isPage = (funct)-> funct?.prototype instanceof Page

window.Job = class Job extends Page
  @schema:
    type: @
    # Jobs are not strict - you can add additional properties to them for configuration
    properties:
      label:
        type: 'string'
      # conditions is used to determine whether the job shows up at all, and create an initial context. Once it has, "workers" defines slots for people who must / can work the job for it to apply.
      conditions: Page.schema.properties.conditions
      text: # text is used as a small blurb, rather than its own page
        type: 'function'
      # Each worker will be added to the job's context before @next is called.
      workers: Page.schema.properties.conditions
      requires: # requires is a list of stat: total pairs, specifying how much of a given stat the workers must total up to (150 total business, for example)
        type: 'object'
        optional: true
        strict: true
        properties: {}
      apply:
        type: 'function'
        optional: true
        # Called once when the page is first displayed with a single argument, the page element (already fulled with the event's text). It can modify the game state or DOM. @ is the current context.
      next: # Unlike Pages, it's required for jobs.
        type: [Page, 'function', 'boolean']
      context:
        # A set of objects built using this page's conditions.
        optional: true
        type: Collection
      days:
        # Once the job has been applied at least once, this is an array of the game days it triggered on (otherwise it's an empty array).
        type: 'array'
        items:
          type: 'integer'

  for stat in Person.mainStats
    @schema.properties.requires.properties[stat] = {type: 'integer', optional: true, gte: -100}

  days: []

  requiresBlock: ->
    requires = for stat, val of @requires
      sum = sumStat stat, @workers, @context
      unmet = if sum >= val then '' else 'unmet'
      "<span class='#{stat} #{unmet}'>#{val}</span>"
    return if requires.length
      """<div class="job-requirements">#{requires.join ''}</div>"""
    else ""

  renderBlock: (mainKey)->
    slots = for key, conditions of @workers
      renderSlot(key, conditions)

    return """<div class="job clearfix" data-key="#{mainKey}">
      <div class="col-xs-6">
        <div class="job-description">#{@text()}</div>
        #{@requiresBlock()}
      </div>
      <ul class="job-workers col-xs-6">#{slots.join ''}</ul>
    </div>"""

  updateFromDiv: (div)->
    for key, slot of @workers
      slotDiv = $('li[data-slot="' + key + '"]', div)
      person = $('.person-info', slotDiv).attr 'data-key'
      unless person?
        delete @context[key]
        if slot.optional then continue
        return
      @context[key] = if person then g.crew[person] else g.player

    # The update can also fail if the provided people's stats don't add up enough.
    for stat, amount of @requires
      if amount > sumStat(stat, @workers, @context)
        return

    return @context

  show: ->
    @apply?()

    g?.last = @ # Only here momentarily, so that parts of the context can be copied by the following event.
    next = if typeof @next is 'function' and not isPage @next
      @next()
    else
      @next
    if typeof next is 'function'
      next = new next

    @days = @days.slice()
    @days.unshift g.day

    return next.show()

renderSlot = (key, conditions)->
  name = if key[0] is key[0].toUpperCase() then key else ''

  level = if conditions.level? then conditions.level else '&nbsp;'
  stats = for stat in Person.mainStats
    "<span class='#{stat}'>#{conditions[stat]?.gte or ''}</span>"

  """<li data-slot="#{key}"><div class="worker-requirements">
    #{ if name then '<div class="name">' + name + '</div>' else '' }
    <div class="level">#{level}</div>
    <div class="stats">#{stats.join ''}</div>
  </div></li>"""
