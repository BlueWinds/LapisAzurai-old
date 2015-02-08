lightDamage = 7
heavyDamage = 14
maxDamage = 20

Place.Ship = Game::map.Ship = class Ship extends Place
  name: 'Lapis Azurai'
  description: ->"<p>Vailia is a bustling port city, famous for its political neutrality, its freedom from the disasters that plague lesser cities, and its brothels. Lots and lots of brothels.</p>"
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

  destinations: new Collection
  jobs: new Collection # Unlike normal locations, this collection takes ShipJobs rather than normal Jobs
  location: [0, 0]

  damage: 0
  sailSpeed: -> switch
    when @damage >= heavyDamage then 1 / 3
    when @damage >= lightDamage then 2 / 3
    else 1
  shortDamage: -> switch
    when @damage >= heavyDamage then "barely afloat"
    when @damage >= lightDamage then "heavily damaged"
    else "lightly damaged"
  damageDescription: -> "The Lapis is <b title='#{@damage} / #{maxDamage} damage'>#{@shortDamage()}</b>, " + switch
    when @damage >= heavyDamage then "and will sail at #{String.rate g.map.Ship.sailSpeed()} the normal rate."
    when @damage >= lightDamage then "and will sail at #{String.rate g.map.Ship.sailSpeed()} the normal rate."
    else "but will still sail af full speed."

  applyDamage: (damage)->
    damage += @damage
    if damage >= Place.Ship.heavyDamage
      g.officers.Nat.add('energy', (Place.Ship.heavyDamage - g.map.Ship.damage) * 2)
      g.officers.Nat.energy = Math.max(g.officers.Nat.energy, minEnergy)
    @damage = Math.min(Place.Ship.maxDamage, damage)

  @lightDamage: lightDamage
  @heavyDamage: heavyDamage
  @maxDamage: maxDamage

Ship::jobs.talk = ShipJob.Talk = class Talk extends ShipJob
  label: "Talk with Crew"
  text: ->"""<p>Spend some time mingling with the crew, encouraging and hanging out.</p>
  <p>Crew: <span class="happiness">+2 happiness</span></p>"""
  apply: ->
    super()
    for i, sailor of g.crew then sailor.add('happiness', 2)
  next: Page.randomMatch
  @next: []

ShipJob.Talk.next.push Page.ShipTalkStories = class ShipTalkStories extends Page
  conditions:
    Nat: '|officers|Nat'
    '|season': {eq: ['Fire', 'Earth']}
  text: ->"""<page bg="#{g.map.Ship.images.deckNight}">
    <text><p>In the evenings, while a pair of lookouts kept watch, most of the crew gathered on-deck, to share stories and drinks and company amid the stars. Natalie made it a point to find herself leaning against the same rail as #{Math.choice g.crew}. The ocean lapped against the hull somewhere below, mild waves gently rocking the Lapis Azurai. They talked for some time, content to watch the others from a distance, letting bonds deepen with the setting of the sun.</p>
    <p><em>Crew: <span class="happiness">+2 happiness</span></em></p></text>
  </page>"""

ShipJob.Talk.next.push Page.ShipTalkIndoors = class ShipTalkIndoors extends Page
  conditions:
    Nat: '|officers|Nat'
    '|season': {eq: ['Earth', 'Water']}
  text: ->"""<page bg="#{g.map.Ship.images.deckNight}">
    <text><p>With colder weather setting in, those not on duty preferred to gather in the cargo hold, if it was empty enough, or squeeze into the sleeping area if not. Hot and crowded was better than windy and chill, and those too near the doorway still kept cloaks on to protect against stray drafts.</p></text>
  </page>
  <page>
    <text><p>Though she often preferred to keep her own company, or entertain a smaller group in her own quarters, Natalie also made it a point to spend plenty of time mingling with the crew, especially when off duty. Aside from the purely practical considerations to keeping in touch with their mood and fostering a sense of companionship, she also found it fascinating to listen to them – why they left their homes to risk lives on the open ocean, what they wanted, who they wanted to be... she spent hours listening to and talking with #{Math.choice g.crew}.</p>
    <p><em>Crew: <span class="happiness">+2 happiness</span></em></p></text>
  </page>"""

ShipJob.Talk.next.push Page.ShipTalkMusic = class ShipTalkMusic extends Page
  conditions:
    Nat: '|officers|Nat'
    '|season': {eq: ['Water', 'Wood']}
    sailor: fill: ->
      return g.crew.asArray().sort((c1, c2)->c1.diplomacy - c2.diplomacy)[0]
    sailor2: fill: ->
      return g.crew.asArray().sort((c1, c2)->c1.diplomacy - c2.diplomacy)[2]
  text: ->"""<page bg="#{g.map.Ship.images.deckNight}">
    <text><p>As often as not it had rained in the evenings recently, so those not on watch found themselves crammed into the sleeping quarters. The humidity made the confines not entirely comfortable, but at least they could easily regulate temperature, between body heat and frozen rain outside.</p></text>
  </page>
  <page>
    <text continue><p>Tonight the crew played music, rather than talk, rain beating a staccato counterpoint on the deck overhead. A beat up old guitar was passed around, everyone who knew how to use it taking turns until it finally made its way into #{@sailor}'s hands. #{He} was the best, and everyone knew it, strong and clear #{if @sailor.gender is 'f' then 'alto' else 'baritone'} voice filling the space.</p></text>
  </page>
  <page>
    <text><p>Sitting side by side on the to top level of a bunk, Natalie and #{@sailor2}, relaxed, and it wasn't long before a drowsy captain was leaning on her sailor, lulled by the soothing tones and a sad song of home-far-away. #{@sailor2} gently shifted her to lean against the wall instead, and covered her with a blanket when the song ended.</p></text>
  </page>
  <page>
    <text continue><p><em>Crew: <span class="happiness">+2 happiness</span></em></p></text>
  </page>"""

ShipJob.Talk.next.push Page.ShipTalkSports = class ShipTalkSports extends Page
  conditions:
    '|season': {eq: ['Wood', 'Fire']}
    Nat: '|officers|Nat'
    sailor: fill: ->
      return g.crew.asArray().sort((c1, c2)->c1.combat - c2.combat)[0]
    sailor2: fill: ->
      return g.crew.asArray().sort((c1, c2)->c1.combat - c2.combat)[1]
  text: ->"""<page bg="#{g.map.Ship.images.deckNight}">
  <text><p>Some evenings, once most of the day's work was done, rather than lay about and rest or play music, the crew decided to be a little more energetic. Tossing items around wasn't entirely practical on a small ship, but wrestling or running games were entirely too popular. Natalie hadn't intended to participate, but when #{@sailor} bowled her over on the way to one of the goals, she couldn't resist.</p></text>
  </page>
  <page>
    #{@Nat.image 'excited', 'left'}
    <text><p>Wrapping both arms around #{@sailor}'s thigh she clung on like a burr, hanging from #{his} leg and slowing #{him} down enough for the other team to catch up. Together Natalie and #{@sailor2} wrestled away control of the colored strip of cloth that was the aim, and #{@sailor} fled back to the other side of the ship. Natalie stuck her tongue out at #{@sailor}, and #{he} good naturedly cursed at #{his} captain before chasing the fleeing #{@sailor2}.</p></text>
  </page>"""

Ship::jobs.trainCombat = ShipJob.TrainCombat = class TrainCombat extends ShipJob
  label: "Mock Combat"
  text: ->"""<p>Run a mock battle with the crew.</p>
  <p>Crew: <span class="combat">+1 combat</span><br>James: <span class="energy">-2 energy</span></p>"""

ShipJob.TrainCombat::next = Page.TrainCombat = class TrainCombat extends Page
  conditions:
    James: '|officers|James'
  text: ->"""<page bg="#{g.map.Ship.images.day}">#{@James.image 'angry', ''}<text>
    <p>James divides the crew up into two teams - half of them practice boarding while the others repel using oars and poles wrapped in cloth as weapons. It's still unbelievably noisy as some of the sailors get very much into the spirit, with battle cries and dramatic 'death scenes' as they're slain.</p>
    <p><em>Crew: <span class="combat">+1 combat</span><br>James: <span class="energy">-2 energy</span></em></p>
  </text></page>"""
  apply: ->
    super()
    for i, sailor of g.crew then sailor.add('combat', 1)
    @context.James.add('energy', -2)

Ship::jobs.trainBusiness = ShipJob.TrainBusiness = class TrainBusiness extends ShipJob
  label: "Lessons"
  text: ->"""<p>Teach the sailors a tiny bit about the larger world.</p>
  <p>Crew: <span class="business">+1 business</span><br>Natalie: <span class="happiness">+1 happiness</span>, <span class="energy">-1 energy</span></p>"""

ShipJob.TrainBusiness::next = Page.TrainBusiness = class TrainBusiness extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{g.map.Ship.images.deckDay}">#{@Nat.image 'normal', ''}<text>
    <p>While the world may be a vast place, the officers of the Lapis are some of the most well-traveled and educated individuals in it - Natalie can read and write, for example, which places her in the top 25% of the Vailian population, much less other nations. A bit of teaching is a fun way to pass the time.</p>
    <p><em>Crew: <span class="business">+1 business</span><br>Natalie: <span class="happiness">+1 happiness</span>, <span class="energy">-1 energy</span></em></p>
  </text></page>"""
  apply: ->
    super()
    for i, sailor of g.crew then sailor.add('business', 1)
    @context.Nat.add('energy', -1)
    @context.Nat.add('happiness', 1)

Ship::jobs.trainSailing = ShipJob.TrainSailing = class TrainSailing extends ShipJob
  label: "Maintenence"
  text: ->"""<p>Repairing the Lapis will help the crew learn to work together better.</p>
  <p>Crew: <span class="sailing">+1 sailing</span>, <span class="happiness">-1 happiness</span><br>Natalie: <span class="energy">-2 energy</span></p>"""

ShipJob.TrainSailing::next = Page.TrainSailing = class TrainSailing extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{g.map.Ship.images.day}">#{@Nat.image 'serious', ''}<text>
    <p>Scrubbing the deck is hardly the most glamorous work, but that and a flurry of other menial tasks are necessary to keep a sailing vessel in proper shape - it's not just make-work when all their lives can depend on whether someone slips or not.</p>
    <p><em>Crew: <span class="sailing">+1 sailing</span>, <span class="happiness">-1 happiness</span><br>Natalie: <span class="energy">-2 energy</span></em></p>
  </text></page>"""
  apply: ->
    super()
    for i, sailor of g.crew
      sailor.add('sailing', 1)
      sailor.add('happiness', -1)
    @context.Nat.add('energy', -2)
