Job.VailiaHireCrew = class VailiaHireCrew extends Job.HireCrew
  ignoreNew: true # Don't show this as new since they've already seen IntroHireCrew
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
    Weapons: [5, 0]
  sell: new Collection
    Barley: [40, 0]
    Wood: [40, 0]
    Wheat: [40, 0]
    "Naval Supplies": [20, 0]
    Charcoal: [10, 0]
    Iron: [20, 0]
    Weapons: [5, -2]
    Fur: [20, 0]

Place.Vailia = Game::map.Vailia = class Vailia extends Place
  name: 'Vailia'
  description: "Vailia is a bustling port city, famous for its brothels, its political neutrality, freedom from the disasters which plague lesser cities, and its merchant-navy. But mostly for its sex workers."
  images:
    day: 'game/content/locations/Vailia/Port Day.jpg'
    night: 'game/content/locations/Vailia/Port Night.jpg'
    storm: 'game/content/locations/Vailia/Port Storm.jpg'
    marketDay: 'game/content/locations/Vailia/Market Day.jpg'
    marketNight: 'game/content/locations/Vailia/Market Night.jpg'
    marketStorm: 'game/content/locations/Vailia/Port Storm.jpg'
    tavern: 'game/content/locations/Vailia/Tavern.jpg'
    guildOffice: 'game/content/locations/Vailia/Guild Office.jpg'
    guildOfficeGrey: 'game/content/locations/Vailia/Guild Office Grey.jpg'
    guildOfficeGrey2: 'game/content/locations/Vailia/Guild Office Grey 2.jpg'
    guildOfficeGrey3: 'game/content/locations/Vailia/Guild Office Grey 3.jpg'
  majorPort: true
  jobs: new Collection
    hireCrew: Job.VailiaHireCrew
    market: Job.VailiaMarket
  location: [1600, 1831]
  destinations: new Collection
    MountJulia: 7

Place.Vailia::jobs.beach = Job.Beach = class Beach extends Job
  officers:
    worker: {}
    worker2: {optional: true}
    worker3: {optional: true}
  label: 'Rest'
  text: ->"""Visit the beach, spend time wandering the city, explore a pub - all great ways to relax and restore energy."""
  energy: -> 3 + Page.sumStat('restEnergy', g.crew)
  next: Page.randomMatch
  @next: []

Job.Beach.next.push Page.BeachWood = class BeachWood extends Page
  conditions:
    worker: {}
    '|weather': {eq: 'calm'}
    '|season': {eq: 'Wood'}
  text: ->"""|| bg="day"
    -- With Descending Water finally behind them, many Vailians greeted the returning warmth with a visit to the beach, and #{@worker} was no exception. Gentle waves lapped against smooth sand, wetting the feet of hundreds of visitors. The air was pleasantly warm, but not enough to dispel the water's chill. Playing in the sand was the order of the day.

  ||
    -- #{@worker} entered a sand castle contest, constructing #{Math.choice [
        "an elaborate moat and castle, carefully sculpted to resemble Vailia's palace"
        "a sandship, prow facing proudly towards the ocean"
        "the largest pile of sand " + he + " could manage, enlisting the help of several on lookers, before smoothing it out into a pyramid"
      ]}. Though it wasn't the winning entry, #{he} certainly enjoyed #{him}self.
  """

Job.Beach.next.push Page.BeachFire = class BeachFire extends Page
  conditions:
    worker: {}
    '|weather': {eq: 'calm'}
    '|season': {eq: 'Fire'}
  text: ->"""|| bg="day"
    -- The hot days of #{g.month} Fire demanded a visit to the beach, and #{@worker} was perfectly obliging towards such a demand. #{He} was also obliging towards another demand – that #{he} join in a game of volleyball, to make the teams even. Win, lose or draw, #{he} honestly lost track when the game devolved into a giggly wrestling match, with the entire other team running under the net to tackle them into the sand."""

Job.Beach.next.push Page.BeachEarth = class BeachEarth extends Page
  conditions:
    worker: {}
    '|weather': {eq: 'calm'}
    '|season': {eq: 'Earth'}
  text: ->"""|| bg="day"
    -- Stealing one of the final days of warmth from #{g.month}, #{@worker} took a walk along the beach. It was nearly empty at this time of year, weather uncertain and plenty of work to be done before the cold arrived, leaving #{@worker} plenty of space for #{his} wanderings.

  ||
    --> Collecting a couple of shells, #{he} finally settled on a single beautiful spiral. There wasn't much room aboard the Azurai for personal possessions, so memories of a beautiful walk and the single memento would have to be enough."""

Job.Beach.next.push Page.BeachWater = class BeachWater extends Page
  conditions:
    worker: {}
    '|weather': {eq: 'calm'}
    '|season': {eq: 'Water'}
  text: ->"""|| bg="day"
    -- In the biting cold of #{g.month} Water the beach was completely deserted, leaving #{@worker} alone with #{his} thoughts. #{He} sat and watched the waves roll in for a while, before finally spotting another watcher of the waves. They walked together for a while, saying nothing, merely enjoying the company of another human. Finally the #{Math.choice ['old man', 'old woman', 'young man', 'young woman', 'girl', 'boy']} returned to the city, and #{@worker} did the same shortly after."""

Job.Beach.next.push Page.VailiaRumorsSteel = class VailiaRumorsSteel extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day"
    -- <q>You're full of shit, Thomas.</q> Two arguing young toughs bumped into #{@worker}, causing #{him}, in turn, to jostle another shopper in the market.

  ||
    --> <q>I heard it straight from my master – they're shipping out the last load this morning, and it's all but emptied the storehouse. I carried half those crates myself, I'll have you know.</q> He gave an exaggerated groan and slapped his back.

  ||
    --> <q>And I say that just because you shipped out all that steel doesn't mean you should be buying up iron stock. Your arms are stronger than your brain. Stick with them.</q> He punched his friend in the arm, and any further conversation was lost in the crowd as they continued away from #{@worker}."""

Job.Beach.next.push Page.VailiaRumorsEndOfYear = class VailiaRumorsEndOfYear extends Page
  conditions:
    worker: {}
    '|month': {eq: 'Descending'}
    '|season': {eq: 'Water'}
  text: ->"""|| bg="day"
    -- The Guild would be putting on its turning-of-the-year ball soon. Though #{@worker} already knew, it was hard to find news of anything else, so well did it occupy the minds of everyone #{he} talked with. To be fair, it probably deserved it. A merchant might sell as much on that night as the rest of Water put together, and anyone willing to ply their trade in the week before, rather than spend it with friends and family, could charge almost whatever they pleased.

  ||
    --> Which, often as not, wasn't all that much more than normal. Even Vailian enterprise couldn't overcome the spirit of hope and excitement that accompanied a new year."""

Job.Beach.next.push Page.VailiaRumorsWitch = class VailiaRumorsWitch extends Page
  conditions:
    worker: {isnt: Officer.Natalie}
    '|events|FirstStorm': {}
  text: ->"""|| bg="day"
    -- The old woman shook her head, muttering to herself as she swept dust out of her doorway. She looked up at #{@worker}, stopped her sweeping for a moment, muttered something seeming directed at #{him}. Curious, #{@worker} left #{his} errand aside for the moment and retraced a few steps.

  ||
    -- <q>I said ya'need ta get your brain checked, #{boy}, if you're sailing with a witch.</q>

  ||
    --> #{q}A witch?</q>

  ||
    --> <q>S'bad luck for the ship, and worse luck for for everyone aboard.</q> She shook her head and muttered, returning to her sweeping.

  ||
    --> Knowing there was nothing to be gained by arguing, #{@worker} went on #{his} way."""

Job.Beach.next.push Page.VailiaRumorsPeaceTreaty = class VailiaRumorsPeaceTreaty extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day"
    -- <q>There's a whole delegation coming through tomorrow. You wouldn't believe the number of flowers we have to provide.</q> A harried looking middle-aged woman nearly bowled #{@worker} over with a huge bouquet, talking to her daughter who trailed several paces behind, apologizing and bowing cutely to everyone her mother trampled out of the way.

  ||
    --> <q>Stop lolly-gagging and get the door. I swear. Why can't they just sign their peace treaties at home, instead of bothering us all the time? I mean, there's hardly a rose to be found in the city, our garden's been picked clean...</q> A slamming door cut off #{@worker}'s impromptu and unintentional eavesdropping session."""

Job.MeghanIntro = Place.Vailia::jobs.meetMeghan = class MeghanIntro extends Job
  label: "Meet with Guildmaster"
  type: 'plot'
  text: ->"""The Guildmaster would like to speak with Natalie, and has requested that she come alone. Interesting."""
  energy: -2
  officers:
    Natalie: '|officers|Nat'
  conditions:
    '|events|NonkeniaDiplomats2': {}

Page.MeghanIntro = Job.MeghanIntro::next = class MeghanIntro extends Page
  conditions:
    Nat: '|officers|Nat'
    Guildmaster: '|people|Guildmaster'
    Meghan: '|people|Meghan'
  text: ->"""|| bg="guildOffice"
    #{@Guildmaster.serious 'left'}
    -- Janos glanced between Natalie and his other guest. His desk was, unusually, clear, as though he'd put away everything in preparation for Natalie's arrival. No, he wouldn't care if Natalie saw his work - he'd put it away for his other guest.

  ||
    #{@Meghan.normal 'right'}
    --> She was a young woman, Kat's age, but otherwise completely unlike the thief. Piercingly beautiful, elegant, self-assured, she looked the part of a noblewoman. But...

  || speed="slow" bg="guildOfficeGrey"
    #{@Meghan.normal 'right'}
    --> Power. The room was filled with it, And unlike the energy Natalie could harness in a storm, the power was already directed, contained, coiling around the girl and squeezing the air from Natalie's lungs.

  || speed="verySlow" bg="guildOfficeGrey2"
    #{@Meghan.normal 'right'}
    -- It wasn't hostile. It wasn't aimed at all. It merely... was, dimming the rest of the world with the mere weight of the girl's existence. Natalie's magic flickered like a candle in the presence of the sun.

  || speed="slow" bg="guildOfficeGrey3"
    #{@Meghan.normal 'right'}
    --> Natalie couldn't breathe.

  || bg="guildOffice"
    #{@Meghan.happy 'right'}
    --> The girl smiled, and the pressure vanished, magic coiling back inside, wating until called forth again. Nat staggered with the sudden change in atmosphere and sat on down hard, hands folded in her lap. The display - clearly, that's what it had been - had worked. She was overawed and cowed.

  ||
    #{@Guildmaster.normal 'right'}
    -- #{q}Natalie Rowena, allow me to introduce Lady Vailia.</q>

  ||
    #{@Meghan.normal 'right'}
    --> #{q}Just Meghan, please.</q>

  ||
    #{@Guildmaster.serious 'right'}
    -- #{q}Lady Meghan, then. She wanted to meet you, and I suggested that since you were already making the trip up here, she could join us.</q> Though the Guildmaster's neutral expression had flickered into a frown for only a moment, Natalie could read between the lines perfectly well - he hadn't wanted to introduce them at all. For Natalie's protection or his own reasons, though, that was the question.

  ||
    #{@Nat.normal 'left'}
    --> #{q}Named after the city?</q> As curiosity overcame dread, she realized what this meeting was - a test. She hoped she hadn't failed already.

  ||
    #{@Meghan.happy 'right'}
    -->#{q}Other way around.</q> Meghan shrugged.
"""
  effects:
    remove:
      '|location|jobs|meetMeghan': Job.MeghanIntro

Page.MeghanIntro2 = Page.MeghanIntro::next = class MeghanIntro2 extends Page
  conditions:
    Meghan: {}
    Nat: {}
    Guildmaster: {}
  text: ->"""|| bg="guildOffice"
    #{@Guildmaster.serious 'right'}
    -- #{q}Lady Meghan came of age a few weeks ago. I would have invited you to the celebration, but you were at sea,</q> Janos interjected. #{q}Her father was a good friend of mine.</q> <em>She isn't</em> was implied.

  ||
    #{@Meghan.happy 'right'}
    --> #{q}It has been some time since our city hosted a sorceress of your power.</q>

  ||
    #{@Nat.happy 'left'}
    --> Natalie laughed. "Of your power." This girl could squash her like a bug. Rumors had it that Vailia was home to the most powerful sorceress in the world. No way this could be anyone else.

  ||
    #{@Nat.normal 'left'}
    -- #{q}Are you really the most powerful mage in the world?</q>

  ||
    #{@Meghan.normal 'right'}
    --> #{q}The world is a big place.</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}That's a yes in disguise, isn't it?</q>

  ||
    #{@Meghan.normal 'right'}
    --> Meghan shrugged, but Natalie could tell she was pleased. Score one point for reading the girl's attitude correctly. Outright flattery would have gotten nowhere with someone so used to power, but curiosity and blunt truth had been the right tact.

  ||
    #{@Meghan.serious 'right'}
    -- #{q}Who were your parents?</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}My mother worked for the Guild, Jessie Rowena. I don't know who my father is.

  ||
    #{@Meghan.normal 'right'}
    --> #{q}What day were you born?</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}15th of Descending Fire, 1274.</q>

  ||
    #{@Meghan.normal 'right'}
    -- #{q}Are you planning on having children any time soon?</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}No plans in that direction.</q>

  ||
    #{@Meghan.serious 'right'}
    --> Meghan pursed her lips. Natalie felt magic stir for a moment, brushing past her mind in a movement too swift and subtle to follow. Then Meghan relaxed again, and sunk back in her chair with a smile.
"""

Page.MeghanIntro3 = Page.MeghanIntro2::next = class MeghanIntro3 extends Page
  conditions:
    Nat: {}
    Guildmaster: {}
    Meghan: {}
  text: -> """|| bg="guildOffice"
    #{@Meghan.normal 'right'}
    -- #{q}Kantis.</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}What?</q>

  ||
    #{@Meghan.normal 'right'}
    --> #{q}Kantis. Your father is from Kantis. Speak with me if you ever decide to go there.</q> Meghan slapped her thighs and stood, the gesture putting lie to Natalie's earlier assessment of her as elegant and refined.

  ||
    #{@Meghan.happy 'right'}
    --> #{q}Thank you for your time, Natalie, Guildmaster. Take care.</q> She took her leave without waiting for a response.

  || speed="slow"
    -- With the Guildmaster and Natalie left alone, silence filled the room. Natalie watched Janos, trying to figure what he made of the visit. For her own part Natalie was inclined to dismiss it as merely Meghan assessing the threat of another mage in the city, but the Guildmaster had a far broader view of events than she did, and if there were political implications in Lady Vailia taking an interest in one of the Guild's captains, he'd be the one to know.

  ||
    #{@Guildmaster.thinking 'right'}
    --> #{q}I'm sorry, but my business will have to wait for another day. I need to think on this.</q>

  ||
    #{@Nat.normal 'left'}
    -- #{q}Is the city really named after a family of mages?</q>

  ||
    #{@Guildmaster.thinking 'right'}
    --> #{q}Yes. I'm sure you can read about it at the library.</q>

  ||
    #{@Nat.happy 'left'}
    --> #{q}Kantis is in the far north, right?</q>

  ||
    #{@Guildmaster.skeptical 'right'}
    --> #{q}Yes.</q>

  ||
    #{@Nat.happy 'left'}
    -- #{q}Don't we have some dealings with them? I heard in the market the other day that...</q>

  ||
    #{@Guildmaster.serious 'right'}
    --> #{q}Another day, Natalie.</q>

  ||
    #{@Nat.normal 'left'}
    --> #{q}...Yes sir.</q>
"""
