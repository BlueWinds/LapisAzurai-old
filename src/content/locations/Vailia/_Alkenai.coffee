Place.Alkenai = Game::map.Alkenai = class Alkenai extends Place
  name: 'Alkenai'
  description: "<p>Alkenai is the closest real settlement to Vailia. While nominally independent, it's firmly under Vailia's influence and welcomes merchant with open arms, since they often bring valuable manufactured goods.</p>"
  images:
    day: 'game/content/locations/Town/Port Day.jpg'
    night: 'game/content/locations/Town/Port Night.jpg'
    storm: 'game/content/locations/Town/Port Storm.jpg'
    marketDay: 'game/content/locations/Town/Port Day.jpg'
    marketStorm: 'game/content/locations/Town/Port Storm.jpg'
    tavern: Place.Vailia::images.tavern
  jobs: new Collection
  location: [3418, 1732]
  destinations: new Collection
    MountJulia: 9

Place.Alkenai::jobs.market = Job.AlkenaiMarket = class AlkenaiMarket extends Job.Market
  buy: new Collection
    "Maiden's Tea": [15, 13]
    "Naval Supplies": [10, 8]
    Wood: [40, 4]
    Charcoal: [8, 7]
    Barley: [25, 5]
    Wheat: [15, 6]
  sell: new Collection
    "Maiden's Tea": [20, 12]
    "Vailian Steel": [14, 25]
    "Wool Cloth": [20, 9]
    "Trade Tools": [10, 35]

  description: ->"""<p>There's an excited air in the market as Natalie explores - a definite sense of eyes upon her, all the merchants waiting to see what she's brought and hoping for a chance to buy from or sell to her. While Vailia is only two weeks away by ship, that's still further than most people will travel in their lifetimes.</p>"""
  next: Page.Market
