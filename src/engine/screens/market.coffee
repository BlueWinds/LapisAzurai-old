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
    """#{@worker} wandered the marketplace, searching for bargains and opportunities. #{if g.weather is 'calm' then "It was a pleasant day, so the area was well packed, everyone trying to get their business done before the next storm rolled in." else "Customers were rare in the blustry winds, the few brave souls clutching at their cloaks and hurrying through the winds. Vendors huddled in their stalls, and those with light or water-damageable merchandise had long since packed it away."}"""

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
      item.buyRow price, increment, 0
    sell = for name, [increment, price] of @market.sell
      item = Item[name]
      amount = g.cargo[name]
      increment = incrementMultiplier increment, business
      item.sellRow price, increment, 0, amount
    for name, amount of g.cargo when not @market.sell[name]
      item = Item[name]
      sell.push item.sellRow undefined, undefined, 0, amount

    cargoPercent = Math.sumObject(g.cargo) / Game.cargo * 100

    form = """<form class="clearfix">
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
            This will cost <span class="spend">0β</span> and earn <span class="earn">0β</span>, leaving you with <span class="result">#{g.money}β</span>
          </div>
          <div class="block-summary">
            <div class="progress-label" title="#{Math.sumObject g.cargo} / #{Game.cargo}">The Lapis Azurai</div>
            <div class="progress"><div class="progress-bar" style="width: #{cargoPercent}%;"></div></div>
          </div>
        </div>
      </div>
    </form>""".replace(/\n/g, '')

    element = """|| class="screen" bg="marketDay|marketStorm"
      #{form}

      --. #{@market.description.call @}
      #{options ['Done']}
    """
    return applyMarket.call(@, element)

  next: false

applyMarket = (element)->
  element = $.render(element)
  buy = @market.buy
  sell = @market.sell
  context = @

  carry = maxLoad(@workers)
  cargo = Math.sumObject g.cargo

  business = @worker.get 'business', @

  buying = {}
  $('.buy tr', element).each ->
    item = $(@).attr('item')
    buying[item] =
      bought: 0
      increment: incrementMultiplier buy[item][0], business
      cost: buy[item][1]

  updateRow = (row, newRow)->
    row.children('.price').replaceWith newRow.children('.price')
    row.children('.count').replaceWith newRow.children('.count')
    row.children('.total').replaceWith newRow.children('.total')

  $('.buy .plus', element).on 'click do', (e)->
    if carry is 0 or cargo is Game.cargo then return

    item = $(@).parent().attr('item')
    buyData = buying[item]

    carry--
    cargo++
    buyData.bought++
    newRow = $(Item[item].buyRow buyData.cost, buyData.increment, buyData.bought)
    updateRow($(@).closest('tr'), newRow)
    unless updateSummary()
      $('.buy tr[item="' + item + '"] .minus', element).click()

  $('.buy .minus', element).on 'click do', (e)->
    item = $(@).parent().attr('item')
    buyData = buying[item]
    unless buyData.bought then return

    carry++
    cargo--
    buyData.bought--
    newRow = $(Item[item].buyRow buyData.cost, buyData.increment, buyData.bought)
    updateRow($(@).closest('tr'), newRow)
    updateSummary()

  $('.buy, .sell', element).on 'mousedown touchstart', '.plus, .minus', (e)->
    item = $(@).parent().attr('item')
    plus = if $(@).hasClass('plus') then 'plus' else 'minus'
    buy = if $(@).closest('.buy').length then 'buy' else 'sell'
    id = setInterval ->
      if item
        $('.' + buy + ' tr[item="' + item + '"] .' + plus, element).trigger('do')
    , 150
    $('body').one 'mouseup touchend touchcancel', ->
      item = false
      clearInterval(id)

  selling = {}
  $('.sell tr', element).each ->
    unless $('.plus', @).html() then return

    item = $(@).attr('item')
    selling[item] =
      sold: 0
      available: g.cargo[item] or 0
      increment: incrementMultiplier sell[item][0], business
      cost: sell[item][1]

  $('.sell', element).on 'click do', '.plus', (e)->
    item = $(@).parent().attr('item')

    sellData = selling[item]
    if carry is 0 or sellData.sold is sellData.available then return

    carry--
    cargo--
    sellData.sold++
    row = $(@).closest 'tr'
    row.replaceWith $(Item[item].sellRow sellData.cost, sellData.increment, sellData.sold, sellData.available)
    updateSummary()

  $('.sell', element).on 'click do', '.minus', (e)->
    item = $(@).parent().attr('item')
    sellData = selling[item]
    if sellData.sold is 0 or cargo is Game.cargo then return

    carry++
    cargo++
    sellData.sold--
    row = $(@).closest 'tr'
    row.replaceWith $(Item[item].sellRow sellData.cost, sellData.increment, sellData.sold, sellData.available)
    unless updateSummary()
      $('.sell tr[item="' + item + '"] .plus', element).click()

  updateSummary = ->
    spend = Math.sum($('.buy .total', element).map -> parseInt($(@).html(), 10) or 0)
    earn = Math.sum($('.sell .total', element).map -> parseInt($(@).html(), 10) or 0)
    total = g.money - spend + earn
    $('.spend', element).html spend + 'β'
    $('.earn', element).html earn + 'β'
    $('.result', element).html(total + 'β').toggleClass('negative', total < 0)
    $('.carry', element).html(carry).toggleClass('out', carry is 0)
    $('.progress-label', element).tooltip('destroy').attr('title', "#{cargo} / #{Game.cargo}").addTooltips()
    $('.progress-bar', element).css 'width', (cargo * 100 / Game.cargo) + '%'

    if total < 0 and total < g.money
      $('button', element).attr('disabled', true)
    else
      $('button', element).removeAttr('disabled')
    element.addTooltips()
    return total >= 0 or total >= g.money

  $('button', element).click (e)->
    e.preventDefault()
    spend = Math.sum($('.buy .total', element).map -> parseInt($(@).html(), 10) or 0)
    earn = Math.sum($('.sell .total', element).map -> parseInt($(@).html(), 10) or 0)
    g.applyEffects {money: (earn - spend)}, context
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
