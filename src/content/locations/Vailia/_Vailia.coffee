Job.VailiaHireCrew = class VailiaHireCrew extends Job.HireCrew
  @hireClasses: [Person.VailianCrewM, Person.VailianCrewF, Person.VailianCrewM2, Person.VailianCrewF2]

Job.VailiaMarket = class VailiaMarket extends Job.Market
  buy: new Collection
    Fish: [50, 0]
    Barley: [15, 0]
    "Wool Cloth": [10, 0]
    Wood: [40, 0]
    "Naval Supplies": [20, 0]
    "Maiden's Tea": [12, 0]
    Salt: [3, 0]
    Beer: [15, 0]
    Wine: [5, 0]
    "Vailian Steel": [10, 0]
    "Trade Tools": [4, 0]
  sell: new Collection
    Barley: [40, 0]
    Wood: [40, 0]
    Wheat: [40, 0]
    "Naval Supplies": [20, 0]
    Charcoal: [10, 0]

Place.Vailia = Game::map.Vailia = class Vailia extends Place
  name: 'Vailia'
  description: "<p>Vailia is a bustling port city, famous for its brothels. Also its political neutrality, freedom from the disasters that plague lesser cities, and its merchant-navy. But mostly for its sex workers.</p>"
  images:
    day: 'game/content/locations/Vailia/Port Day.jpg'
    night: 'game/content/locations/Vailia/Port Night.jpg'
    storm: 'game/content/locations/Vailia/Port Storm.jpg'
    marketDay: 'game/content/locations/Vailia/Market Day.jpg'
    marketNight: 'game/content/locations/Vailia/Market Night.jpg'
    marketStorm: 'game/content/locations/Vailia/Port Storm.jpg'
    tavern: 'game/content/locations/Vailia/Tavern.jpg'
    guildOffice: 'game/content/locations/Vailia/Guild Office.jpg'
  majorPort: true
  jobs: new Collection
    hireCrew: Job.VailiaHireCrew
    market: Job.VailiaMarket
  location: [3600, 1831]
  destinations: new Collection
    MountJulia: 7

Place.Vailia::jobs.beach = Job.Beach = class Beach extends Job
  officers:
    worker: {}
    worker2: {optional: true}
    worker3: {optional: true}
  conditions:
    '|weather': {eq: 'calm'}
  label: 'Beach'
  text: ->"""Visit the beach - a great way to relax and restore your energy."""
  energy: 3
  next: Page.randomMatch
  @next: []

Job.Beach.next.push Page.BeachWood = class BeachWood extends Page
  conditions:
    worker: {}
    '|season': {eq: 'Wood'}
  text: ->"""<page bg="#{g.location.images.day}">
    <text><p>With Descending Water finally behind them, many Vailians greeted the returning warmth with a visit to the beach, and #{@worker} was no exception. Gentle waves lapped against smooth sand, wetting the feet of hundreds of visitors. Not for long though – the air was pleasantly warm, but not enough to dispel the water's chill. Playing in the sand was the order of the day.</p>
  </text>
  </page>
  <page>
    <text><p>#{@worker} entered a sand castle contest, constructing #{Math.choice [
      "an elaborate moat and castle, carefully sculpted to resemble Vailia's palace"
      "a sandship, prow facing proudly towards the ocean"
      "the largest pile of sand " + he + " could manage, enlisting the help of several on lookers, before smoothing it out into a pyramid"
    ]}. Though it wasn't the winning entry, #{he} certainly enjoyed #{him}self.</p></text>
  </page>"""

Job.Beach.next.push Page.BeachFire = class BeachFire extends Page
  conditions:
    worker: {}
    '|season': {eq: 'Fire'}
  text: ->"""<page bg="#{ g.location.images.day}">
    <text><p>The hot days of #{g.month} Fire demanded nothing other than a visit to the beach, and #{@worker} was perfectly obliging towards such a demand. #{He} was also obliging towards another demand – that #{he} join in a game of volleyball, to make the teams even. Win, lose or draw - #{he} honestly lost track when the game devolved into a giggling wrestling match, with the entirely of the other team running under the net to tackle them into the sand.</p></text>
  </page>"""

Job.Beach.next.push Page.BeachEarth = class BeachEarth extends Page
  conditions:
    worker: {}
    '|season': {eq: 'Earth'}
  text: ->"""<page bg="#{g.location.images.day}">
    <text><p>Stealing one of the final days of warmth from #{g.month}, #{@worker} took a walk along the beach. It was nearly empty at this time of year, weather uncertain and plenty of work to be done before the cold arrived, leaving #{@worker} plenty of space for #{his} wanderings.</p></text>
  </page>
  <page>
    <text continue><p>Collecting a couple of shells, #{he} finally settled on a single beautiful spiral. There wasn't much room aboard the Azurai for personal possessions, so memories of a beautiful walk and the single memento would have to be enough.</p></text>
  </page>"""

Job.Beach.next.push Page.BeachWater = class BeachWater extends Page
  conditions:
    worker: {}
    '|season': {eq: 'Water'}
  text: ->"""<page bg="#{g.location.images.day}">
    <text><p>In the biting cold of #{g.month} Water the beach was completely deserted, leaving #{@worker} alone with #{his} thoughts. #{He} sat and watched the waves roll in for a while, before finally spotting another watcher of the waves. They walked together for a while, saying nothing, merely enjoying the company of another human. Finally the #{Math.choice ['old man', 'old woman', 'young man', 'young woman', 'girl', 'boy']} returned to the city, and #{@worker} did the same shortly after.</p></text>
  </page>"""
