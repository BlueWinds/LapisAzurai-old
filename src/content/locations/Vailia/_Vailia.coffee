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
    Weapons: [5, 7]
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
  label: 'Rest'
  text: ->"""Visit the beach, spend time wandering the city, explore a pub - all great ways to relax and restore energy."""
  energy: 3
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
