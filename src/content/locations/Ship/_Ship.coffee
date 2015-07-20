lightDamage = 7
heavyDamage = 14
maxDamage = 20

minEnergy = -15 # How low Nat's energy can go due to ship damage

Place.Ship = Game::map.Ship = class Ship extends Place
  name: 'Lapis Azurai'
  description: ->"Vailia is a bustling port city, famous for its political neutrality, its freedom from the disasters that plague lesser cities, and its brothels. Lots and lots of brothels."
  images:
    day: 'game/content/locations/Ship/Sailing Day.jpg'
    night: 'game/content/locations/Ship/Sailing Night.jpg'
    storm: 'game/content/locations/Ship/Sailing Storm.jpg'
    cabinDay: 'game/content/locations/Ship/Cabin Day.jpg'
    cabinNight: 'game/content/locations/Ship/Cabin Night.jpg'
    cabinStorm: 'game/content/locations/Ship/Cabin Storm.jpg'
    deckDay: 'game/content/locations/Ship/Deck Day.jpg'
    deckNight: 'game/content/locations/Ship/Deck Night.jpg'
    deckStorm: 'game/content/locations/Ship/Deck Storm.jpg'
    deckFog: 'game/content/locations/Ship/Deck Fog.jpg'

  destinations: new Collection
  jobs: new Collection # Unlike normal locations, this collection takes ShipJobs rather than normal Jobs
  location: [0, 0]

  damage: 0
  sailSpeed: ->
    speed = (switch
      when @damage > heavyDamage then 1 / 3
      when @damage > lightDamage then 2 / 3
      else 1)
    return speed

  shortDamage: -> switch
    when @damage > heavyDamage then "barely afloat"
    when @damage > lightDamage then "heavily damaged"
    else "lightly damaged"

  damageDescription: ->
    speed = g.map.Ship.sailSpeed()
    speed = if speed is 1 then '' else String.rate(speed) + ' '
    return "The Lapis is <b>#{@shortDamage()}</b>, and will sail at #{speed}the normal rate (#{@damage} damage)."

  applyDamage: (damage)->
    damage += @damage
    damage = Math.max(0, Math.randomRound damage)

    if damage >= Place.Ship.heavyDamage
      g.officers.Nat.add('energy', (Place.Ship.heavyDamage - g.map.Ship.damage) * 2)
      g.officers.Nat.energy = Math.max(g.officers.Nat.energy, minEnergy)
    @damage = Math.min(Place.Ship.maxDamage, damage)

  @lightDamage: lightDamage
  @heavyDamage: heavyDamage
  @maxDamage: maxDamage

luxHappiness = (item)->
  happiness = 1 + Math.ceil(Item[item].price / 20)
  return happiness + Page.sumStat('luxuryHappiness', g.crew)

Ship::jobs.talk = ShipJob.Talk = class Talk extends ShipJob
  label: "Talk with Crew"
  conditions:
    luxury: fill: ->
      minItem = false
      for item, amount of g.cargo when Item[item] instanceof Luxury
        unless minItem and Item[item].price > Item[minItem].price
          minItem = item
      return minItem
  text: ->"""Spend some time mingling with the crew, encouraging and hanging out.

  -1 #{@context.luxury}
  Crew: <span class="happiness">+#{luxHappiness @context.luxury} happiness</span>"""
  apply: ->
    super()
    for i, sailor of g.crew
      sailor.add 'happiness', luxHappiness(@context.luxury)
    effects = {cargo: {}}
    effects.cargo[@context.luxury] = -1
    g.applyEffects effects
  next: Page.randomMatch
  @next: []

ShipJob.Talk.next.push Page.ShipTalkStories = class ShipTalkStories extends Page
  conditions:
    Nat: '|officers|Nat'
    '|season': {eq: ['Fire', 'Earth']}
    luxury: {}
  text: ->"""|| bg="Ship.deckNight"
    -- In the evenings, while a pair of lookouts kept watch, most of the crew gathered on-deck to share stories and drinks and company amid the stars. Natalie made a sure to end up leaning against the same rail as #{Math.choice g.crew}. The ocean lapped against the hull somewhere below, mild waves gently rocking the Lapis Azurai. They talked for some time, content to watch the others from a distance, letting bonds deepen with the setting of the sun.

  ||
    --> <em>-1 #{@luxury}, Crew: <span class="happiness">+#{luxHappiness @luxury} happiness</span></em>
  """

ShipJob.Talk.next.push Page.ShipTalkIndoors = class ShipTalkIndoors extends Page
  conditions:
    Nat: '|officers|Nat'
    '|season': {eq: ['Earth', 'Water']}
    luxury: {}
  text: ->"""|| bg="Ship.deckNight"
    -- With colder weather setting in, those not on duty preferred to gather in the cargo hold, if it was empty enough, or squeeze into the sleeping area if not. Hot and crowded was better than windy and chill, and those too near the doorway still kept cloaks on to protect against stray drafts.

  ||
    -- Though she often preferred to keep her own company, or entertain a smaller group in her own quarters, Natalie also made it a point to spend plenty of time mingling with the crew, especially when off duty. Aside from the purely practical considerations of keeping in touch with their mood and fostering a sense of companionship, she also found it fascinating to listen to them – why they left their homes to risk lives on the open ocean, what they wanted, who they wanted to be. She spent hours listening to and talking with #{Math.choice g.crew}.

  ||
    --> <em>-1 #{@luxury}, Crew: <span class="happiness">+#{luxHappiness @luxury} happiness</span></em>
  """

ShipJob.Talk.next.push Page.ShipTalkMusic = class ShipTalkMusic extends Page
  conditions:
    Nat: '|officers|Nat'
    '|season': {eq: ['Water', 'Wood']}
    sailor: fill: -> Math.choice g.crew
    sailor2: fill: -> Math.otherChoice g.crew, @sailor
    luxury: {}
  text: ->"""|| bg="Ship.deckNight"
    -- As often as not it had rained in the evenings recently, so those not on watch found themselves crammed into the sleeping quarters. The humidity made the confines not entirely comfortable, but at least they could easily regulate temperature, between body heat and frozen rain outside.

  ||
    --> Tonight the crew played music, rather than talk, rain beating a staccato counterpoint on the deck overhead. A beat up old guitar was passed around, everyone who knew how to play it taking turns until it finally made its way into #{@sailor}'s hands. #{He} was the best, and everyone knew it, strong and clear #{if @sailor.gender is 'f' then 'alto' else 'baritone'} voice filling the space.

  ||
    -- Sitting side by side on the top bunk, Natalie and #{@sailor2} relaxed, and it wasn't long before a drowsy captain was leaning on her sailor, lulled by the soothing tones and a sad song of home-far-away. #{@sailor2} gently shifted her to lean against the wall instead, and covered her with a blanket when the song ended.

  ||
    --> <em>-1 #{@luxury}, Crew: <span class="happiness">+#{luxHappiness @luxury} happiness</span></em>
  """

ShipJob.Talk.next.push Page.ShipTalkSports = class ShipTalkSports extends Page
  conditions:
    '|season': {eq: ['Wood', 'Fire']}
    Nat: '|officers|Nat'
    sailor: fill: -> Math.choice g.crew
    sailor2: fill: -> Math.otherChoice g.crew, @sailor
    luxury: {}
  text: ->"""|| bg="Ship.deckNight"
    -- Some evenings, once most of the day's work was done, rather than lay about and rest or play music, the crew decided to be a little more energetic. Tossing items around wasn't entirely practical on a small ship, but wrestling or running games were entirely too popular. Natalie hadn't intended to participate, but she couldn't resist when #{@sailor} bowled her over on the way to one of the goals.

  ||
    #{@Nat.happy 'left'}
    -- Wrapping both arms around #{@sailor}'s thigh she clung on like a burr, hanging from #{his} leg and slowing #{him} down enough for the other team to catch up. Together Natalie and #{@sailor2} wrestled away control of the colored strip of cloth that was the aim, and #{@sailor} fled back to the other side of the ship. Natalie stuck her tongue out at #{@sailor}, and #{he} good naturedly cursed at #{his} captain before chasing the fleeing #{@sailor2}.

  ||
    --> <em>-1 #{@luxury}, Crew: <span class="happiness">+#{luxHappiness @luxury} happiness</span></em>
  """

Ship::jobs.trainCombat = ShipJob.TrainCombat = class TrainCombat extends ShipJob
  label: "Mock Combat"
  text: ->"""Run a mock battle with the crew.

  Crew: <span class="combat">+1 combat</span><br>James: <span class="energy">-2 energy</span>"""

ShipJob.TrainCombat::next = Page.TrainCombat = class TrainCombat extends Page
  conditions:
    James: '|officers|James'
  text: ->"""|| bg="Ship.day"
    #{@James.angry ''}
    -- James divided the crew up into two teams. Half of them practiced boarding while the others repelled using oars and poles wrapped in cloth as weapons. It was still unbelievably noisy as some of the sailors got very much into the spirit, with battle cries and dramatic 'death scenes' as they were slain.

  ||
    --> <em><span class="combat">+1 combat</span> for sailors with less than #{@James.get 'combat'}<br>James: <span class="energy">-2 energy</span></em>
  """
  apply: ->
    super()
    for i, sailor of g.crew when sailor.combat < @context.James.get 'combat'
      sailor.add 'combat', 1
    @context.James.add 'energy', -2

Ship::jobs.trainBusiness = ShipJob.TrainBusiness = class TrainBusiness extends ShipJob
  label: "Lessons"
  text: ->"""Teach the sailors a tiny bit about the larger world.

  Crew: <span class="business">+1 business</span>
  Natalie: <span class="happiness">+1 happiness</span>, <span class="energy">-1 energy</span>"""

ShipJob.TrainBusiness::next = Page.TrainBusiness = class TrainBusiness extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.deckDay"
    #{@Nat.normal ''}
    -- While the world may be a vast place, the officers of the Lapis were some of the most well-traveled and educated individuals in it. Natalie could read and write, for example, which placed her in the top 25% of the Vailian population, much less other nations. A bit of teaching was a fun way to pass the time.

  ||
    --> <em><span class="business">+1 business</span> for sailors with less than #{@Nat.get 'business'}<br>Natalie: <span class="happiness">+1 happiness</span>, <span class="energy">-1 energy</span></em>
  """
  apply: ->
    super()
    for i, sailor of g.crew when sailor.business < @context.Nat.get 'business'
      sailor.add 'business', 1
    @context.Nat.add 'energy', -1
    @context.Nat.add 'happiness', 1

Ship::jobs.trainSailing = ShipJob.TrainSailing = class TrainSailing extends ShipJob
  label: "Maintenence"
  text: ->"""Repairing the Lapis will help the crew learn to work together better.

  Crew: <span class="sailing">+1 sailing</span> for sailors with less than #{g.officers.Nat.get 'sailing'}, <span class="happiness">-1 happiness</span>
  Natalie: <span class="energy">-2 energy</span>#{if g.map.Ship.damage then "\nShip: -1 damage" else""}"""

ShipJob.TrainSailing::next = Page.TrainSailing = class TrainSailing extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.day"
    #{@Nat.normal ''}
    -- Scrubbing the deck was hardly the most glamorous work, but that and a flurry of other menial tasks were necessary to keep a sailing vessel in proper shape. It's not just make-work when all their lives can depend on someone's footing.

  ||
    --> <em>Crew: <span class="sailing">+1 sailing</span>, <span class="happiness">-1 happiness</span><br>Natalie: <span class="energy">-2 energy</span>#{if g.map.Ship.damage then "<br>Ship: -1 damage" else ""}</em>
  """
  apply: ->
    super()
    for i, sailor of g.crew
      sailor.add 'happiness', -1
      if sailor.sailing < @context.Nat.get 'sailing'
        sailor.add 'sailing', 1
    @context.Nat.add 'energy', -2
    if g.map.Ship.damage
      g.map.Ship.applyDamage -1
