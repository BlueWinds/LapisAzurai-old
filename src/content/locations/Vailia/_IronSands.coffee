Place.IronSands = Game::map.IronSands = class IronSands extends Place
  name: 'Iron Sands'
  description: "Little more than a mining camp owned by Vailian interests, Iron Sands is an inhospitable and rocky shore kept open only by the constant demand for metals and supply of necessities from the city."
  images:
    day: 'game/content/locations/Town/Port Desert Day.jpg'
    night: 'game/content/locations/Town/Port Desert Night.jpg'
    storm: 'game/content/locations/Town/Port Desert Storm.jpg'
    marketDay: 'game/content/locations/Town/Port Desert Day.jpg'
    marketNight: 'game/content/locations/Town/Port Desert Night.jpg'
    marketStorm: 'game/content/locations/Town/Port Desert Storm.jpg'
    tavern: Place.Vailia::images.tavern
  jobs: new Collection
  location: [3471, 1948]
  destinations: new Collection
    Vailia: 12
    MountJulia: 12

Place.IronSands::jobs.market = Job.IronSandsMarket = class IronSandsMarket extends Job.Market
  buy: new Collection
    "Naval Supplies": [10, 16]
    Wood: [40, 10]
    Fish: [6, 2]
    Beer: [5, 4]
    Iron: [20, -7]
  sell: new Collection
    Charcoal: [30, 10]
    "Trade Tools": [8, 20]
    Wood: [10, 4]
    Beer: [10, 3]
    Wheet: [15, 1]

  description: ->"""Iron Sands is named not only for the rich red sand that covers the beach and cliffs, but also for the way the sands corrode anything that touches them. It's not a pleasant place to visit, but bringing supplies to the minors and returning with their metallic wealth back to Vailia is a lucrative route."""
  next: Page.Market

Place.IronSands::firstVisit = Page.VisitIronSands = class VisitIronSands extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="day"
    -- Natalie shielded her eyes from the sun and hugged her jacket closer around her. Wind bit through the cloth, whipped her hair into her eyes. How a place could be both so blindingly bright and yet so cold at the same time was a mystery to her, one she had no real desire to solve. Finally, in frustration, she pulled on a storm-hat just to keep her hair out of her eyes.

  ||
    --> There was not a single plant in sight anywhere on the beach, dark sand unbroken except for a stone pier and single small warehouse sticking out into the water. Half a dozen people waited for them on there, ropes in hand to help them dock against the wind. A hundred yards back from the water rose cliffs, sheer and of the same dark tan stone as the beach, a hundred feet high. A path had been laborously cut into the side of the cliff, narrow and treacherous switchbacks. Against the dusty sky she could see buildings at the top - that must be the main camp.

  ||
    -- The Lapis nosed against the pier, bobbing in choppy water and gusty, unpredictable wind. While the crew tied it down with ropes tossed up from the dock, Natalie hopped over to speak with the woman in charge. James followed.

  ||
    --> She was rough, as tall as James and heavier, weather beaten and tanned. Her appearance reflected the whole camp, aged despite still being young. She passed off the line she was hauling on as Natalie and James approached, turning to greet them. <q>Tell your crew to stay on the ship or get up on the cliffs as soon as they're done mooring. I'm Leeta,</q> she yelled at Natalie to be heard over the wind and extended a hand to shake. Natalie waved James back to the ship to make sure everyone heard. Leeta's grip was crushing. They ran for the warehouse, a good place for a short conversation before the arduous trek up the cliff.

  ||
    -- <q>Now, I know you're not an idiot, no captain is, but I'm going to give you the same lecture I give all the new miners, so you can repeat it to your crew. I don't want anyone getting hurt and saying I didn't warn you, ok?</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}Got it. I'm Natalie Rowena, nice to meet you.</q>

  ||
    -- <q>That's nice, now shut up and listen. The sand and stone here eats at everything, and it gets in everywhere. It'll burn bare skin right quick. Don't walk in sand unless you have to, wear heavy boots, iron-shod is best. If I catch anyone in short sleeves, I'll throw 'em off the cliff myself. Sweep off your deck every night, and sweep out any room you're going to sleep in. It's not as bad up on the cliffs, so stay up there as much as you can. Now the nice bit is that there're no pests and no dangerous creatures, so don't worry about that even though we're awefully exposed without a wall - humans and our donkeys are the only things that can live here. Also no spirits and no demons. They don't like the sand any more than plants do. You can go anywhere you like, but you're an idiot if you go anywhere except the dock and the camp. Clear?</q>

  ||
    #{@Natalie.image 'upset', 'left'}
    -- #{q}Sounds like hell.</q>

  ||
    --> <q>Only if hell makes you rich. You want my advice, get what you came for and leave as soon as you can. Pretty face like yours doesn't need scars.</q>

  ||
    --> <em>+1 damage to the ship and <span>-1 energy</span> for all officers every day spent in Iron Sands.</em>
"""
