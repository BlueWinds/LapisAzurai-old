Game.passDay.push ->
  if g.day % 7 then return

  change = if g.officers.Nat.money <= 0 then -1 else 0
  wages = 0
  for name, person of g.officers
    wages += person.wages()
  if wages
    g.applyEffects {money: [-wages, 'Paid officers']}

  wages = 0
  for name, person of g.crew
    wages += person.wages()
  if wages
    g.applyEffects {money: [-wages, 'Paid crew']}

  change += if g.officers.Nat.money < 0 then -1 else 1
  for name, person of g.crew
    person.add 'happiness', change, new Collection
  for name, person of g.officers when person.wages()
    person.add 'happiness', change, new Collection

Game.passDay.push ->
  if g.dayOfMonth is 0
    g.queue.unshift new Page.Financial

Game::money = []
Game.schema.properties.money =
  type: 'array' # A ~28-day history of expenses
  items:
    type: 'object'
    properties:
      day:
        type: 'integer'
        gt: 0
      amount:
        type: 'integer'
      reason:
        type: 'string'

Page.Financial = class Financial extends Page
  text: ->
    while g.money[0]?.day < (g.day - 30)
      g.money.shift()

    day = g.day
    expenses = for t in g.money
      g.day = t.day
      "<tr><td>#{g.month} #{g.season} #{g.dayOfMonth}</td><td class='#{if t.amount < 0 then 'high' else 'low'}'>#{t.amount}</td><td>#{t.reason}</td></tr>"
    g.day = day

    missions = for key, mission of g.missions
      "<li>#{mission.label}</li>"

    """<page bg="#{g.map.Ship.images.cabinNight}">
      <div class="col-sm-4 col-sm-offset-2">
        <div class="expenses column-block">
          <div class="block-label">The last month</div>
          <table>
            #{expenses.join ''}
          </table>
        </div>
      </div>

      <div class="col-sm-4">
        <div class="column-block">
          <ul class="mission-summary">
            #{missions.join ''}
          </ul>
        </div>
      </div>
    </page>"""
