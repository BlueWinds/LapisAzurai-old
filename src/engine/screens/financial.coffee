Game.passDay.push ->

  change = if g.officers.Nat.money <= 0 then -0.25 else 0
  wages = 0
  for name, person of g.officers
    wages += person.wages()

  for name, person of g.crew
    wages += person.wages()
  if wages
    g.applyEffects {money: [-wages, 'Paid crew']}

  change += if g.officers.Nat.money < 0 then -0.25 else 0.25
  for name, person of g.crew
    person.add 'happiness', change

#   g.queue.unshift new Page.Financial

Game::money = []
Game.schema.properties.money =
  type: 'array' # An approximately 30-day history of expenses
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

    """<page bg="Ship.cabinNight">
      <div class="col-md-4 col-md-offset-2 col-sm-6">
        <div class="expenses column-block">
          <div class="block-label">The last month</div>
          <table>
            #{expenses.join ''}
          </table>
        </div>
      </div>

      <div class="col-md-4 col-sm-6">
        <div class="column-block">
          <div class="block-label">Current Missions</div>
          <ul class="mission-summary">
            #{missions.join ''}
          </ul>
        </div>
      </div>
    </page>"""
