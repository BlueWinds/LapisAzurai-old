# Setting up a whole bunch of global functions to make rendering pages more convenient.
# lastP is always the most recent person one of these functions has been called with - using this as a default argument makes possible things like "#{He @CrewMember} hands #{his} cup to her." - notice how the second use doesn't require an argument.
lastP = null
window.q = (person = lastP)->
  lastP = person
  return "<q style='color: #{person.text or '#FFF'}'>"
q.toString = q

# Minor linguistic note - events have to be written in the male form in code because his->her, him->her are impossible to tell apart from the feminine side.
window.he = (p = lastP)-> lastP = p; if p.gender is 'f' then 'she' else 'he'
window.He = (p = lastP)-> lastP = p; if p.gender is 'f' then 'She' else 'He'
window.him = (p = lastP)-> lastP = p; if p.gender is 'f' then 'her' else 'him'
window.his = (p = lastP)-> lastP = p; if p.gender is 'f' then 'her' else 'his'
window.His = (p = lastP)-> lastP = p; if p.gender is 'f' then 'Her' else 'His'
window.boy = (p = lastP)-> lastP = p; if p.gender is 'f' then 'girl' else 'boy'
window.man = (p = lastP)-> lastP = p; if p.gender is 'f' then 'woman' else 'man'
he.toString = he
He.toString = He
him.toString = him
his.toString = his
His.toString = His
boy.toString = boy
man.toString = man

statSchema = {type: 'number', gte: 0, lte: 100}

window.Person = class Person extends GameObject
  @stats:
    happiness: "Happiness<br>How content a person is serving on the Lapis Azurai. If it's below 20, they'll consider leaving the crew."
    business: "Business<br>Knowledge of goods, prices, book keeping and other parts of making a profit."
    diplomacy: "Diplomacy<br>Charm, wit or intimidation factor, whatever makes someone want to agree to a deal."
    sailing: "Sailing<br>Ships, sails, winds and waves, the knowledge and experience of dealing with the ocean."
    combat: "Combat<br>When the going gets tough, the tough get going."
  @imgLayers: ['base', 'skin', 'eyes', 'hair', 'top']
  @schema:
    type: @
    strict: true
    properties:
      name:
        type: 'string'
      gender:
        type: 'string'
        pattern: /^[mf]$/
      # Optional color names for each layer, looked up in {PersonClass}.colors
      color:
        type: 'array'
        items:
          type: ['string', 'boolean']
        optional: true
      description:
        # description can be a string so that random characters can have the chosen one "stuck" to them.
        type: ['string', 'function']
      happiness: statSchema
      business: statSchema
      diplomacy: statSchema
      sailing: statSchema
      combat: statSchema
      contract: # How many days the character is planning on staying with the crew.
        type: 'integer'
        optional: true

  # Each Person subclass should have @images and optionally @colors.

  happiness: 0
  business: 0
  diplomacy: 0
  sailing: 0
  combat: 0
  description: 'If you see this in-game, it is a bug.'

  image: (label, classes = '')->
    lastP = @
    src = @constructor.images[label]
    unless src
      throw new Error "Can't find image '#{label}' for #{@}"

    div = $ "<div class='#{classes} person'></div>"

    unless @constructor.colors
      div.append "<img src='game/sprites/#{@constructor.name}/#{label}.png'>"
      return div[0].outerHTML

    for layer, path of src
      div.append "<img src='game/sprites/#{@constructor.name}/#{label}-#{layer}-#{@color[layer]}.png'>"

    return div[0].outerHTML

  renderBlock: (key, classes = '')->
    stats = for stat in ['business', 'diplomacy', 'sailing', 'combat']
      "<span class='#{stat}'>#{@[stat]}</span>"

    fullStats = for stat in ['happiness', 'business', 'diplomacy', 'sailing', 'combat'] when @[stat]?
      """<tr class='#{stat}'><td>#{stat.capitalize()}</td><td>#{@[stat]}</td></tr>"""
    if @energy?
      fullStats.unshift """<tr><td class="energy">Energy</td><td>
        <span class="energy">#{@energy}</span>/<span class="endurance">#{@endurance}</span>
      </td></tr>"""
    fullStats.push """<tr class="wages" title="Wage<br>How much Natalie pays this person daily"><td>Wage</td><td>#{@wages()}</td></tr>"""
    if @money?
      fullStats.push """<tr class="savings" title="Savings<br>How much money this person has saved"><td>Money</td><td>#{@money}</td></tr>"""

    traits = for name, trait of @traits
      trait.renderBlock(@)

    return """<div data-key="#{key}" class="person-info #{classes}">
      <div class="name" style="color: #{@text};">#{@name}</div>
      #{if @energy? then '<div class="energy">' + @energy + '</div>' else ''}
      <div class="stats">#{stats.join ''}</div>
      <div class="full">
        <div class="name">#{@name}</div>
        <table class="stats">#{fullStats.join ''}</table>
        #{@image 'normal'}
        <div class="description">#{@description?() or @description}</div>
        <div class="traits">#{traits.join ''}</div>
      </div>
    </div>"""

  toString: ->
    lastP = @
    return @name

  wages: ->
    wage = 0.5
    for stat in ['business', 'diplomacy', 'sailing', 'combat']
      wage += @[stat] / 20
    if @traits
      for key, trait of @traits when trait.wages
        wage = if typeof trait.wages is 'function'
          trait.wages(@, wage)
        else
          wage * trait.wages
    return Math.round wage

Game.schema.properties.crew =
  type: Collection
  items:
    type: Person
Game.schema.properties.people =
  type: Collection
  items:
    type: Person
Game::crew = new Collection
Game::people = new Collection

$ ->
  c = $ '#content'
  # Bail out if we're not in the live game page
  unless c.length then return

  c.on 'mouseenter', '.person-info', ->
    parentWidth = $(@).parent().width()
    if $(@).position().left < parentWidth / 2
      $('.full', @).removeClass 'right'
    else
      $('.full', @).addClass 'right'

Page.schema.properties.stat = # If this page uses next = Page.statCheck, then its "stat" and "difficulty" properties determine what's checked.
  type: 'string'
  optional: true
  match: Object.keys(Person.stats).join '|'
Page.schema.properties.difficulty =
  type: 'integer'
  gte: 1
  optional: true

statCheckChances = (stat, diff, context)->
  sum = 1
  if context
    sum += Page.sumStat stat, context
  else
    sum += Page.sumStat stat, g.officers
    sum += Page.sumStat stat, g.crew
  chances = {
    veryBad: Math.pow(diff / (sum * 2), 2)
    bad: diff / sum
    good: sum / diff
    veryGood: Math.pow(sum / (diff * 2), 2)
  }
  normalize = Math.sumObject(chances)
  for key, value of chances
    chances[key] /= normalize
  return chances

Page.statCheck = ->
  items = @constructor.next
  chances = statCheckChances(@stat, @difficulty)
  r = Math.random()

  r -= chances.veryBad
  if items.veryBad and r <= 0
    return items.veryBad
  r -= chances.bad
  if r <= 0
    return items.bad
  r -= chances.good
  if r <= 0
    return items.good
  return items.veryGood or items.good

Page.statCheckDescription = (stat, difficulty, items, context)->
  chances = statCheckChances(stat, difficulty, context)
  percent = (chance)-> Math.round(chance * 100) + '%'
  results = []

  if items.veryGood
    results.push "Very Good: #{percent chances.veryGood}"
    results.push "Good: #{percent chances.good}"
  else
    results.push "Good: #{percent chances.good + chances.veryGood}"
  if items.veryBad
    results.push "Bad: #{percent chances.bad}"
    results.push "Very Bad: #{percent chances.veryBad}"
  else
    results.push "Bad: #{percent chances.bad + chances.veryBad}"

  return "<span class='#{stat}'>#{stat.capitalize()}</span>, difficulty #{difficulty}:
  <ul class='stat-check'>
    <li>" + results.join('</li><li>') + '</li>
  </ul>'
