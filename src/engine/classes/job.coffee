isPage = (funct)-> funct?.prototype instanceof Page

window.Job = class Job extends Page
  @schema:
    type: @
    # Jobs are not strict - you can add additional properties to them for configuration
    properties:
      label:
        type: 'string'
      # The default is "normal" - sorted last, occurring first. Plot jobs are sorted first and occur last. Special jobs are both sorted and occur occur between "normal" and "plot"
      type:
        type: 'string'
        match: /plot|special|normal/
      # conditions is used to determine whether the job shows up at all, and create an initial context. Once it has, "officers" defines slots for people who must / can work the job for it to apply.
      conditions: Page.schema.properties.conditions
      text: # text is used as a small blurb, rather than its own page
        type: 'function'
      # Each officer will be added to the job's context before @next is called.
      officers: Page.schema.properties.conditions
      energy: # How much energy is given to or taken away from each officer participating (also how much they need to have to participate, if taking away).
        type: ['integer', 'function']
      acceptInjured: # If a person has low enough negative energy, they're considered injured, and can only do jobs with this flag.
        eq: true
        optional: true
      # If crew can be brought along for this job. This number is the minimum number required to do the job.
      crew:
        type: 'integer'
        optional: true
      apply: # Called once when the job is run to modify the game state with the results of this job. Be absolutely sure to call super() inside this function.
        type: 'function'
        optional: true
      next: # Unlike Pages, it's required for jobs.
        type: [Page, 'function']
      context:
        # A set of objects built using this page's conditions.
        optional: true
        type: Collection

  @universal = [] # An array of jobs that can show up at any port

  type: 'normal'

  renderBlock: (mainKey)->
    energy = if typeof @energy is 'function' then @energy() else @energy
    slots = for key, conditions of @officers
      renderSlot(key, conditions, energy)

    return """<div class="#{@type} job clearfix" data-key="#{mainKey}">
      <div class="col-xs-6">
        <div class="job-description">#{@text.call(@context).replace(/\n/g, "<br>")}</div>
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
    for key, value of @officers
      unless @context[key] or value.optional
        return false
    return @contextMatch()

  show: ->
    div = $.render("""|| class="jobStart" auto="1800"
      <h4>#{@label}</h4>
    """)

    div.appendTo('#content').addTooltips()
    div.not(div[0]).css 'display', 'none'
    div.data 'page', @
    return div

  apply: ->
    super()
    energy = if typeof @energy is 'function' then @energy() else @energy
    if energy
      for key, person of @context when @officers[key]
        person.add 'energy', energy

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
      <div class="job-description">#{@text().replace(/\n/g, "<br>")}</div>
    </div>"""

  contextReady: ->
    if @context.length < @crew
      return false

    for key, value of @officers
      unless @context[key] or value.optional
        return false

    return @contextMatch()

renderSlot = (key, conditions, energy)->
  name = switch
    when conditions.label then conditions.label()
    when key[0] is key[0].toUpperCase() then key
    else 'Any Officer'

  if energy > 0 then energy = '+' + energy

  stats = for stat in ['business', 'sailing', 'combat']
    "<span class='#{stat}'>#{conditions[stat]?.gte or ''}</span>"

  """<li data-slot="#{key}"><div class="worker-requirements">
    #{ if name then '<div class="name">' + name + '</div>' else '' }
    <div class="energy">#{energy}</div>
    <div class="stats">#{stats.join ''}</div>
  </div></li>"""
