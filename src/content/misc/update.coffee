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

  @money = @officers.Nat.money

  for name, person of @crew
    person.contract = 30 + Math.floor(Math.random() * 120)
  for name, person of @map.Vailia.jobs.hireCrew.hires
    person.contract = 60 + 30 * Math.floor(Math.random() * 10)
}
