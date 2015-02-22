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
