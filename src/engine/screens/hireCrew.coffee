hireCost = (people, context)->
  unless context
    [people, context] = [people.asArray(), people]
  r = context.Recruiter
  a = context.Assistant
  cost = 0
  for hire in people
    cost += hire.wages() * 10

  reduction = r.get('diplomacy', context) + a?.get('diplomacy', context)
  reduction += r.get('business', context) * 2 + a?.get('business', context) * 2
  cost *= Math.max 0.1, (1 - reduction / 300)
  return Math.round(cost)

Page.HireCrewOne = class HireCrewOne extends Page
  conditions:
    Recruiter: {}
    Assistant: {optional: true}
    port: '|location'
    # '0' will be set by the hiring event
  text: ->"""<page style='background-image: url("#{@port.images.night}");'>
    #{@[0].image 'normal', 'mid-right reversed'}
    <text>
      <p>#{@Recruiter} talks with several sailors, but most of them aren't exactly prime material - too old, too young, sickly or untrustworthy. If they were just sailing around lakes, hauling cargo up rivers with a barge #{he @Recruiter} might let them aboard anyway, but not on the open ocean. It's dangerous out there. The terrible storms that make landfall, that tear houses from the ground and uproot trees are nothing compared to the hurricanes that rage across open water. And the monsters. Always the monsters. #{@Recruiter} has to trust #{his} crewmates with #{his} life.</p>
      <p>#{@[0]} is the only one who fits the bill tonight. #{He @[0]}'ll do.</p>
    </text>
  </page>
  <page style='background-image: url("#{@port.images.night}");'>
    #{@Recruiter.image 'normal', 'mid-left'}
    <text>
      <p>Tradition dictates that a new crewmember is paid extremely well the first week - they're putting their life in the hands of a captain they don't know. It takes a bit of negotiation, but #{@[0]} finally settles for #{hireCost @}β for the first week and #{@[0].wages()}β daily thereafter. #{@Recruiter} hands over a one obol coin and tells #{@[0]} where they're docked.</p>
      #{bq @Recruiter}Welcome aboard.</blockquote>
    </text>
  </page>"""
  apply: ->
    g.crew.Nat.money -= hireCost @context

Page.HireCrewMulti = class HireCrewMulti extends Page
  conditions:
    Recruiter: {}
    Assistant: {optional: true}
    port: '|location'
      # '0' and '1' will be set by the hiring event. '2' - '5' may or may not be.
  text: ->
    wages = Math.sum(crew.wages() for crew in @asArray())
    names = @asArray().map (p)->p.name
    """<page style='background-image: url("#{@port.images.night}");'>
      #{@Recruiter.image 'normal', 'mid-left'}
      <text>
        <p>Of the many people interested, #{@Recruiter} eventually settles on #{@asArray().length.toWord()}: #{names.wordJoin()}.</p>
        <p>Tradition dictates that each new crewmember is paid extremely well the first week - they're putting their life in the hands of a captain they don't know. After arguing with #{Math.choice names} for a while, #{@Recruiter} finally convinces them to accept #{hireCost @}β for the first week and a combined #{wages}β daily thereafter. #{He @Recruiter} hands an obol coin to each and tells them where to find the ship in the morning.</p>
        #{bq @Recruiter}Welcome aboard.</blockquote>
      </text>
    </page>"""
  apply: ->
    g.crew.Nat.money -= hireCost @context
    for crew in @context.asArray()
      name = crew.name
      while g.crew[name] then name += '-'
      g.crew[name] = crew


Person.RandomPerson = class RandomPerson extends Person
  @schema: $.extend true, {}, Person.schema,
    properties:
      # Set by the description function, to remember which option was chosen for this particular person in the future.
      descriptionKey:
        type: 'integer'
        optional: true
  # Names out of which a random one will be generated.
  @names: ['Natalie']
  # A list of description functions, chosen from randomly at character generation.
  @descriptions: [
    ->"""0: #{@name}. If you're seeing this as a player, it is a bug."""
    ->"""1: #{@name}. If you're seeing this as a player, it is a bug."""
  ]
  # Points to be assigned among various stats and positive traits
  @basePoints: 15
  @extraPoints: 25

  description: ->
    @descriptionKey or= Math.floor(Math.random() * @constructor.descriptions.length)
    return @constructor.descriptions[@descriptionKey].call @


# Generates a random person.
Person.random = (baseClasses)->
  base = Math.choice(baseClasses)
  name = randomName base.names
  person = new base
    name: name
  person.color = for layer in base.colors
    if layer
      Math.choice(layer)[0]
    else
      false

  points = base.basePoints + base.extraPoints * Math.random() * Math.random()
  while points > 1
    stat = Math.choice Person.mainStats
    amount = Math.ceil(points * 0.5)
    person[stat] += amount
    person[stat + 'Growth'] or= 0
    person[stat + 'Growth'] += amount / 100
    points -= amount
  return person

Job.HireCrew = class HireCrew extends Job
  # When subclassing, this is the list of person class from which random crewmembers will be generated.
  @hireClasses: []

  label: "Hire Crew"
  text: -> "Search the city for new crew members."
  workers:
    Recruiter:
      business: {gte: 10}
    Assistant:
      optional: true
  requires:
    diplomacy: 10
  apply: ->
    leave = Math.choice [0, 0, 0, 0, 1, 2, 3]
    while leave
      leave--
      @context.shift()

    count = Math.choice [2, 2, 3, 3, 4, 4, 5, 6]
    while @context.length < count
      @context.push Person.random @constructor.hireClasses

Job.HireCrew::next = Page.HireCrew2 = class HireCrew2 extends Page
  conditions:
    Recruiter: {}
    Assistant: {optional: true}
    job: '|last'
    0: {optional: true}
    1: {optional: true}
    2: {optional: true}
    3: {optional: true}
    4: {optional: true}
    5: {optional: true}

  description: ->
    """<p>#{@Recruiter} talks to the bartender, passes over a coin for the trouble and sets #{him @Recruiter}self up at a table. It isn't long before #{he} has some interested recruits.</p>"""

  text: ->
    hires = (person.renderBlock(key) for key, person of @asArray())
    crew = (person.renderBlock(key, 'hired') for key, person of g.crew)
    wages = (person.wages() for name, person of g.crew)
    wages = Math.sum wages

    return """<page class="screen" style='background-image: url("#{g.location.images.night}");'>
      <form>
        <div class="col-md-4 col-xs-6 col-md-offset-2">
          <div class="hires clearfix">
            <div class="block-label">Sailors</div>
            #{hires.join ''}
          </div>
        </div>
        <div class="col-md-4 col-xs-6">
          <div class="crew clearfix">
            <div class="block-label">
              Crew (<span class="cost">0</span>β today, <span class="wages">#{wages}</span>β weekly)
            </div>
            #{crew.join ''}
          </div>
        </div>
        <button class="btn btn-primary center-block">Done</button>
      </form>
      <text class="short">#{g.last.description.call @}</text>
    </page>"""
  apply: (element)->
    hires = @context

    people = $('.person-info', element)
    people.click ->
      person = g.crew[$(@).attr('data-key')]
      # You can't select already hired storyline characters here (so you can't fire them and mess things up).
      unless $(@).hasClass('hired') and person.isStory()
        $(@).toggleClass 'active'

    $('.crew, .hires', element).click (e)->
      if $(e.target).closest('.person-info').length
        return
      $('.person-info.active', element).appendTo(@).removeClass 'active'
      cost = 0
      wages = 0
      $('.crew .person-info', element).each ->
        key = $(@).attr('data-key')
        person = g.crew[key] or hires[key]
        wages += person.wages()
        unless g.crew[key]
          cost += hireCost [person], hires
      $('.cost').html cost
      $('.wages').html wages

    $('form', element).submit (e)->
      e.preventDefault()

      $('.hires .hired', element).each ->
        # Old crew to be fired
        key = $(@).attr 'data-key'
        delete g.crew[key]

      newCrew = new Collection
        Recruiter: hires.Recruiter
      if hires.Assistant
        newCrew.Assistant = hires.Assistant

      $('.crew .person-info:not(.hired)', element).each ->
        # New crew to be hired
        person = hires[$(@).attr 'data-key']
        newCrew.push person
        delete hires.job.context[$(@).attr 'data-key']

      if newCrew.length is 1
        g.queue.unshift(new Page.HireCrewOne)
        g.queue[0].context = newCrew
      else if newCrew.length
        g.queue.unshift(new Page.HireCrewMulti)
        g.queue[0].context = newCrew

      setTimeout((->Game.gotoPage(1, true)), 0)
      return false

  next: false
