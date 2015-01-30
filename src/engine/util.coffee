
String.rate = (string)-> switch string
  when 1 / 10 then 'a tenth'
  when 1 / 5 then 'a fifth'
  when 1 / 4 then 'a quarter'
  when 1 / 3 then 'a third'
  when 1 / 2 then 'half'
  when 2 / 3 then 'two thirds'
  when 3 / 4 then 'three quarters'
  when 8 / 10 then '80%'
  when 9 / 10 then '90%'
  when 1 then 'normal'
  when 2 then 'twice'
  when 3 then 'three times'
  when 4 then 'four times'
  when 5 then 'five times'
  when 10 then 'ten times'
  else string.toString()

Object.defineProperty Number.prototype, 'toWord', { value: -> switch Number(@)
  when 0 then 'zero'
  when 1 then 'one'
  when 2 then 'two'
  when 3 then 'three'
  when 4 then 'four'
  when 5 then 'five'
  when 6 then 'six'
  else Number(@).toString()
}

Object.defineProperty String.prototype, 'capitalize', { value: ->
  @charAt(0).toUpperCase() + @slice(1)
}

Object.defineProperty Array.prototype, 'wordJoin', {value: ->
  str = @slice(0, -1).join(', ')
  str += ' and ' + @[@length - 1]
  return str
}

Math.sum = (items)->
  sum = 0
  for val in items
    sum += val
  return sum

Math.sumObject = (items)->
  sum = 0
  for key, val of items
    sum += val
  return sum

Math.randomRound = (number)->
  result = Math.floor(number)
  if Math.random() < number % 1 then result += 1
  return result

Math.keyChoice = (items)->
  if items instanceof Array
    choice = Math.floor(Math.random() * items.length)
    return choice
  return Math.choice(Object.keys items)

Math.choice = (items)->
  return items[Math.keyChoice items]

Math.weightedChoice = (weights)->
  sum = Math.sumObject weights
  choice = Math.floor(Math.random() * sum)
  for key, value of weights
    choice -= value
    if choice <= 0 then return key

String.randomName = (names, maxLength = 7)->
  [chains, start] = String.randomName.chains(names)

  string = Math.choice(start).split('')

  newLetter = ->
    last = string[string.length - 3] + string[string.length - 2] + string[string.length - 1]
    next = Math.choice(chains[last])
    return next

  while string[string.length - 1] and string.length <= maxLength
    string.push(newLetter())

  string.pop()
  string[0] = string[0].toUpperCase()
  return string.join('')

String.randomName.chains = (names)->
  # Building the Markov chains
  chains = {}
  start = []

  names.forEach (name)->
    start.push(name.substr(0, 3).toLowerCase())
    for i in [0 .. name.length - 3]
      token = name.substr(i, 3).toLowerCase()
      next = name[i + 3]
      chains[token] or= []
      chains[token].push(next?.toLowerCase())

  return [chains, start]

window.toggle = (options, selected)->
  options = optionList options, selected
  return """<span class="btn-group toggle">#{options.join ''}</span>"""

window.bigOptions = (options, selected)->
  options = optionList options, selected
  join = '</div><div class="col-md-4 col-xs-6">'
  return """<div class="bigOptions row"><div class="col-md-4 col-xs-6">#{options.join join}</div></div>"""

window.dropdown = (options, selected)->
  lis = optionList options, selected
  return """<button type="button" class="btn btn-default dropdown-toggle inline">#{options[selected]}</button>
  <span class="dropdown-menu inline">
    <span>#{lis.join '</span><span>'}</span>
  </span>"""

window.options = (texts, titles = [])->
  buttons = for text, index in texts
    """<button class="btn btn-default" title="#{titles[index] or ""}">#{text}</button>"""
  return "<options>#{buttons.join("\n")}</options>"

optionList = (options, selected)->
  name = 'o-' + Math.random()
  options = for key, option of options
    _id = 'o-' + Math.random()
    checked = if selected is key then 'checked' else ''
    """<input type="radio" id="#{_id}" value="#{key}" #{checked} name="#{name}"><label for="#{_id}">#{option}</label>"""
  return options
