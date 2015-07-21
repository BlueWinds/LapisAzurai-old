Game::map.Tomenoi = Place.Tomenoi = class Tomenoi extends Place
  name: 'Tomenoi'
  description: ->"""Originally a Kantian military outpost, Tomenoi is now dominated by the Vailian trading post that grew up around it. It remains little more than a safe place to rest in the otherwise open ocean.
  <em>-1β daily</em>"""
  images:
    day: 'game/content/locations/Town/Port Desert Day.jpg'
    night: 'game/content/locations/Town/Port Desert Night.jpg'
    storm: 'game/content/locations/Town/Port Desert Storm.jpg'
    marketDay: 'game/content/locations/Town/Port Desert Day.jpg'
    marketStorm: 'game/content/locations/Town/Port Desert Storm.jpg'
  location: [1774, 1742]
  jobs: new Collection
  destinations: new Collection
    Vailia: 12

Page.LibraryTravel.next.push Page.LibraryTravelTomenoi = class LibraryTravelTomenoi extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="marketDay|marketStorm"
    -- With some careful searching of various travel journals and map fragments, and the (un)help of a thorny librarian, #{@worker} managed to find and copy down the details of a new route. With a detailed chart and location, the Lapis could now travel to another destination.

    <strong>Tomenoi</strong> is a trading post halfway between Vailia and Kantis. It's mostly used as a stopover point between the two nations, though they'll buy wood, Vailian steel and tools at a decent markup.
  """
  apply: ->
    super()
    g.mapImage = '5 - Tomenoi.png'
    g.map.Vailia.destinations.Tomenoi = 10

Game.passDay.push ->
  if g.location isnt g.map.Tomenoi or g.atSea() then return
  g.applyEffects {money: -1}

Place.Tomenoi::jobs.market = Job.TomenoiMarket = class TomenoiMarket extends Job.Market
  buy: new Collection
    "Naval Supplies": [10, 5]
    Wood: [15, 10]
    Fish: [10, 1]
    Barley: [5, 3]
    Coffee: [10, -4]
    Wine: [10, -6]
  sell: new Collection
    Wood: [25, 8]
    "Maiden's Tea": [20, 6]
    "Vailian Steel": [20, 15]
    "Trade Tools": [25, 20]
    Weapons: [10, 15]
    Paper: [25, 3]
  description: ->"""Everything bought and sold here is either on its way to Kantis or Vaila, though Kantian ships seldom brave the open sea between to Vailia."""
  next: Page.Market

Place.Tomenoi::firstVisit = Page.VisitTomenoi = class VisitTomenoi extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="storm"
    -- The keel shifted under Natalie's guidance, and the Lapis turned briefly into the wind before settling down on the other tack. She frowned in concentration - if the wind had been blowing any harder against them, she'd have settled for weighing anchor in the harbor and conducting business by boat. But the ship felt good under her hands, the crew confident and cheerful, so an upwind docking into the space between two other ships it was.
  ||
    --> A small crowd gathered to watch them come in, shouting advice, encouragement, or in a few cases, warning them off. Natalie ignored the noise, spun the wheel, shouted to the crew.

  ||
    -- #{q @Nat}That's it, strike the sails!</q> Coasting forward on its momentum, the Lapis dipped between two of the ships already docked and inched forwards towards the pier. The crew tossed lines to the dockworkers, and suddenly everyone was shouting and hauling on ropes and pulling against the wind that wanted to push the Lapis sideways into one of the nearby ships.

  ||
    --> All in all, a rather graceful arrival given the circumstances. Natalie grinned at Kat, at James, at #{Math.choice g.crew}, and hopped onto the pier.

  ||
    --| Tomenoi was an odd combination of bustling and dreary. The buildings looked like they could use a fresh coat of paint to hide the dirt, and the streets weren't so much "streets" as they were "beaten paths in the dust." But at the same time, those who greeted her were cheerful and loud, a mix of Vailian sailors and captains slapping her on the back and Alkenian merchants and townfolks keeping a more respectful distance.

  ||
    --> She hadn't seen more than a few Alkenians in her life before now. Their ships were square rigged, solid but slow, making the journey to Vailia rather arduous for them. The few she had seen were mostly wealthy or powerful - the sort that could afford to take a month or more away from their affairs for a vacation at the center of the known world. The Alkenians were generally darker than the Vailians, golden skin and deep brown or black waves.

  ||
    --> Some of the crowd were darker still, the color of polished wood. They might be desert folk, Natalie guessed, stretching her brain to remember old lessons about Kantis. Something about nomads and moon gods and land-feuds? Definitely something to read up on when she got back to Vailia.

  ||
    --> <q>Welcome to Tomenoi. Docking fee 2 obols per day,</q> His accent was heavy on the vowels and emphasis, but still easily understandable.

  ||
    --> Expensive. Natalie quirked an eyebrow at the man holding out his hand. #{q @Nat}I'll give you a half.</q>

  ||
    --> <q>One and a half, and I make sure no one tries unload same time you do.</q>

  ||
    --> #{q @Nat}You're kidding me. At Alkenia it's a quarter. Vailia doesn't even have a fee.</q>

  ||
    --> <q>One obol. Those cities don't have to import food and everything else.</q>

  ||
    --> Natalie dug in her pocket. Better than anchoring in the bay and wasting time trying to move cargo by longboat.

  ||
    --> <em>-1β daily</em>
"""

Place.Tomenoi::jobs.rest = Job.TomenoiRest = class TomenoiRest extends Job.Beach
  text: ->"""Take a break from the bustle of the tiny, packed little trading post and explore the island a bit."""
  @next: []

Job.TomenoiRest.next.push Page.TomenoiRest = class TomenoiRest extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    -- Following a well-worn path alongside the stream, #{@worker} left the trading post and explored up towards its source. #{He} soon found a spring, bubbling out from the side of a mossy boulder into a pleasant little pool. Shaded by trees, the glen was cool and sheltered. A simple wrought iron bench sat near the pool.

  ||
    --> Something about the spring itself caught #{@worker}'s attention, and #{he} took a closer look. Bending down, he saw that it was resting on a smooth, flat surface - and the closer #{he} looked, the more convinced #{he} became that it wasn't natural. The final piece of the puzzle was a series of faint scratches, half hidden by the moss and worn by time.

  ||
    -- <q>...flow eternally, as a symbol of our dedication that this may never happen again.
      - Archmage Rheia
      8th of Ascending Fire, year 23 of the new era</q>
  """
