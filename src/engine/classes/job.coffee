sumStat = Person.sumStat = (stat, officers, context)->
  sum = 0
  for key, person of context when officers[key] or key <= 10
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
      # The default is "normal" - sorted last, occurring first. Plot jobs are sorted first and occur last. Special jobs are both sorted and occur occur between "normal" and "plot"
      importance:
        optional: true
        type: 'string'
        match: /plot|special/
      # conditions is used to determine whether the job shows up at all, and create an initial context. Once it has, "officers" defines slots for people who must / can work the job for it to apply.
      conditions: Page.schema.properties.conditions
      text: # text is used as a small blurb, rather than its own page
        type: 'function'
      # Each officer will be added to the job's context before @next is called.
      officers: Page.schema.properties.conditions
      energy: # How much energy is given to or taken away from each officer participating (also how much they need to have to participate, if taking away).
        type: 'integer'
      # If crew can be brought along for this job. This number is the minimum number required to do the job.
      crew:
        type: 'integer'
        optional: true
      requires: # requires is a list of stat: total pairs, specifying how much of a given stat the workers (officers + crew) must total up to (150 total business, for example)
        type: 'object'
        optional: true
        strict: true
        properties: {}
      apply: # Called once when the job is run to modify the game state with the results of this job
        type: 'function'
        optional: true
      next: # Unlike Pages, it's required for jobs.
        type: [Page, 'function']
      context:
        # A set of objects built using this page's conditions.
        optional: true
        type: Collection

  for stat of Person.stats
    @schema.properties.requires.properties[stat] = {type: 'integer', optional: true, gte: 0}

  requiresBlock: ->
    unless @requires then return ''
    requires = for stat, val of @requires
      sum = sumStat stat, @officers, @context
      unmet = if sum >= val then '' else 'unmet'
      "<span class='#{stat} #{unmet}'>#{val}</span>"

    return """<div class="job-requirements">
      <div class="center">Needs</div>
      #{requires.join ''}
    </div>"""

  renderBlock: (mainKey)->
    slots = for key, conditions of @officers
      renderSlot(key, conditions, @energy)

    return """<div class="#{@type or 'normal'} job clearfix" data-key="#{mainKey}">
      <div class="col-xs-6">
        <div class="job-description">#{@text()}</div>
        #{@requiresBlock()}
      </div>
      <ul class="job-officers col-xs-6">#{slots.join ''}</ul>
      #{if @crew? then '<div class="job-crew-label">Crew (need ' + @crew + ')</div><ul class="job-crew col-xs-12"></ul>' else ''}
    </div>"""

  updateFromDiv: (div)->
    @contextFill()
    context = @context
    for key, slot of @officers
      slotDiv = $('li[data-slot="' + key + '"]', div)
      person = $('.person-info', slotDiv).attr 'data-key'
      if person
        context[key] = g.officers[person]

    if @crew?
      $('.job-crew .person-info', div).each (index)->
        person = $(@).attr 'data-key'
        context.push g.crew[person] or g.officers[person]

    return context

  contextReady: ->
    if @context.length < @crew
      return false

    for stat, amount of @requires
      if amount > sumStat(stat, @officers, @context)
        return false

    for key, value of @officers
      unless @context[key] or value.optional
        return false

    return @contextMatch()

  show: ->
    g.events[@name] or= []
    g.events[@name].unshift g.day
    if g.events[@name].length > 10
      g.events[@name].pop()

    @apply?()

    if @energy
      for key, person of @context when person.energy?
        person.add 'energy', @energy

    g?.last = @ # Only here momentarily, so that parts of the context can be copied by the following event.
    next = if typeof @next is 'function' and not isPage @next
      @next()
    else
      @next
    if typeof next is 'function'
      next = new next

    return next.show()

window.ShipJob = class ShipJob extends Job
  @schema: # Similar to a normal job, but simpler and lacking a whole lot of properties.
    type: @
    properties:
      label:
        type: 'string'
      importance:
        optional: true
        type: 'string'
        match: /plot|special/
      conditions: Job.schema.properties.conditions
      text:
        type: 'function'
      apply:
        type: 'function'
        optional: true
      next:
        type: [Page, 'function']
      context:
        optional: true
        type: Collection

  renderBlock: (key)->

    """<div class="#{@type or 'normal'} job column-block" data-key="#{key}">
      <div class="block-label">#{@label}</div>
      <div class="job-description">#{@text()}</div>
    </div>"""

  contextReady: ->
    if @context.length < @crew
      return false

    for stat, amount of @requires
      if amount > sumStat(stat, @officers, @context)
        return false

    for key, value of @officers
      unless @context[key] or value.optional
        return false

    return @contextMatch()

renderSlot = (key, conditions, energy)->
  name = if key[0] is key[0].toUpperCase() then key else ''

  stats = for stat in ['business', 'diplomacy', 'sailing', 'combat']
    "<span class='#{stat}'>#{conditions[stat]?.gte or ''}</span>"

  """<li data-slot="#{key}"><div class="worker-requirements">
    #{ if name then '<div class="name">' + name + '</div>' else '' }
    <div class="energy">#{energy}</div>
    <div class="stats">#{stats.join ''}</div>
  </div></li>"""
