Job.HireCrew = class HireCrew extends Job
  name: "Hire Crew"
  text: -> "Search the city for new crew members."
  workers:
    recruiter: {}
    assistant:
      optional: true
  requires:
    diplomacy: 10
    business: 10
  apply: ->
    if @hires
      leave = Math.choice [0, 0, 0, 0, 1, 2, 3]
      for i in [0..leave] then @hires.shift()
    else
      @hires = []
      @hires.push(randomCrew g.location) for i in [1..4]

    count = Math.choice [0, 1, 2, 2, 3, 3, 4, 4, 5, 6]
    while @hires.length < count
      @hires.push randomCrew g.location
    return


Job.HireCrew.next = Page.HireCrew2 = class HireCrew2 extends Page
  context:
    port: 'location'

  description: ->"""<p>#{@recruiter} talks to the bartender, passes over a coin for the trouble and sets #{@her @recruiter}self up at a table. It isn't long before #{@she} has some interested recruits.</p>"""

  text: ->
    hires = person.renderBlock(@, key) for key, person of g.location.hires
    crew = person.renderBlock(@, key, 'hired') for key, person of g.crew
    crew.unshift g.player.renderBlock @, ''

    return """<div class="screen" style='background-image: url("#{@port.images.bar}");'>
      <form>
        <div class="col-md-4 col-xs-6 col-md-offset-2">
          <div class="hires clearfix">#{hires.join ''}</div>
        </div>
        <div class="crew col-md-4 col-xs-6">#{crew.join}</div>
        <button class="btn btn-primary center-block">Done</button>
      </form>
    <div class="well short">#{@description()}</div>"""
  apply: (element)->
    hires = g.location.hires

    people = $ '.person-info', element
    people.click ->
      unless $(@).attr('data-key') is ''
        $(@).toggleClass 'active'

    $('.crew, .hires', element).click (e)->
      if $(e.target).closest('.person-info').length
        return
      $('.person-info.active', element).appendTo @
      .removeClass 'active'

    $('form', element).submit (e)->
      e.preventDefault()
      $('.crew .person-info:not(.hired)', element).each ->
        # New crew to be hired
        console.log 'hiring', $(@).attr 'data-person'
      $('.hires .hired', element).each ->
        # Old crew to be fired
        console.log 'firing', $(@).attr 'data-person'

      return false

  next: false

randomCrew = (location)->
  basePoints = 20
  extraPoints = 50
  names = randomName.Vailia
  base = if Math.random() < 0.65 then 'CrewMale' else 'CrewFemale'
  crew = new Person base, {
    name: randomName (if base is 'CrewMale' then names.male else names.female)
    growth: {}
  }
  points = basePoints + extraPoints * Math.random() * Math.random()
  while points > 1
    stat = Math.choice Person.mainStats
    amount = Math.ceil(points * 0.5)
    crew[stat] += amount
    crew.growth[stat] or= 0
    crew.growth[stat] += amount / 100
    points -= amount
  return crew

Person.base.CrewMale = new Person
  id: 'CrewMale'
  name: 'Crewman'
  gender: 'm'
  business: -10
  diplomacy: -10
  stealth: -15
  combat: -5
  happiness: 50
  endurance: 5
  level: 1
  growth: {}
  color:
    text: '#999999'
  images:
    impatient: 'game/content/scenes/player/tired.png'

Person.base.CrewFemale = new Person
  id: 'CrewFemale'
  name: 'Crewwoman'
  gender: 'f'
  business: -10
  diplomacy: -5
  stealth: -10
  combat: -15
  happiness: 50
  endurance: 5
  level: 1
  growth: {}
  color:
    text: '#999999'
  images:
    impatient: 'game/content/scenes/player/tired.png'
