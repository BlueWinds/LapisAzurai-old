Place.Ship = Game::map.Ship = class Ship extends Place
  name: 'Lapis Azurai'
  description: ->"<p>Vailia is a bustling port city, famous for its political neutrality, its freedom from the disasters that plague lesser cities, and its brothels. Lots and lots of brothels.</p>"
  images:
    day: 'game/content/locations/Ship/Sailing Day.jpg'
    night: 'game/content/locations/Ship/Sailing Night.jpg'
    storm: 'game/content/locations/Ship/Sailing Storm.jpg'
    cabinDay: 'game/content/locations/Ship/Cabin Day.jpg'
    cabinNight: 'game/content/locations/Ship/Cabin Night.jpg'
    cabinStorm: 'game/content/locations/Ship/Cabin Storm.jpg'
    deckDay: 'game/content/locations/Ship/Deck Day.jpg'
    deckNight: 'game/content/locations/Ship/Deck Night.jpg'
    deckStorm: 'game/content/locations/Ship/Deck Storm.jpg'

  cargo: new Collection
  destinations: new Collection
  jobs: new Collection # Unlike normal locations, this collection takes ShipJobs rather than normal Jobs
  location: [0, 0]
  @cargoSpace: 100

Ship::jobs.talk = ShipJob.Talk = class Talk extends ShipJob
  label: "Talk with Crew"
  text: ->"""<p>Spend some time mingling with the crew, encouraging and hanging out.</p>
  <p>Crew: <span class="happiness">+1 happiness</span></p>"""
  next: Page.randomMatch
  @next: []

ShipJob.Talk.next.push Page.ShipTalk = class ShipTalk extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{g.map.Ship.images.deckNight}">#{@Nat.image 'normal', ''}<text>
    <p>Natalie pokes her head in on the evening festivities - while she often prefers to spend time in her cabin, alone or with a few other offciers, it's nice to enjoy the wide open air as well from time to time.</p>
    <p><em>Crew: <span class="happiness">+1 happiness</span></em></p>
  </text></page>"""
  apply: -> for i, sailor of g.crew then sailor.add('happiness', 1)

Ship::jobs.trainCombat = ShipJob.TrainCombat = class TrainCombat extends ShipJob
  label: "Mock Combat"
  text: ->"""<p>Run a mock battle with the crew.</p>
  <p>Crew: <span class="combat">+1 combat</span><br>James: <span class="energy">-2 energy</span></p>"""

ShipJob.TrainCombat::next = Page.TrainCombat = class TrainCombat extends Page
  conditions:
    James: '|officers|James'
  text: ->"""<page bg="#{g.map.Ship.images.day}">#{@James.image 'angry', ''}<text>
    <p>James divides the crew up into two teams - half of them practice boarding while the others repel using oars and poles wrapped in cloth as weapons. It's still unbelievably noisy as some of the sailors get very much into the spirit, with battle cries and dramatic 'death scenes' as they're slain.</p>
    <p><em>Crew: <span class="combat">+1 combat</span><br>James: <span class="energy">-2 energy</span></em></p>
  </text></page>"""
  apply: ->
    for i, sailor of g.crew then sailor.add('combat', 1)
    @context.James.add('energy', -2)

Ship::jobs.trainBusiness = ShipJob.TrainBusiness = class TrainBusiness extends ShipJob
  label: "Lessons"
  text: ->"""<p>Teach the sailors a tiny bit about the larger world.</p>
  <p>Crew: <span class="business">+1 business</span><br>Natalie: <span class="happiness">+1 happiness</span>, <span class="energy">-1 energy</span></p>"""

ShipJob.TrainBusiness::next = Page.TrainBusiness = class TrainBusiness extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{g.map.Ship.images.deckDay}">#{@Nat.image 'normal', ''}<text>
    <p>While the world may be a vast place, the officers of the Lapis are some of the most well-traveled and educated individuals in it - Natalie can read and write, for example, which places her in the top 25% of the Vailian population, much less other nations. A bit of teaching is a fun way to pass the time.</p>
    <p><em>Crew: <span class="business">+1 business</span><br>Natalie: <span class="happiness">+1 happiness</span>, <span class="energy">-1 energy</span></em></p>
  </text></page>"""
  apply: ->
    for i, sailor of g.crew then sailor.add('business', 1)
    @context.Nat.add('energy', -1)
    @context.Nat.add('happiness', 1)

Ship::jobs.trainSailing = ShipJob.TrainSailing = class TrainSailing extends ShipJob
  label: "Maintenence"
  text: ->"""<p>Repairing the Lapis will help the crew learn to work together better.</p>
  <p>Crew: <span class="sailing">+1 sailing</span>, <span class="happiness">-1 happiness</span><br>Natalie: <span class="energy">-2 energy</span></p>"""

ShipJob.TrainSailing::next = Page.TrainSailing = class TrainSailing extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{g.map.Ship.images.day}">#{@Nat.image 'serious', ''}<text>
    <p>Scrubbing the deck is hardly the most glamerous work, but that and a flurry of other menial tasks are necessary to keep a sailing vessel in proper shape - it's not just make-work when all their lives can depend on whether someone slips or not.</p>
    <p><em>Crew: <span class="sailing">+1 sailing</span>, <span class="happiness">-1 happiness</span><br>Natalie: <span class="energy">-2 energy</span></em></p>
  </text></page>"""
  apply: ->
    for i, sailor of g.crew
      sailor.add('sailing', 1)
      sailor.add('happiness', -1)
    @context.Nat.add('energy', -2)
