
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
  when 2 then 'twice'
  when 3 then 'three times'
  when 4 then 'four times'
  when 5 then 'five times'
  when 10 then 'ten times'
  else string

$.fn.winkIn = (speed, done = $.noop)->
  div = $ @
  height = div.outerHeight()
  width = div.outerWidth()

  start = "rect(#{height * 0.5}px #{width}px #{height * 0.5}px 0px)"
  end = "rect(0px #{width}px #{height}px 0px)"

  div.css {clip: start}
  div.show().animate {clip: end}, speed, ->
    div.css {width: "", height: "", clip: "", position: ""}
    done()

$.fn.winkOut = (speed, done = $.noop)->
  div = $ @
  height = div.outerHeight()
  width = div.outerWidth()

  start = "rect(0px #{width}px #{height}px 0px)"
  end = "rect(#{height * 0.5}px #{width}px #{height * 0.5}px 0px)"

  div.css {clip: start}
  div.animate {clip: end}, speed, ->
    div.hide().css {width: "", height: "", clip: "", position: ""}
    done()

Math.sumProperty = (property, items)->
  sum = 0
  for key, val of items when typeof val[property] is 'number'
    sum += val[property]
  return sum

Math.choice = (items)->
  choice = Math.floor(Math.random() * items.length)
  return items[choice]

window.randomName = (chains, maxLength = 7)->
  if chains instanceof Array
    chains = randomName.chains chains

  string = Math.choice(Object.keys(chains)).split ''

  newLetter = ->
    last = string[string.length - 3] + string[string.length - 2] + string[string.length - 1]
    next = Math.choice chains[last]
    return next

  while string[string.length - 1] and string.length <= maxLength
    string.push newLetter()

  string.pop()
  string[0] = string[0].toUpperCase()
  return string.join('')

randomName.chains = (names)->
  # Building the Markov chains
  chains = {}

  names.forEach (name)->
    for i in [0 .. name.length - 3]
      token = name.substr(i, 3).toLowerCase()
      next = name[i + 3]
      chains[token] or= []
      chains[token].push next?.toLowerCase()

  return chains
