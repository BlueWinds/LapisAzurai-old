daysWageToHire = 14
minContractMonths = 2
maxCrew = 9

hireCost = (people)->
  cost = 0
  for hire in people
    cost += hire.wages() * daysWageToHire

  return Math.round(cost)

Page.HireCrewOne = class HireCrewOne extends Page
  # '0' will be set by the hiring event
  text: ->"""|| bg="tavern"
    #{@[0].normal 'left'}
    --
      Natalie talked with several sailors, but most of them weren't exactly prime material - too old, too young, sickly or untrustworthy. If they were just sailing around lakes, hauling cargo up rivers with a barge she might let them aboard anyway, but not on the open ocean. It was dangerous out there. Those terrible storms which made landfall, that tore houses from the ground and uprooted trees were nothing compared to the hurricanes that raged across open water. And the monsters. Always the monsters. Natalie had to trust her crewmates with her life.

      #{@[0]} was the only one who fits the bill tonight. #{He @[0]}'ll do.
  ||
    #{g.officers.Nat.normal 'left'}
    --
      Tradition dictated that a new sailor was entitled to a handsome signup bonus, paid before departure - they were putting their life in the hands of a captain they didn't know, after all, and should be able to leave something behind even if they never returned. After a bit of negotiation, #{@[0]} finally settled for #{hireCost @asArray()}β immediately and #{@[0].wages().rounded()}β daily thereafter. Natalie handed over a one obol coin and told #{@[0]} where they're docked.

      #{q}Welcome aboard.</q>
  """
  apply: ->
    super()
    cost = -hireCost(@context.asArray(), @context)
    g.applyEffects {money: cost}
    g.crew.push @context[0]

Page.HireCrewMulti = class HireCrewMulti extends Page
  # '0' and '1' will be set by the hiring event. '2' - '5' may or may not be.
  text: ->
    wages = Math.sum((crew.wages() for crew in @asArray()))
    names = @asArray().map (p)->p.name
    """|| bg="night"
      #{g.officers.Nat.normal 'left'}
      --
        Of the many people interested, Natalie eventually settled on #{@asArray().length.toWord()}: #{names.wordJoin()}.

        Tradition dictated that a new crewmember was entitled to a handsome signup bonus, paid before departure - they were putting their life in the hands of a captain they didn't know, after all, and should be able to leave something behind even if they never returned. After arguing with #{Math.choice names} for a while, Natalie finally convinced them to accept #{hireCost @asArray()}β immediately, and #{wages.rounded()}β daily thereafter. Natalie handed an obol coin to each recruit and told them where to find the ship in the morning.

        #{q}Welcome aboard.</q>
    """
  apply: ->
    super()
    cost = -hireCost(@context.asArray(), @context)
    g.applyEffects {money: cost}
    for crew in @context.asArray()
      g.crew.push crew

window.RandomPerson = class RandomPerson extends Person
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
  ]
  # Points to be assigned among various stats and positive traits
  @basePoints: 10
  @extraPoints: 15

  description: ->
    @descriptionKey or= Math.floor(Math.random() * @constructor.descriptions.length)
    return @constructor.descriptions[@descriptionKey].call @

validTrait = (person, trait)->
  if person.traits[trait] then return false
  for opposed in oppositedTraits[trait] when person.traits[opposed]
    return false
  return true

# Generates a random person.
Person.random = (baseClasses)->
  base = Math.choice baseClasses

  name = String.randomName base.names
  while g.crew.filter((c)-> name is c.name).length
    name = String.randomName base.names

  person = new base
    name: name
    contract: minContractMonths * 2
    traits: new Collection

  person.color = for layer in base.colors
    Math.keyChoice(layer)

  points = base.basePoints + base.extraPoints * Math.random() * Math.random()

  possibleTraits = for name, trait of Trait when trait.randomPoints? then trait
  opposed = []

  for i in [0 ... Math.choice [1, 2]]
    while (trait = Math.choice possibleTraits).name in opposed then {}
    points -= trait.randomPoints
    opposed = opposed.concat (trait.opposed or [])
    opposed.push trait.name
    person.traits[trait.name] = new trait

  while points > 1
    stat = Math.choice ['business', 'sailing', 'combat', 'contract']
    amount = Math.ceil(points * 0.5)
    person[stat] += amount
    points -= amount

  person.happiness = Math.floor(Math.random() * 60 + 20)
  person.contract *= 15
  return person

Job.HireCrew = class HireCrew extends Job
  # When subclassing, this is the list of person class from which random crewmembers will be generated.
  @hireClasses: []

  label: "Change Crew"
  text: -> "Hire or fire sailors (bring them along, then remove them from your crew)."
  description: ->"""Natalie talked to the bartender, passed over a coin for the trouble and set herself up at a table. It wasn't long before she had some interested recruits."""
  officers:
    Natalie: '|officers|Nat'
  energy: -2
  crew: 0
  hires: new Collection
  apply: ->
    super()

    leave = if g.weather is 'storm'
      Math.choice [0, 0, 0, 0, 0, 1, 2]
    else
      Math.choice [0, 0, 0, 1, 2, 2, 3]

    while leave
      leave--
      @hires.shift()

    count = if g.weather is 'storm'
      Math.choice [2, 2, 2, 3, 3, 4, 4, 5]
    else
      Math.choice [2, 3, 3, 4, 4, 5, 6, 7]

    while @hires.length < count and @hires.length + g.crew.length < maxCrew
      @hires.push Person.random @constructor.hireClasses

Job.HireCrew::next = Page.HireCrew = class HireCrew extends Page
  conditions:
    hires: '|last|hires'
    job: '|last'

  text: ->
    hires = (person.renderBlock(key) for key, person of @hires)
    officers = (person.renderBlock(key, 'hired') for key, person of g.officers)
    crew = for person in @job.context.asArray() when not (person instanceof Officer)
      key = g.crew.indexOf person
      person.renderBlock(key, 'hired')

    wages = (person.wages() for name, person of g.crew)
    wages = Math.sum wages
    for name, person of g.officers
      wages += person.wages()

    form = """<form class="clearfix">
      <div class="col-md-4 col-sm-6 col-md-offset-2">
        <div class="hires clearfix column-block">
          <div class="block-label">Sailors</div>
          #{hires.join ''}
        </div>
      </div>
      <div class="col-md-4 col-sm-6">
        <div class="crew clearfix column-block">
          <div class="block-label">Crew</div>
          #{officers.join ''}
          <div class="block-summary">
            <span class="cost">0β</span> today, <span class="wages">#{wages.rounded()}β</span> daily
          </div>
          #{crew.join ''}
        </div>
      </div>
    </form>""".replace(/\n/g, '')

    element = """|| class="screen" bg="tavern"
      #{form}
      --.
        #{@job.description.call @}
        #{options ['Done']}
    """
    return applyHire.call @, element

  next: false

applyHire = (element)->
  element = $.render(element)
  context = @

  people = $('.person-info', element)
  people.not('.officer').click ->
    $(@).toggleClass 'active'

  $('.crew, .hires', element).click (e)->
    if $(e.target).closest('.person-info').length
      return
    $('.person-info.active', element).appendTo(@).removeClass 'active'

    cost = 0
    wages = 0
    for name, person of g.officers
      wages += person.wages()
    for name, person of g.crew
      wages += person.wages()
    $('.crew .person-info', element).not('.hired').each ->
      person = context.hires[$(@).attr 'data-key']
      wages += person.wages()
      cost += hireCost [person], context
    $('.hires .person-info.hired', element).each ->
      person = g.crew[$(@).attr 'data-key']
      wages -= person.wages()

    $('.block-summary .cost', element).html cost + 'β'
    $('.block-summary .wages', element).html wages.rounded() + 'β'

  $('button', element).click (e)->
    e.preventDefault()

    # Old crew to be fired
    $('.hires .hired', element).each ->
      g.crew.remove $(@).attr('data-key')

    newCrew = new Collection

    $('.crew .person-info', element).not('.hired').each ->
      # New crew to be hired
      key = $(@).attr 'data-key'
      person = context.hires[key]
      newCrew.push person

    # Don't remove them until the second iteration, so that the keys in the "hires" array don't change in the middle.
    for name, person of newCrew
      context.hires.remove person

    if newCrew.length is 1
      g.queue.unshift(new Page.HireCrewOne)
      g.queue[0].context = newCrew
    else if newCrew.length
      g.queue.unshift(new Page.HireCrewMulti)
      g.queue[0].context = newCrew

    Game.gotoPage()
    return false

  return element
