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
    "Maiden's Tea": [15, 12]
    "Naval Supplies": [10, 0]
    Wood: [40, -4]
    Charcoal: [8, -14]
    Barley: [25, 0]
    Wheat: [15, 0]
  sell: new Collection
    "Maiden's Tea": [20, 12]
    "Vailian Steel": [14, 15]
    "Wool Cloth": [20, 10]
    "Trade Tools": [8, 25]

  description: ->"""<p>There's an excited air in the market as Natalie explores - a definite sense of eyes upon her, all the merchants waiting to see what she's brought and hoping for a chance to buy from or sell to her. While Vailia is only two weeks away by ship, that's still further than most people will travel in their lifetimes.</p>"""
  next: Page.Market

Place.Alkenai::firstVisit = Page.AlkenaiArrive = class AlkenaiArrive extends Page
  text: ->"""<page bg="#{g.location.images.day}">
    <text><p>Excited shouts and waving arms guided the Azurai into dock at Alkenai, one of Vailia's primary trading partners. Another free city, Alkenai nestled in the arms of an encircling mountain, stone bluffs trailing into the sea on either side of the city and providing protection from storms. A stream ran down the valley though the center of town fed by springs further up the slope. The Alkenians made their livings from the forest and the shore, supplying Vailia with timber in return for steady shipments manufactured goods or other items from farther afield – without the vast and relatively safe forests, Natalie's homeland would be unable to keep a significant navy afloat against the terrible attrition of the open ocean.</p></text>
  </page>
  <page>
    <text><p>For those reasons, and others, the arrival of a ship from the east was always a welcome sight. A gaggle of children stood gaping at them as sailors hopped down from the Azurai and began to secure it to the wharf. A man bearing a clipboard and a pen waited patiently for Natalie to disembark.</p></text>
  </page>
  <page>
  <page>
    #{g.officers.James.image 'normal', 'center'}
    <text continue><p>The instant he set foot on the dock James was swarmed by children. Looking somewhat bewildered as he tried to answer their queries all at once. He looked at Natalie for help, but she just waved with one hand and smiled.</p></text>
  </page>
    <text><p><q>Name, ship name, port of origin, docking fee?</q></p></text>
  </page>
  <page>
    #{g.officers.Nat.image 'normal', 'left'}
    <text continue><p>She rattled off the answers and pressed a coin into his palm. Somewhat more valuable than strictly necessary for the docking fee. Always good to make a friend.</p></text>
  </page>
  <page>
    <text continue><p><q>Very well. Is there anything else I can help you with, Ms?</q> He nodded, unscrewing the lid on his inkwell to jot down a few notes.</p></text>
  </page>
  <page>
    #{g.officers.Nat.image 'normal', 'left'}
    <text><p>#{q}No, thank you. A local guide would not be amiss, but I wouldn't want to impose.</q></p></text>
  </page>
  <page>
    <text continue><p><q>I'm sure any one of the little scoundrels harassing your husband would be happy to help.</q></p></text>
  </page>
  <page>
    #{g.officers.Nat.image 'normal', 'left'}
    <text continue><p>#{q}He's not... ah, yes, thank you.</q> She decided it wasn't worth arguing over.</p></text>
  </page>"""
