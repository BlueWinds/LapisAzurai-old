sumStat = (stat, context, job)->
  sum = 0
  for person in context
    sum += person.get stat, job
  return sum

isPage = (funct)-> funct?.prototype instanceof Page

window.Job = class Job extends Page
  @schema: $.extend true, {}, Page.schema,
    type: @
    properties:
      name:
        type: 'string'
      # text is used as a small blurb, rather than its own page
      # context can add things to the context as normal, but in addition "workers" can define required properties about who must / can work the job. "context" is applied after "workers"
      workers:
        type: 'object'
        items: Contextual.schema.properties.context.items
      requires:
        type: ['function', 'object']
        optional: true
        properties: {}
      next:
        optional: false

  for stat in Person.mainStats
    @schema.properties.requires.properties[stat] = {type: 'integer', optional: true}

  requiresBlock: (context)->
    requires = for stat, val of @requires
      sum = sumStat stat, context, @
      unmet = if sum >= val then '' else 'unmet'
      "<span class='#{stat} #{unmet}'>#{val}</span>"
    return """<div class="job-requirements">#{requires.join ''}</div>"""

  renderBlock: (context, mainKey)->
    slots = for key, conditions of @workers
      renderSlot(key, conditions)

    return """<div class="job clearfix" data-key="#{mainKey}">
      <div class="col-xs-6">
        <div class="job-label">#{@name}</div>
        #{@requiresBlock context}
      </div>
      <ul class="job-workers col-xs-6">#{slots.join ''}</ul>
      <div class="job-description">#{@text()}</div>
    </div>"""

  updateFromDiv: (div)->
    job = @
    context = {}
    for key, slot of @workers
      slotDiv = $('li[data-slot="' + key + '"]', div)
      person = $('.person-info', slotDiv).attr 'data-key'
      unless person?
        if slot.optional
          return
        context = false
        return false
      context[slot] = if person then g.crew[person] else g.player

    unless context
      return
    # The update can also fail if the provided people's stats don't add up enough.
    for stat, amount of @requires
      if amount > sumStat(stat, context, @)
        return

    for key of @workers
      if context[key] then @[key] = context[key]
      else delete @[key]
    return @

  show: ->
    @apply?()

    next = if typeof @next is 'function' and not isPage @next
      @next()
    else
      @next

    if typeof next is 'function'
      next = new next

    return next.show()

  toString: -> return @name

renderSlot = (key, conditions)->
  name = if conditions.path then (g.getItem(conditions.path) or 'Unknown') else ''
  level = if conditions.level? then conditions.level else ''
  stats = for stat in Person.mainStats
    "<span class='#{stat}'>#{conditions[stat] or ''}</span>"

  """<li data-slot="#{key}"><div class="worker-requirements">
    #{ if name then '<div class="person-name">' + name + '</div>' else '' }
    <div class="person-level">#{level}</div>
    <div class="person-stats">#{stats.join ''}</div>
  </div></li>"""
