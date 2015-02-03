window.Item = class Item extends GameObject
  @schema:
    type: @
    strict: true
    properties:
      name:
        type: 'string'
      description:
        type: 'function'
      price:
        type: 'integer'
        gte: 1
      unit:
        type: 'string'
      weight:
        type: 'number'
        gte: 0

  buyRow: (basePrice, increment, bought)->
    currentPrice = @buyPrice(basePrice, increment, bought)
    relativePrice = if currentPrice > @price then "high" else if currentPrice < @price then "low" else ""
    type = switch
      when @ instanceof Luxury then 'luxury'
      when @ instanceof Food then 'food'
      else "trade"

    return """<tr item="#{@name}">
      <td class="title #{type}" title="#{type.capitalize()} - #{@description}">#{@name}</td>
      <td class="price #{relativePrice}" title="First #{increment} #{@unit}s available at #{basePrice + @price}β (valued in Vailia at #{@price}β)">#{currentPrice}β</td>
      <td class="plus">+</td>
      <td class="count">#{bought}</td>
      <td class="minus">-</td>
      <td class="total">#{if bought then @buyCost(basePrice, increment, bought) + 'β' else ''}</td>
    </tr>"""

  sellRow: (basePrice, increment, sold, available)->
    console.log @name, increment
    currentPrice = if basePrice? then @sellPrice(basePrice, increment, sold) else @price
    relativePrice = if currentPrice < @price then "high" else if currentPrice > @price then "low" else ""
    type = switch
      when @ instanceof Luxury then 'luxury'
      when @ instanceof Food then 'food'
      else "trade"

    return """<tr item="#{@name}">
      <td class="title #{type}" title="#{type.capitalize()} - #{@description}">#{@name}</td>""" +
    (if basePrice?
      """<td class="price #{relativePrice}" title="First #{increment} #{@unit}s can be sold at #{basePrice + @price}β (valued in Vailia at #{@price}β)">#{currentPrice}β</td>
      <td class="plus">+</td>
      <td class="count">#{if available then sold + '/' + available else '--'}</td>
      <td class="minus">-</td>"""
    else
      """<td class="price #{relativePrice}" title="Valued in Vailia at #{@price}β">--</td>
      <td class="count" colspan=3>#{if available then available else ''}</td>""") +
    """<td class="total">#{if sold then @sellCost(basePrice, increment, sold) + 'β' else ''}</td>
    </tr>"""

  buyPrice: (basePrice, increment, amount)->
    inc = Math.floor(amount / increment)
    price = Math.ceil (@price + basePrice) * (1 + inc / 10)
    return Math.max price, (@price + basePrice + inc)

  sellPrice: (basePrice, increment, amount)->
    inc = Math.floor(amount / increment)
    price = Math.ceil (@price + basePrice) * (1 - inc / 10)
    return Math.max 1, Math.min(price, (@price + basePrice - inc))

  buyCost: (basePrice, increment, amount)->
    total = 0
    for i in [0...amount]
      total += @buyPrice basePrice, increment, i
    return total

  sellCost: (basePrice, increment, amount)->
    total = 0
    for i in [0...amount]
      total += @sellPrice basePrice, increment, i
    return total

  amount: (count)->
    if count is 1 then "1 #{@unit}" else "#{count} #{@unit}s"

window.Luxury = class Luxury extends Item
window.Food = class Food extends Item

Item.costDescription = (cost)->
  items = for item, amount of cost when Item[item] and amount
    left = g.cargo[item] - amount
    item = Item[item]
    "#{item.name.capitalize()}: #{-amount} (#{item.amount(left)} left)"
  return items.join(', ')
