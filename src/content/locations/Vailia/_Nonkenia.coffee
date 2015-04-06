Place.Nonkenia = Game::map.Nonkenia = class Nonkenia extends Place
  name: 'Nonkenia'
  description: "Despite a long-standing dispute with their Alkenian neighbors, Nonkenia maintains good relations with Vailia. Nonkenia considers itself the spiritual center for the continent, though their neighbors don't always agree. They export food and forest goods in return for manufactured goods."
  images:
    day: 'game/content/locations/Wilds/Forest Day.jpg'
    night: 'game/content/locations/Wilds/Forest Night.jpg'
    storm: 'game/content/locations/Wilds/Forest Storm.jpg'
    marketDay: 'game/content/locations/Wilds/Forest Day.jpg'
    marketNight: 'game/content/locations/Wilds/Forest Night.jpg'
    marketStorm: 'game/content/locations/Wilds/Forest Storm.jpg'
    tavern: Place.Vailia::images.tavern
  jobs: new Collection
  location: [3378, 1704]
  destinations: new Collection
    MountJulia: 12
    Alkenia: 3

Place.Nonkenia::jobs.market = Job.NonkeniaMarket = class NonkeniaMarket extends Job.Market
  buy: new Collection
    "Naval Supplies": [10, -6]
    Wood: [40, 1]
    Fur: [10, -15]
    Barley: [35, -1]
    Wheat: [15, -2]
  sell: new Collection
    "Maiden's Tea": [20, 16]
    "Vailian Steel": [14, 25]
    "Trade Tools": [8, 40]

  description: ->"""There's a bit of a nervous air among those dealing with #{@worker} - while not considered wrong, per-se, dealing with Vailian merchants seems to have a bit of a questionable character to the Nonkenians. Money is money, though."""
  next: Page.Market

Place.Nonkenia::jobs.rest = Job.NonkeniaRest = class NonkeniaRest extends Job
  officers:
    worker: {}
    worker2: {optional: true}
    worker3: {optional: true}
  label: 'Rest'
  text: ->"""Stroll through the forest - it's safe here, the locals claim, despite appearances."""
  energy: 3
  next: Page.randomMatch
  @next: []

Job.NonkeniaRest.next.push Page.NonkeniaRest = class NonkeniaRest extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    --
"""
