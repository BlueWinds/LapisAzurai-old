Place.Alkenia = Game::map.Alkenia = class Alkenia extends Place
  name: 'Alkenia'
  description: "<p>Alkenia is the closest real settlement to Vailia. While nominally independent, it's firmly under Vailia's influence and welcomes merchant with open arms, since they often bring valuable manufactured goods.</p>"
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

Place.Alkenia::jobs.market = Job.AlkeniaMarket = class AlkeniaMarket extends Job.Market
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

Place.Alkenia::firstVisit = Page.AlkeniaArrive = class AlkeniaArrive extends Page
  text: ->"""<page bg="day">
    <text><p>Excited shouts and waving arms guided the Azurai into dock at Alkenia, one of Vailia's primary trading partners. Another free city, Alkenia nestled in the arms of an encircling mountain, stone bluffs trailing into the sea on either side of the city and providing protection from storms. A stream ran down the valley though the center of town fed by springs further up the slope. The Alkenians made their livings from the forest and the shore, supplying Vailia with timber in return for steady shipments manufactured goods or other items from farther afield – without the vast and relatively safe forests, Natalie's homeland would be unable to keep a significant navy afloat against the terrible attrition of the open ocean.</p></text>
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

Place.Alkenia::jobs.rest = Job.AlkeniaRest = class AlkeniaRest extends Job
  officers:
    worker: {}
    worker2: {optional: true}
    worker3: {optional: true}
  label: 'Rest'
  text: ->"""Sit in one of Alkenia's cafes and rest"""
  energy: 2
  next: Page.randomMatch
  @next: []
  apply: ->
    super()
    @context.worker.add 'energy', 2
    @context.worker2?.add 'energy', 2
    @context.worker3?.add 'energy', 2

Job.AlkeniaRest.next.push Page.AlkeniaRestForest = class AlkeniaRestForest extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="day|storm">
    <text><p><q>Another forester went missing today,</q> the woman pursed her lips and lowered her head in closer to her friend. She didn't lower her voice, though, and #{@worker} couldn't help but overhear.</p></text>
  </page>
  <page>
    <text continue><p><q>Really? Hard to believe – you expect this sort of thing out around Mount Julia, but not so close to home.</q></p></text>
  </page>
  <page>
    <text continue><p><q>I suppose it's not as bad as it could be. He'll be back in a few months, but I'm going to make an offering at the shrine on my way home.</q></p></text>
  </page>
  <page>
    <text continue><p><q>A harsh lesson. Hopefully not too harsh. Did you hear who it was?</q></p></text>
  </page>"""

Job.AlkeniaRest.next.push Page.AlkeniaRestDerya = class AlkeniaRestDerya extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="day|storm">
    <text><p><q>I hear Derya won another battle.</q></p></text>
  </page>
  <page>
    <text continue><p><q>You always say that! Every time news comes in, you always tell me Derya won another battle. Derya this, Derya that. You'd think, if they kept winning all this time, whoever they were fighting would eventually give up?</q> The teenage girl snapped back at her sweetheart – clearly this was a conversation they'd had before.</p></text>
  </page>
  <page>
    <text continue><p><q>Good point. Maybe we just don't hear about all the times they lose? But if they lost, wouldn't their enemies spread those rumors too?</q></p></text>
  </page>
  <page>
    <text continue><p>The girl rolled her eyes and tugged him along.</p></text>
  </page>"""

Job.AlkeniaRest.next.push Page.AlkeniaRestSteel = class AlkeniaRestSteel extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="day|storm">
    <text><p><q>Do you think the price of steel is going to rise,</q> a neighboring merchant poked his head through the curtain to ask his neighbor, while they weighed out #{@worker}'s order.</p></text>
  </page>
  <page>
    <text continue><p><q>Why do you care? Only steel you use is a knife, and if there's a war brewing, won't exactly be a shortage of those, now will there?</q> Clearly this was the continuation of a previous conversation, carried on across the day as they worked.</p></text>
  </page>
  <page>
    <text continue><p><q>Not a war, Vailia doesn't fight those, you know that. I just hear they're mighty upset at Kantis over some thing or other.</q></p></text>
  </page>
  <page>
    <text continue><p><q>Kantis is always upset with someone over something. Don't put too much stock in rumors, and it won't affect us at any rate.</q></p></text>
  </page>"""

Job.AlkeniaRest.next.push Page.AlkeniaRestStorm = class AlkeniaRestStorm extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="day|storm">
    <text><p>#{@worker} couldn't tell what was being said, but based on whispers and pointing, it was clear the two old men were looking at #{him} and thinking about the Azurai docked somewhere below in the harbor. Seeing that they'd been noticed, one of them tipped his hat at #{@worker} and approached.</p></text>
  </page>
  <page>
    <text continue><p><q>Is it true your captain sailed right through a storm?</q></p></text>
  </page>
  <page>
    <text continue><p>#{@worker} nodded, neither wanting to lie about it nor to spread any more rumors than necessary. Fortunately the man sensed his reluctance, and with another polite hat-tip, retreated.</p></text>
  </page>"""

Place.Alkenia::jobs.forestry = Job.AlkeniaForestry = class AlkeniaForestry extends Job
  officers:
    Nat: '|officers|Nat'
  label: 'Explore Forest'
  type: 'special'
  text: ->"""Alkenia provides most of the lumber for Vailia's shipyards. Some contacts in the industry would be advantageous for a young captain."""
  energy: 2

Mission.AlkeniaWeapons = class AlkeniaWeapons extends Mission
  label: "Weapons for Alkenia"
  tasks: [
      description: "Have 6 crates of Vailian weapons"
      conditions:
        '|cargo|Weapons': {gte: 6}
    ,
      description: "Bring them to Alkenia to defend against Nonkenian raiders"
      conditions:
        '|location': {is: Place.Alkenia}
  ]
  
Job.AlkeniaForestry2 = class AlkeniaForestry2 extends Page
  officers:
    Nat: '|officers|Nat'
  label: 'Explore Forest'
  conditions:
    '|cargo|Weapons': {gte: 6}
  type: 'special'
  text: ->"""Alkenia provides most of the lumber for Vailia's shipyards. One of their foremen asked her to bring weapons to defend against raiders from Nonkenai."""
  energy: 2

ShipJob.JamesNoWeapons = class JamesNoWeapons extends ShipJob
  label: "James upset"
  type: 'special'
  conditions:
    '|cargo|Weapons': {gte: 6}
  text: ->"""<p>James isn't entirely happy with selling weapons to Alkenia. Time to speak with him and address his concerns.</p>"""


Job.AlkeniaForestry::next = Page.AlkeniaForestry = class AlkeniaForestry extends Page
  conditions:
    Nat: {}
  text: ->"""<page bg="day|storm">
    <text><p>Alkenia was something of an exception to the normal rules - few cities dared venture as far and as regularly into the wild as they did. And more amazing still was the fact that, as best Natalie could tell from rumours and talk, almost no one disappeared.</p></text>
  <page>
    <text full><p><q>The biggest danger is raiders from Nonkenia,</q> the lumberjack spat the name. <q>They have some devilish pact or other that keeps 'em hidden until too late. You take my advice, miss,</q> he leaned against his burden, a tree trunk almost as big around and tall as as she was, <q>you won't go out there without a nice big group to keep you safe.</q></p>
    <p>#{q @Nat}I'm not planning on going myself, but thanks for the tip. Mostly I was wondering if there's anything you need?</q> She hadn't been expecting to find the owner of a relatively large company out and carrying logs himself, but it was a pleasant surprise. He was easier to deal with by far than a conniving desk clerk.</p>
    <p><q>Hah, a Vailian looking to help, there's a new one. You said you were a captain? Not much use to me, then. Kind of you to ask, though.</q> With a grunt he heaved the log back to his shoulder, getting ready to leave. He paused, turning back to her, and she had to duck the swing of his beam. <q>Well, maybe there is something. Bring me a dozen bows with spears and knives to match - good Vailian ones, not the dreck they make down by the pier - I might start thinking you mean it.</q> He laughed at her expression - that much weaponry was, not to put too fine a point on it, rather expensive.</p></text>
  </page>
  <page>
    <text continue full><p><em>New quest: Weapons for Alkenia</em></p>
    <p><em>Bring 6 crates of Weapons to Alkenia</em></p></text>
  </page>"""
  apply: ->
    super()
    g.Map.Vailia.jobs.market.buy.weapons or= [6, 7]
    g.Map.Vailia.jobs.market.sell.weapons or= [6, -2]
  effect:
    remove:
      '|location|jobs|forestry': Job.AlkeniaForestry
    add:
      '|missions|AlkeniaWeapons': Mission.AlkeniaWeapons
      '|location|jobs|forestry': Job.AlkeniaForestry2
      '|map|Ship|jobs|jamesNoWeapons': ShipJob.JamesNoWeapons

ShipJob.JamesNoWeapons::next = Page.JamesNoWeapons = class JamesNoWeapons extends PlayerOptionPage
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
  text: ->"""<page bg="Ship.cabinNight">
    <text><p>#{q @James}Are you sure we should be doing this, Nat?</q> James kicked the crate, producing no sound. The bows inside were well packed, and compared to the beating they'd take during loading or unloading, a stray kick was nothing. It did waft out the scent of pine oil, sealing the contents against saltwater in case the hold flooded. #{q}I don't like being an arms merchant.</q></p>
    <p>#{q @Nat}Alkeina's a next door neighbor. It's not like we're selling them to some bloodthirsty warlord - he's just a lumberjack. This is hunting gear anyway, bows and spears and knives.</q> The lantern swayed in her hand, casting dancing shadows across the interior of the cargo hold.</p>
    <p>#{@q}I know, I know what we're doing isn't wrong. It just feels like a foot in the door - once you do this, you're the sort of person who does it, you know? Do me a favor. Let's take these back to Vailia and sell them there.</q></p>
    #{options ['Carry on', 'Abandon mission'], ["Try to convince him that it's not a big deal", "Listen to your friend"]}</text>
  </page>"""
  @next: {}

Page.JamesNoWeapons.next['Carry on'] = Page.JamesNoWeaponsIgnore = class JamesNoWeaponsIgnore extends Page
  conditions:
    James: {}
    Nat: {}
  text: ->"""<page>
    <text><p>She laid a hand on Jame's forearm with an encouraging smile. #{q @Nat}We won't be those sorts of people, I promise. I'm doing this to make a friend, not for money. Thank you for telling me - I really do want to hear it, even if I don't agree this time.</q></p>
    <p>#{q @James}I'm glad you listened, at least. Can I say I told you so, next time?</q>He sighed, nodded, and kicked the crate again. A smile took the sting out of his words though, and he wasn't the sort to say something like that without meaning it.</p>
    <p><em><span class="happiness">+2 happiness</span> for James</em></p></text>
  </page>"""
  apply: ->
    super()
    @context.James.add 'happiness', 2

Page.JamesNoWeapons.next['Abandon Mission'] = Page.JamesNoWeaponsAgree = class JamesNoWeaponsAgree extends Page
  conditions:
    James: {}
    Nat: {}
  text: ->"""<page>
    <text><p>She laid a hand on Jame's forearm with an encouraging smile. #{q @Nat}We won't be those sorts of people, I promise. We'll take them back to Vailia, though I'll probably take a loss on the deal.</q></p>
    <p>James tilted his head, eyebrows rising. #{q @James}I didn't think you'd actually listen. Huh.</q> His surprise turned into a pleased smile, and he patted her hand where it still lay on her arm. #{q}Thank you, Natalie.</q></p>
    <p><em><span class="happiness">+6 happiness</span> for James</em></p></text>
  </page>"""
  apply: ->
    super()
    @context.James.add 'happiness', 6
  effects:
    remove:
      'missions|AlkeniaWeapons'
  
Job.AlkeniaForestry2::next = Page.AlkeniaForestry2 = class AlkeniaForestry2 extends Page
  text: ->"""<page bg="day|storm">
    <text><p></p></text>
  </page>"""