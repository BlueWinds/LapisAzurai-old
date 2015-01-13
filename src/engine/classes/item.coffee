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

  buyRow: (increment, price)->
    relativePrice = if price > @price then "high" else if price < @price then "low" else ""
    """<tr class="#{relativePrice}" item="#{@name}">
      <td class="title" title="#{@description}">#{@name}</td>
      <td class="price" title="#{increment} #{@unit}s available at #{price}β (normally valued at #{@price}β)">#{price}β</td>
      <td class="plus">+</td>
      <td class="count">0</td>
      <td class="minus">-</td>
      <td class="total"></td>
    </tr>"""

  sellRow: (increment, price, available)->
    console.log @.name, increment, price, available
    relativePrice = if price < @price then "high" else if price > @price then "low" else ""
    """<tr class="#{relativePrice}" item="#{@name}">
      <td class="title" title="#{@description}">#{@name}</td>""" +
    (if price
      """<td class="price" title="#{increment} #{@unit}s can be sold at #{price}β (normally valued at #{@price}β)">#{price}β</td>
      <td class="plus">+</td>
      <td class="count">#{if available then '0/' + available else '--'}</td>
      <td class="minus">-</td>"""
    else
      """<td class="price" title="Normally valued at #{@price}β">--</td>
      <td class="count" colspan=3>#{if available then available else ''}</td>""") +
    """<td class="total"></td>
    </tr>"""

  cost: (increment, price, amount, selling)->
    total = 0
    currentPrice = price
    while amount > increment
      total += currentPrice * increment
      amount -= increment
      if selling then currentPrice-- else currentPrice++
    total += currentPrice * amount
    return total

  amount: (count)->
    if count is 1 then "1 #{@unit}" else "#{count} #{@unit}s"

window.LuxuryGood = class LuxuryGood extends Item
window.Food = class Food extends Item

Item.costDescription = (cost)->
  items = for item, amount of cost when Item[item] and amount
    left = g.cargo[item] - amount
    item = Item[item]
    "#{item.name.capitalize()}: #{-amount} (#{item.amount(left)} left)"
  return items.join(', ')
