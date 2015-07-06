Place.IronSands = Game::map.IronSands = class IronSands extends Place
  name: 'Iron Sands'
  description: """Little more than a mining camp owned by Vailian interests, Iron Sands is an inhospitable and rocky shore kept open only by the constant demand for metals and supply of necessities from the city.
  <em><span class='energy'>-1 energy</span>, <strong class='damage'>+1 ship damage</strong> every day</em>"""
  images:
    day: 'game/content/locations/Town/Port Desert Day.jpg'
    night: 'game/content/locations/Town/Port Desert Night.jpg'
    storm: 'game/content/locations/Town/Port Desert Storm.jpg'
    marketDay: 'game/content/locations/Town/Port Desert Day.jpg'
    marketNight: 'game/content/locations/Town/Port Desert Night.jpg'
    marketStorm: 'game/content/locations/Town/Port Desert Storm.jpg'
    tavern: Place.Vailia::images.tavern
  jobs: new Collection
  location: [1471, 1948]
  destinations: new Collection
    Vailia: 12
    MountJulia: 12

Place.IronSands::jobs.market = Job.IronSandsMarket = class IronSandsMarket extends Job.Market
  buy: new Collection
    "Naval Supplies": [10, 16]
    Wood: [40, 10]
    Fish: [6, 2]
    Beer: [5, 4]
    Iron: [16, -7]
  sell: new Collection
    Charcoal: [30, 10]
    "Trade Tools": [8, 20]
    Wood: [10, 4]
    Beer: [10, 3]
    Wheat: [15, 1]

  description: ->"""Iron Sands is named not only for the rich red sand that covers the beach and cliffs, but also for the way the sands corrode anything that touches them. It's not a pleasant place to visit, but bringing supplies to the minors and returning with their metallic wealth back to Vailia is a lucrative route."""
  next: Page.Market

Game.passDay.push ->
  if g.location isnt g.map.IronSands or g.atSea() then return
  for name, officer of g.officers
    officer.add 'energy', -1
  g.map.Ship.damage += 1

Place.IronSands::firstVisit = Page.VisitIronSands = class VisitIronSands extends Page
  conditions:
    Nat: '|officers|Nat'
    Cara: '|people|Cara'
  text: ->"""|| bg="day"
    -- Natalie shielded her eyes from the sun and hugged her jacket closer around her. Wind bit through the cloth, whipped her hair into her eyes, blew grit into her mouth if she opened it at the wrong moment. How a place could be both so blindingly bright and yet so cold at the same time was a mystery to her, one she had no real desire to solve. Finally, in frustration, she pulled on a storm-hat just to keep her hair out of her eyes.

  ||
    -- There wasn't a single plant in sight anywhere in sight, dark sand unbroken except for a stone pier and single small warehouse sticking out into the water. Half a dozen people waited for them on there, ropes in hand to help them dock against the wind. A hundred yards back from the water rose cliffs, sheer and of the same dark tan stone as the beach, a hundred feet high. A path had been laborously cut into the side of the cliff, narrow and treacherous switchbacks. Against the dusty sky she could see buildings at the top - that must be the main camp.

  ||
    -- The Lapis nosed against the pier, bobbing in choppy water and gusty, unpredictable wind. While the crew tied it down with ropes tossed up from the dock, Natalie hopped over to speak with the woman in charge. James followed.

  ||
    #{@Cara.image 'normal', 'right'}
    --> She was rough, as tall as James and heavier, weather beaten and tanned. Her appearance reflected the whole camp, aged despite still being young. She passed off the line she was hauling on as Natalie and James approached, turning to greet them. #{q}Tell your crew to stay on the ship or get up on the cliffs as soon as they're done mooring. I'm Cara,</q> she yelled at Natalie to be heard over the wind and extended a hand to shake. Natalie waved James back to the ship to make sure everyone heard. Cara's grip was crushing. They ran for the warehouse, a good place for a short conversation before the arduous trek up the cliff.

  ||
    #{@Cara.image 'normal', 'right'}
    -- #{q}Now, I know you're not an idiot, no captain is, but I'm going to give you the same lecture I give all the new miners, so you can repeat it to your crew. I don't want anyone getting hurt and saying I didn't warn you, ok?</q>

  ||
    #{@Nat.image 'normal', 'left'}
    --> #{q}Got it. I'm Natalie Rowena, nice to meet you.</q>

  ||
    #{@Cara.image 'serious', 'right'}
    -- #{q}That's nice, now shut up and listen. The sand here eats at everything, and it gets in everywhere. It'll burn bare skin right quick. Don't walk in sand unless you have to, wear heavy boots, iron-shod is best. If I catch anyone in short sleeves, I'll throw 'em off the cliff myself. Sweep off your deck every night, and sweep out any room you're going to sleep in. It's not as bad up on the cliffs, so stay up there as much as you can. Now the nice bit is that there're no pests and no dangerous creatures, so don't worry about that even though we're awefully exposed without a wall - humans and our donkeys are the only things that can live here. Also no spirits and no demons. They don't like the sand any more than plants do. You can go anywhere you like, but you're an idiot if you go anywhere except the dock and the camp. Clear?</q>

  ||
    #{@Nat.image 'upset', 'left'}
    -- #{q}Sounds like hell.</q>

  ||
    #{@Cara.image 'normal', 'right'}
    --> #{q}Only if hell makes you rich. You want my advice, get what you came for and leave as soon as you can. Pretty face like yours doesn't need scars.</q>

  ||
    #{@Cara.image 'normal', 'right'}
    --> <em>+1 damage to the ship and <span>-1 energy</span> for all officers every day spent in Iron Sands.</em>
"""

Place.IronSands::jobs.rest = Job.IronSandsRest = class IronSandsRest extends Job.Beach
  text: ->"""There's not much to do in Iron Sands other than drink and gamble."""
  @next: []

Job.IronSandsRest.next.push Page.IronSandsRest = class IronSandsRest extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    #{@worker.image 'normal', 'left'}
    -- #{@worker} flopped onto the couch and rested #{his} head against the padded surface. Even in here, in the bunkhouse that served as an inn for the miners, grit was everywhere, and when #{he}'d complained about it to the proprieter, #{he}'d only gotten a pittying look and the repeated promise that the place was swept twice a day.

  ||
    --> Still, it was immensely better than being outside, and the beer was decent as well as being reasonably cold. It had an odd tang to it, not entirely unpleasant. The chatter of miners eager for a new voice finally coaxed #{him} into sharing news of home, and listened eagerly to every story #{he} brought. It wasn't so bad, really.
  """

Job.IronSandsRest.next.push Page.IronSandsRestJames = class IronSandsRestJames extends Page
  conditions:
    worker: {is: Officer.James}
    '|officers|Kat': {}
    James: '|officers|James'
    Cara: '|people|Cara'
    '|events|IronSandsRestJames': false
  text: ->"""|| bg="day|storm"
    #{@James.image 'blush', 'left'}
    -- James swallowed and stared at his beer, not daring to look up. A half-occupied bunkhouse served as the tavern here in Iron Sands. He'd come for a drink, but now couldn't relax. every time he'd looked up he was being stared at. Not by most people, happy to mind their own business, just, with unnerving intensity by...

  ||
    #{@Cara.image 'normal', 'right'}
    --> #{q}Cara,</q> she loomed over him, finally tired of simply staring. James shook her offered hand, and she sat down across from him. She had a strong grip. #{q}What're you doing in my town, cute stuff?</q>

  ||
    #{@James.image 'blush', 'left'}
    -- It took him a moment to realize he was being flirted with, not antagonized. James snapped his mouth shut. #{q}I'm the quartermaster on the Lapis Azurai,</q> he finally managed.

  ||
    #{@Cara.image 'normal', 'right'}
    --> #{q}Yes, James. Natalie mentioned I might find you here. I see you've settled on imported liquor - good call. The stuff Teddy brews is fine once you're already drunk, but I'd never start with it.</q>

  ||
    #{@James.image 'normal', 'left'}
    -- #{q}It's almost like there's a bit of lime in here? I'm guessing that's the taste of the dust. Not bad, though.</q>

  ||
    #{@Cara.image 'normal', 'right'}
    --> #{q}That's a bet you'd win. But anyway, want to come back to my place and talk about it more? I've got a cabin, much nicer than sharing a bunk with someone.</q>

  ||
    #{@James.image 'normal', 'left'}
    -->#{q}No thanks. I, um, I don't sleep around.</q> James took a deep drink to hide his face for a moment. He'd almost, almost, gotten that out without stammering  like an idiot.

  ||
    #{@Cara.image 'sad', 'right'}
    -- Cara didn't say anything, and finally he was forced to lower the cup or look even more awkward. She was studying him, an odd half-smile on her face. She lay a hand over his on the table and she shook her head. #{q}She doesn't like you that way, kid.</q> James blushed and looked down, and she removed her hand from his. #{q}None of my business, I know. Just make sure you're not throwing away gold looking for diamonds.</q>
  """
