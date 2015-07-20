Place.Nonkenia = Game::map.Nonkenia = class Nonkenia extends Place
  name: 'Nonkenia'
  description: "Despite a long-standing dispute with Alkenia, Nonkenia considers itself a spiritual center, though its neighbors don't always agree. They export food and forest goods in return for manufactured goods."
  images:
    day: 'game/content/locations/VailiaEnvirons/Forest Day.jpg'
    night: 'game/content/locations/VailiaEnvirons/Forest Night.jpg'
    storm: 'game/content/locations/VailiaEnvirons/Forest Storm.jpg'
    marketDay: 'game/content/locations/VailiaEnvirons/Forest Day.jpg'
    marketNight: 'game/content/locations/VailiaEnvirons/Forest Night.jpg'
    marketStorm: 'game/content/locations/VailiaEnvirons/Forest Storm.jpg'
    tavern: Place.Vailia::images.tavern
  jobs: new Collection
  location: [1378, 1704]
  destinations: new Collection
    MountJulia: 12
    Alkenia: 3

Page.LibraryTravel.next.push Page.LibraryTravelNonkenia = class LibraryTravelNonkenia extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="marketDay|marketStorm"
    -- With some careful searching of various travel journals and map fragments, and the (un)help of a thorny librarian, #{@worker} managed to find and copy down the details of a new route. With a detailed chart and location, the Lapis could now travel to another destination.

    After passing through Alkenia, one can reach <strong>Nonkenia</strong>, Alkenia's rival city and spiritual center of the continent. Though they stubbornly maintain their independence, they still welcome Vailian merchants and the quality manufactured goods they bring, with a special interest in weapons and other metalwork.
  """
  apply: ->
    super()
    g.mapImage = '3 - Nonkenia.png'
    g.map.Alkenia.destinations.Nonkenia = 3
    g.map.MountJulia.destinations.Nonkenia = 10

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
    Weapons: [15, 15]

  description: ->"""There's a nervous air among those dealing with #{@worker}. While not considered wrong, per se, dealing with Vailian merchants seems to be a bit unsavory to the Nonkenians. Money is money, though."""
  next: Page.Market

Place.Nonkenia::firstVisit = Page.VisitNonkenia = class VisitNonkenia extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="night"
    -- The Lapis arrived late at night, slipping silently into the sheltered bay that Natalie's maps insisted was the center of Nonkenia. It was hard to believe that this empty expanse of sand, much like hundreds of others they'd already sailed past, was something special.

  ||
    --> The signs were there, though; obvious enough to careful eyes as the crew lowered the anchors. There was no dock, but the beach was broken with ridges and piles of sand, as though heavy objects had been dragged over it recently. And the forest was thinner, less overgrown. Natalie would bet good money that trails leading inland would be visible in the morning.

  ||
    -- Lowering a boat into the water, Natalie felt as if eyes were twinkling at them from the edge of the forest, a feeling confirmed as soon as they set foot on the beach, when an old man emerged from his hiding place to greet them.

  ||
    --> <q>Good evening. May I request an hour of your time before you enter the forest? It is dangerous at this time of night.</q> Cracked and wizened with age, Natalie found his voice disturbing, threatening even, but pushed down her reaction and forced a smile.

  ||
    #{@Nat.normal 'left'}
    --> #{q}Of course. I'm Natalie, this is James, and...</q>

  ||
    -- <q>Stop! Do not share your names so freely. Some might think you tried to ensnare them into reciprocating. Not me, of course. I am used to the ways of foreigners and know you mean no harm.</q> He gave a dry chuckle, and Natalie bit her tongue to avoid saying anything unfriendly. <q>What brings you to the shores of Nonkenia?</q>

  ||
    #{@Nat.uncertain 'left'}
    --> #{q}We come seeking opportunity for trade and mutual profit. I have a cargo hold full of things I think you might be interested in. But I was expecting a city, and all I see is an empty beach?</q>

  ||
    -- He chuckled again, and she couldn't help feeling like she was being mocked. <q>Of course you do. I'd be a fool to expect anything else from a Vailian. It's too much to hope that you'd come to visit one of our grand temples, or repent for some devilry or other...</q> He continued to mutter as he took a jar at his hip and popped off the lid. Dipping a finger in, he reached towards her, something sticky looking - honey perhaps - dripping from his finger. <q>Bend down. There's a good girl. I'm not as tall as I used to be.</q>

  ||
    --> She did as he asked, and he left a sticky dot on her forehead. He swatted away her finger when she reached up to wipe it away.

  ||
    -- <q>There you go, girl. The forest isn't dangerous anymore. For you. As long as you take the left trail, then left fork, then right. Got that? Left, left, right.</q> Another dry chuckle, a sound Natalie was beginning to thoroughly loathe. <q>Anyone else who feels like walking to the city, come and take your turn. You can wipe it off once you're inside the city, but make sure you get anointed again before you try to return to the ship. It'd be a shame if some of you didn't make it back.</q>
"""

Place.Nonkenia::jobs.rest = Job.NonkeniaRest = class NonkeniaRest extends Job.Beach
  text: ->"""Stroll through the forest. It's safe here, the locals claim, despite appearances."""
  @next: []

Job.NonkeniaRest.next.push Page.NonkeniaRest = class NonkeniaRest extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    #{@worker.normal 'left'}
    -- #{@worker} meandered through Nonkenia, exploring the area and people-watching. Eventually #{he} found himself in a quieter part of the town, out of sight of the main roads and walking through increasingly narrow passages between poorly maintained buildings.

  ||
    --> A building of a different sort caught #{his} eye - stone, ancient stone, weathered with a light coating of moss in some places and rivulets carved down the surface of the rock by untold years of rain. The door was open, and from the dimly lit recesses wafted the scent of a pleasant wood fire. #{@worker} entered.

  ||
    -- The doorway opened to a small chamber, windowless, lit only by a small fire. Curls of smoke drifted towards a hole in the ceiling, and opposite the entrance sat an old woman. The patched shawl wrapped over her shoulders had seen better days.

  ||
    --> #{q}Hello?</q> #{@worker} greeted her, falling silent as the old woman looked up with a rheumy stare.

  ||
    --> She shook her slowly head and looked back down at her fire. <q>You're not the one I'm waiting for, but you are welcome to join me if you wish.</q>

  ||
    #{@worker.normal 'left'}
    -- Strangely compelled by the scene, #{@worker} took a seat. #{q}What is this place? It's much older than the rest of the city.</q>

  ||
    --> She smiled. <q>It is. Much older. I don't know how old, don't ask,</q> she interrupted the upcoming question with a dry chuckle. <q>I just know that this place is waiting for someone and you are not it. My grandson will be back soon to take his turn at the watch. You should meet him, he's a nice boy.</q>

  ||
    --> #{q}How will you know who it's waiting for when they get here?</q>

  ||
    -- <q>I'll know.</q>

  ||
    -- <q>I'll know.</q> She shrugged. <q>Well, probably not me. But my grandson, or his child, or his great-great grandson. We've watched this place for so long now, what's a few more centuries?</q> She repeated the shrug, fed the fire another log.
"""

Job.NonkeniaRest.next.push Page.NonkeniaRestHunters = class NonkeniaRestHunters extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    #{@worker.normal 'left'}
    -- Blinking, #{@worker} stepped back into the bushes from which #{he} had just come. Half a dozen men and women stood in the clearing just ahead, gathering at the front door of a hut and applying paint to eachother's faces. Each of them was armed with a spear, and two little girls walked around passing out javelins.

  ||
    --> Uncertain that #{he} wanted anything to do with this, #{@worker} was about to turn back for the ship when a hand tugged at #{his} pants. #{he} he looked down to find a trio of young boys looking up expectantly. <q>You have to go into the hut.</q>

  ||
    #{(@worker.serious or @worker.uncertain) 'left'}
    -- #{q}What's in the hut?</q> #{He} glanced - a little nervously, #{he} had to admit - at the stone structure where a war party was gathering.

  ||
    --> <q>The hunt-fire. Since you're here, you have to bow to it and say the rite, or they won't catch anything.</q>

  ||
    #{@worker.normal 'left'}
    --> #{@worker} nodded, relieved. A hunting party sounded much nicer than a war party. Given the recent troubles between Alkenia and Nonkenia, #{he} wasn't sure he wanted to be wishing them success if they'd been soldiers. #{q}Ok, I'll do it. But why me?</q>

  ||
    --> <q>You saw them before they came back, so now you have to pray.</q> The boy tugged at #{@worker}'s pants again impatiently while his friends ran ahead.
"""

Place.Vailia::jobs.nonkeniaDiplomats = Job.NonkeniaDiplomats = class NonkeniaDiplomats extends Job
  officers:
    Nat: '|officers|Nat'
  conditions:
    '|events|KatTrial': {}
  label: 'Mission from Guildmaster'
  type: 'special'
  text: ->"""The Guildmaster has a job for Natalie, if she'd like to take it - a delivery he won't trust to any other ship."""
  energy: -1

Mission.NonkeniaDiplomats = class NonkeniaDiplomats extends Mission
  label: "Nonkenian Negotiations"
  tasks: [
      description: "Bring diplomats to Nonkenia"
      conditions:
        '|location': {is: Place.Nonkenia}
  ]

Job.NonkeniaDiplomats2 = class NonkeniaDiplomats2 extends Job
  officers:
    Nat: '|officers|Nat'
    James: '|officers|James'
  label: 'Deliver Diplomats'
  type: 'special'
  text: ->"""If Ameliss' bodyguard goes back for yet another bowl of food, she will... She'll throw him overboard. Oh, wait, they're near enough shore that he could swim. Someone fetch the plank."""
  energy: -2

Trait.Diplomats = class Diplomats extends Trait
  description: """Ameliss sets Natalie's teeth grinding, and her bodyguard is going to eat them out of of business. (<span class="happiness">-0.5 happiness</span>, -1 food daily)"""
  daily: ->
    g.officers.Nat.add 'happiness', -0.5
  eats: 4

natStatus = ->
  return if g.money < 0 then 'Poorly'
  else if g.money < 2000 then 'Doing ok'
  else 'Excellent'

Job.NonkeniaDiplomats::next = Page.NonkeniaDiplomats = class NonkeniaDiplomats extends Page
  conditions:
    Nat: {}
    Guildmaster: '|people|Guildmaster'
  text: ->"""|| bg="guildOffice"
    #{@Nat.happy 'left'}
    -- #{q}Guildmaster Janos,</q> Natalie grinned and sauntered into his office unannounced. It had cost her an obol at the front desk to see him on the quiet, but the look of surprise on his face as she sat herself down across from him was worth it.

  ||
    #{@Guildmaster.smiling 'right'}
    --> #{q}Ah, welcome. I didn't know your ship was back already. Doing well, I hope?</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}#{natStatus()}. But that isn't why I'm here. I'm here because you need me to deliver something irreplaceable to Alkenia.</q>

  ||
    #{@Guildmaster.skeptical 'right'}
    -- He quirked an eyebrow. #{q}I'm curious how you know that. I've only told one person, whom I'm sure you've never met.</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}Easy. <i>You</i> wanted to see me when I got back, which means you want something moved. You wanted to see <i>me</i> when I got back, which means you can't afford to have it lost at sea. You wanted to see me when I <i>got back</i>, which means it has something to do with Alkenia, since I've had a lot of dealings there recently.</q>

  ||
    #{@Guildmaster.normal 'right'}
    --> #{q}Very good, but wrong on two counts. Nonkenia is the destination, and it's a them I want delivered, not an it. You are certainly correct that I would very much prefer to trust them to your care, though.</q>

  ||
    #{@Guildmaster.serious 'right'}
    -- #{q}This feud between Alkenia and Nonkenia is doing no one any good. A war right in our backyard is bad business. While the prince, and thus Vailia, certainly has made a policy of non-interference in foreign politics, as a private individual I have somewhat greater freedom of action.</q> He smiled at the irony in those last words. The Guild was the nobility's equal in all but name.

  ||
    #{@Guildmaster.normal 'right'}
    --> #{q}Please don't make that face. All I'm going to do is arranging peace talks, nothing objectionable. I wish you to carry a pair of diplomats to Nonkenia to arrange things, with all possible haste. You will, of course, be paid.</q>

  ||
    -- He didn't need to ask if she'd do it. Any number of reasons would have been sufficient alone - money, loyalty the man who was not far from a father, a desire to do good for the people of both cities, earning favor from the Guild. She just nodded.

  ||
    #{@Guildmaster.normal 'right'}
    --> #{q}Excellent. I'll tell them to meet you at your ship this afternoon.</q>

  ||
    --> <em>New quest: Nonkenian Negotiations. Until completed, Natalie has a new trait: <strong>Annoying Diplomats</strong></em>"""
  effects:
    money: -1
    remove:
      '|location|jobs|nonkeniaDiplomats': Job.NonkeniaDiplomats
    add:
      '|missions|NonkeniaDiplomats': Mission.NonkeniaDiplomats
      '|officers|Nat|traits|diplomats': Trait.Diplomats
      '|map|Nonkenia|jobs|nonkeniaDiplomats': Job.NonkeniaDiplomats2

Place.Ship::jobs.nonkeniaDiplomat = ShipJob.NonkeniaDiplomatShip = class NonkeniaDiplomatShip extends ShipJob
  conditions:
    '|officers|Nat|traits|diplomats': {}
  type: 'special'
  label: 'Deal with Diplomat'
  text: ->"Maybe she isn't so bad after all? It wouldn't hurt to make nice..."

ShipJob.NonkeniaDiplomatShip::next = Page.NonkeniaDiplomatShip = class NonkeniaDiplomatShip extends Page
  conditions:
    Nat: '|officers|Nat'
    crew: fill: -> Math.choice g.crew
    Ameliss: '|people|Ameliss'
  text: ->"""|| bg="Ship.cabinDay"
    #{@Nat.normal 'left'}
    -- #{q}Come in, please.</q> Natalie shut the door behind Ameliss and gestured to the single chair, taking a seat on the bed herself.

  ||
    #{@Ameliss.normal 'right'}
    --> Ameliss sat down with a flurish, sweeping her long dress to one side. Ignoring any semblance of common sense, the diplomat looked better dressed for a ballroom than moving around aboard a ship. Long icicle black hair and steel eyes, piercing lips, a smile that seemed to mean the opposite of what one should...

  ||
    #{@Nat.normal 'left'}
    --> #{q}I'm afraid Guildmaster Janos never gave me your bodyguard's name,</q> Natalie reached for something to talk about.

  ||
    #{@Ameliss.angry 'right'}
    -- She gave a stare that made Natalie feel as though she'd burst out cussing at a formal dinner. Why would you want to talk about him when I'm so much more interesting, it seemed to say. #{q}He told me that you have been giving him a hard time? I didn't believe him, of course, that someone so well-regarded by the Guildmaster as yourself would begrudge him a snack...</q>

  ||
    #{@Nat.uncertain 'left'}
    --> #{q}He is welcome to help himself to the galley, but yes, there was a bit of a scuffle when he took a piece of bread off #{@crew}'s plate.</q> Natalie shrugged and tried not to smile. #{q @Nat}I made the two of them clean the food off the ceiling afterwards - it was only fair, since #{@crew} was the one who threw the soup - but cannot fault #{him} for sticking up for #{him}self.</q>

  ||
    #{@Ameliss.serious 'right'}
    -- Ameliss pursed her lips in annoyance, as though having trouble believing that Natalie would actually admit to such a thing. #{q}That is unfortunate, and I shall have to speak with him about him manners.</q>

  ||
    #{@Nat.uncertain 'left'}
    --> It sounded like an appology, but couldn't help but feel like the Ameliss was more annoyed at her for refusing to fault #{@crew} than anything. This was going to be a long voyage.

  ||
    #{@Nat.uncertain 'left'}
    --> <em><span class="happiness">-2 happiness</span> for #{@crew}</em>
"""
  apply: ->
    super()
    @context.crew.add 'happiness', -2
  effects:
    remove:
      '|map|Ship|jobs|nonkeniaDiplomat': ShipJob.NonkeniaDiplomatShip

Job.NonkeniaDiplomats2::next = Page.NonkeniaDiplomats2 = class NonkeniaDiplomats2 extends Page
  conditions:
    Nat: {}
    James: {}
    Ameliss: '|people|Ameliss'
  text: ->"""|| bg="day"
    -- Sploosh.

  ||
    #{@Nat.happy 'left'}
    --> #{q}Bye-bye!</q> Natalie waved cheerfully at the rippling ocean as an irate bodyguard bobbed to the surface, shot Natalie a dirty look, and began swimming for shore.

  ||
    #{@James.serious 'right'}
    --> #{q @James}...</q>

  ||
    #{@James.normal 'right'}
    --> #{q}...I didn't think you'd really do it.</q>

  ||
    #{@Nat.happy 'left'}
    -- Natalie grinned and turned to Ameliss, the diplomat she was being paid to deliver. #{q}I'll be getting paid now, if you don't mind.</q> She held out her hand, and when Ameliss hesitated, began tapping a foot on the plank she'd rigged in order to make the bodyguard walk it.

  ||
    #{@Ameliss.angry 'right'}
    --> <q>Treachery! Piracy! Whore!</q> The normally composed diplomat backed towards the rail, hissing insults and clutching the bag of money Janos had given her to pay Natalie with. <q>I'll make you pay for this, see if I don't!</q>

  ||
    #{@Nat.normal 'left'}
    -- Natalie rolled her eyes and sighed. #{q}Can't take a joke, can you? Oh well. Come on boys, lower the boat and we'll take Ms. Not-going-for-a-swim ashore along with her luggage.</q>

  ||
    --> <em><span class="happiness">+8 happiness</span> for Natalie. +300β</em>
"""
  effects:
    money: 300
    remove:
      '|location|jobs|nonkeniaDiplomats': Job.NonkeniaDiplomats2
      '|missions|NonkeniaDiplomats': Mission.NonkeniaDiplomats
      '|officers|Nat|traits|diplomats': Trait.Diplomats

  apply: ->
    super()
    @context.Nat.add 'happiness', 8
