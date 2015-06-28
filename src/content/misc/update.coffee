Game.update.push {post: ->
  updateColors = (person)->
    unless person.color then return
    for color, i in person.color
      if color is 'coffee' then person.color[i] = 'mocha'
      if color is 'chocolate' then person.color[i] = 'ebony'

  for name, person of @officers then updateColors(person)
  for name, person of @crew then updateColors(person)
  return
}

Game.update.push {post: ->
  if @officers.Nat.color.length < 5 then @officers.Nat.color.push 'none'

  @money ?= @officers.Nat.money

  for name, person of @crew
    person.contract = 30 + Math.floor(Math.random() * 120)
  for name, person of @map.Vailia.jobs.hireCrew.hires
    person.contract = 60 + 30 * Math.floor(Math.random() * 10)
  return
}

Game.update.push {
  pre: ->
    if @.last._ is 'Page|DefenseNothing'
      @.last = {_: 'Page|Port'}
  post: ->
    delete @events.DefenseNothing
}

Game.update.push {
  pre: ->
    # Create placeholder classes temporarily, just so the game loads successfully
    Trait.SilverTongue = class SilverTongue extends Trait
    Trait.Shy = class Shy extends Trait

  post: ->
    for name, person of @officers
      delete person.diplomacy
    for name, person of @crew
      delete person.diplomacy
      delete person.traits.SilverTongue
      delete person.traits.Shy
    for name, person of @map.Vailia.jobs.hireCrew.hires
      delete person.diplomacy
      delete person.traits.SilverTongue
      delete person.traits.Shy

    delete Trait.Shy
    delete Trait.SilverTongue
}

Game.update.push { # Repair an issue where ship damage may have been set to NaN
  post: -> @map.Ship.damage or= 0
}
