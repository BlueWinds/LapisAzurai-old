maxLoad = (workers)->
  if g.weather is 'storm' then return 5 * workers
  return 15 * workers

buySellSchema =
  type: Collection
  properties: # Keyed by item name, each property is [price, increment]
    '*':
      type: 'array'
      items: [
        {type: 'integer', gt: 0} # Increment
        {type: 'integer'} # Price, relative to base value
      ]

Job.Market = class Market extends Job
  @schema:
    properties:
      buy: buySellSchema
      sell: buySellSchema

  label: "Visit Market"
  text: -> 'Buy and sell goods in the marketplace. Send crewmembers along to load and unload the ship.'
  officers:
    worker: {}
  energy: -1
  crew: 1
  # Items are in the form `name: [price, increment]`
  buy: new Collection
  sell: new Collection
  description: ->
    """<p>#{@worker} wandered the marketplace, searching for bargains and opportunities. #{if g.weather is 'calm' then "It was a pleasant day, so the area was well packed, everyone trying to get their business done before the next storm rolled in." else "Customers were rare in the blustry winds, the few brave souls clutching at their cloaks and hurrying through the winds. Vendors huddled in their stalls, and those with light or water-damageable merchandise had long since packed it away."}</p>"""

  valid: ->
    for key of @buy
      unless Item[key]
        console.log @
        throw new Error "Couldn't find Item #{key} for #{@constructor.name}.buy"
    for key of @sell
      unless Item[key]
        console.log @
        throw new Error "Couldn't find Item #{key} for #{@constructor.name}.sell"
    super()

incrementMultiplier = (increment, business)->
  increment *= 1 + business / 100
  if g.weather is 'storm'
    increment *= 0.5
  return Math.floor increment

Job.Market::next = Page.Market = class Market extends Page
  conditions:
    worker: {}
    market: '|location|jobs|market'
    workers: '|location|jobs|market|context|objectLength'

  text: ->
    business = @worker.get 'business', @
    buy = for name, [increment, price] of @market.buy
      item = Item[name]
      increment = incrementMultiplier increment, business
      item.buyRow increment, price
    sell = for name, [increment, price] of @market.sell
      item = Item[name]
      amount = g.cargo[name]
      increment = incrementMultiplier increment, business
      item.sellRow increment, price, amount
    for name, amount of g.cargo when not @market.sell[name]
      item = Item[name]
      sell.push item.sellRow undefined, undefined, amount

    cargoPercent = Math.sumObject(g.cargo) / Game.cargo * 100

    img = if g.weather is 'calm' then g.location.images.marketDay else g.location.images.marketStorm
    element = """<page class="screen" bg="#{img}">
      <form class="clearfix">
        <div class="col-lg-4 col-lg-offset-2 col-sm-6">
          <div class="buy column-block">
            <div class="block-label">#{@worker} buys...</div>
            <table>
              #{buy.join ''}
            </table>
          </div>
        </div>
        <div class="col-lg-4 col-sm-6">
          <div class="sell column-block">
            <div class="block-label">And Sells...</div>
            <table>#{sell.join ''}</table>
            <div class="block-summary">
              #{@workers.toWord().capitalize()} worker#{if @workers is 1 then '' else 's'} can carry <span class="carry">#{maxLoad(@workers)}</span> more loads today.
              <br>
              This will cost <span class="spend">0β</span> and earn <span class="earn">0β</span>, leaving you with <span class="result">#{g.officers.Nat.money}β</span>
            </div>
            <div class="block-summary">
              <div class="progress-label">The Lapis Azurai</div>
              <div class="progress"><div class="progress-bar" style="width: #{cargoPercent}%;"></div></div>
            </div>
          </div>
        </div>
      </form>
      <text class="short">
        #{@market.description.call @}
        #{options ['Done']}
        </text>
    </page>"""
    return applyMarket.call(@, element)

  next: false

applyMarket = (element)->
  element = $(element)
  buy = @market.buy
  sell = @market.sell
  context = @

  carry = maxLoad(@workers)
  cargo = Math.sumObject g.cargo

  business = @worker.get 'business', @

  $('.buy tr', element).each ->
    count = 0
    item = $(@).attr('item')
    increment = incrementMultiplier buy[item][0], business
    cost = buy[item][1]

    updateRow = =>
      newPrice = cost + Math.floor(count / increment)
      relativePrice = if newPrice > 0
        'high'
      else if newPrice < 0
        'low'
      else
        ''

      $('.count', @).html count
      if count
        $('.total', @).html Item[item].cost(increment, cost, count) + 'β'
      else
        $('.total', @).html ''
      $('.price', @).html newPrice + Item[item].price + 'β'
      $(@).removeClass('high low').addClass relativePrice
      return updateSummary()

    $('.plus', @).click =>
      if carry is 0 or cargo is Game.cargo then return
      carry--
      cargo++
      count++
      unless updateRow()
        $('.minus', @).click()

    $('.minus', @).click ->
      unless count then return
      carry++
      cargo--
      count--
      updateRow()

  $('.sell tr', element).each ->
    unless $('.plus', @).html() then return

    item = $(@).attr('item')
    available = g.cargo[item] or 0
    count = 0
    increment = incrementMultiplier sell[item][0], business
    cost = sell[item][1]

    updateRow = =>
      newPrice = cost - Math.floor(count / increment)
      relativePrice = if newPrice < 0
        'high'
      else if newPrice > 0
        'low'
      else
        ''

      $('.count', @).html count + '/' + available
      $('.total', @).html Item[item].cost(increment, cost, count, true) + 'β'
      $('.price', @).html newPrice + Item[item].price + 'β'
      $(@).removeClass('high low').addClass relativePrice
      return updateSummary()

    $('.plus', @).click ->
      if carry is 0 or count is available then return
      carry--
      cargo--
      count++
      updateRow()

    $('.minus', @).click =>
      if count is 0 or cargo is Game.cargo then return
      carry++
      cargo++
      count--
      unless updateRow()
        $('.plus', @).click()

  updateSummary = ->
    spend = Math.sum($('.buy .total', element).map -> parseInt($(@).html(), 10) or 0)
    earn = Math.sum($('.sell .total', element).map -> parseInt($(@).html(), 10) or 0)
    total = g.officers.Nat.money - spend + earn
    $('.spend', element).html spend + 'β'
    $('.earn', element).html earn + 'β'
    $('.result', element).html(total + 'β').toggleClass('negative', total < 0)
    $('.carry', element).html(carry).toggleClass('out', carry is 0)
    $('.progress-bar', element).css 'width', (cargo * 100 / Game.cargo) + '%'

    if total < 0 and total < g.officers.Nat.money
      $('button', element).attr('disabled', true)
    else
      $('button', element).removeAttr('disabled')
    return total >= 0

  $('button', element).click (e)->
    e.preventDefault()
    spend = Math.sum($('.buy .total', element).map -> parseInt($(@).html(), 10) or 0)
    earn = Math.sum($('.sell .total', element).map -> parseInt($(@).html(), 10) or 0)
    g.applyEffects {money: [(earn - spend), "Sold #{earn}β and bought #{spend}β in #{g.location}'s market"]}, context
    $('.buy tr', element).each ->
      count = parseInt $('.count', @).html(), 10 or 0
      unless count then return

      item = $(@).attr 'item'
      g.cargo[item] or= 0
      g.cargo[item] += count
    $('.sell tr', element).each ->
      count = parseInt $('.count', @).html(), 10 or 0
      unless $('.plus', @).html() and count then return

      item = $(@).attr 'item'
      g.cargo[item] -= count
      unless g.cargo[item]
        delete g.cargo[item]

    Game.gotoPage()
    return false

  return element
