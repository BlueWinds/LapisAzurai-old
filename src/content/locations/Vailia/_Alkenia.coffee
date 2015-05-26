Place.Alkenia = Game::map.Alkenia = class Alkenia extends Place
  name: 'Alkenia'
  description: "Alkenia is the closest real settlement to Vailia. While nominally independent, it's firmly under Vailia's influence and welcomes merchants with open arms, since they often bring valuable manufactured goods."
  images:
    day: 'game/content/locations/Town/Port Day.jpg'
    night: 'game/content/locations/Town/Port Night.jpg'
    storm: 'game/content/locations/Town/Port Storm.jpg'
    marketDay: 'game/content/locations/Town/Port Day.jpg'
    marketNight: 'game/content/locations/Town/Port Night.jpg'
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

  description: ->"""There's an excited air in the market as Natalie explores, a definite sense of eyes upon her, merchants waiting to see what she's brought and hoping for a chance to buy from or sell to her. While Vailia is only two weeks away by ship, that's still further than most people will travel in their lifetimes."""
  next: Page.Market

Place.Alkenia::firstVisit = Page.AlkeniaArrive = class AlkeniaArrive extends Page
  text: ->"""|| bg="day"
    -- Excited shouts and waving arms guided the Azurai into dock at Alkenia, one of Vailia's primary trading partners. Another free city, Alkenia nestled in the arms of an encircling mountain, stone bluffs trailing into the sea on either side of the city and providing protection from storms. A stream ran down the valley though the center of town fed by springs further up the slope. The Alkenians made their livings from the forest and the shore, supplying Vailia with timber in return for steady shipments manufactured goods or other items from farther afield. Without the vast and relatively safe forests, Natalie's homeland would be unable to keep a significant navy afloat against the terrible attrition of the open ocean.

  ||
    -- For those reasons, and others, the arrival of a ship from the east was always a welcome sight. A gaggle of children stood gaping at them as sailors hopped down from the Azurai and began to secure it to the wharf. A man bearing a clipboard and a pen waited patiently for Natalie to disembark.

  ||
    #{g.officers.James.image 'normal', 'center'}
    --> The instant he set foot on the dock James was swarmed by children. Looking somewhat bewildered as he tried to answer their queries all at once. He looked at Natalie for help, but she just waved with one hand and smiled.

  ||
    -- <q>Name, ship name, port of origin, docking fee?</q>

  ||
    #{g.officers.Nat.image 'normal', 'left'}
    --> She rattled off the answers and pressed a coin into his palm, somewhat more valuable than strictly necessary for the docking fee. Always good to make a friend.

  ||
    --> <q>Very well. Is there anything else I can help you with, Ms?</q> He nodded, unscrewing the lid on his inkwell to jot down a few notes.

  ||
    #{g.officers.Nat.image 'normal', 'left'}
    -- #{q}No, thank you. A local guide would not be amiss, but I wouldn't want to impose.</q>

  ||
    --> <q>I'm sure any one of the little scoundrels harassing your husband would be happy to help.</q>

  ||
    #{g.officers.Nat.image 'normal', 'left'}
    --> #{q}He's not... ah, yes, thank you.</q> She decided it wasn't worth arguing over."""

Place.Alkenia::jobs.rest = Job.AlkeniaRest = class AlkeniaRest extends Job
  officers:
    worker: {}
    worker2: {optional: true}
    worker3: {optional: true}
  label: 'Rest'
  text: ->"""Sit in one of Alkenia's cafes and rest"""
  energy: 3
  next: Page.randomMatch
  @next: []

Job.AlkeniaRest.next.push Page.AlkeniaRestForest = class AlkeniaRestForest extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    -- <q>Another forester went missing today,</q> the woman pursed her lips and lowered her head closer to her friend. She didn't lower her voice, though, and #{@worker} couldn't help but overhear.

  ||
    --> <q>Really? That's hard to believe. You expect this sort of thing around Mount Julia, but not so close to home.</q>

  ||
    --> <q>I suppose it's not as bad as it could be. He'll be back in a few months, but I'm going to make an offering at the shrine on my way home.</q>

  ||
    --> <q>A harsh lesson. Hopefully not too harsh. Did you hear who it was?</q>"""

Job.AlkeniaRest.next.push Page.AlkeniaRestDerya = class AlkeniaRestDerya extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    -- <q>I hear Derya won another battle.</q>

  ||
    --> <q>You always say that! Every time news comes in, you always tell me Derya won another battle. Derya this, Derya that. You'd think, if they kept winning all this time, whoever they were fighting would eventually give up?</q> The teenage girl snapped back at her sweetheart. Clearly this was a conversation they'd had before.

  ||
    --> <q>Good point. Maybe we just don't hear about all the times they lose? But if they lost, wouldn't their enemies spread those rumors too?</q>

  ||
    --> The girl rolled her eyes and tugged him along."""

Job.AlkeniaRest.next.push Page.AlkeniaRestSteel = class AlkeniaRestSteel extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    -- <q>Do you think the price of steel is going to rise,</q> a neighboring merchant poked his head through the curtain to ask his neighbor, while they weighed out #{@worker}'s order.

  ||
    --> <q>Why d'you care? 'Only steel you use is a knife, and if there's a war brewing, won't exactly be a shortage of those, now will there?</q> Clearly this was the continuation of a previous conversation, carried on across the day as they worked.

  ||
    --> <q>Not a war, Vailia doesn't fight those, you know that. I just hear they're mighty upset at Kantis over some thing or other.</q>

  ||
    --> <q>Kantis is always upset with someone over something. Don't put too much stock in rumors, and it won't affect us at any rate.</q>"""

Job.AlkeniaRest.next.push Page.AlkeniaRestStorm = class AlkeniaRestStorm extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    -- #{@worker} couldn't tell what was being said, but based on whispers and pointing, it was clear the two old men were looking at #{him} and thinking about the Azurai docked somewhere below in the harbor. Seeing that they'd been noticed, one of them tipped his hat at #{@worker} and approached.

  ||
    --> <q>Is it true your captain sailed right through a storm?</q>

  ||
    --> #{@worker} nodded, neither wanting to lie about it nor to spread any more rumors than necessary. Fortunately the man sensed #{his} reluctance, and with another polite hat-tip, retreated."""

Place.Alkenia::jobs.forestry = Job.AlkeniaForestry = class AlkeniaForestry extends Job
  officers:
    Nat: '|officers|Nat'
  label: 'Explore Forest'
  type: 'special'
  text: ->"""Alkenia provides most of the lumber for Vailia's shipyards. Some contacts in the industry would be advantageous for a young captain."""
  energy: -2

Mission.AlkeniaWeapons = class AlkeniaWeapons extends Mission
  label: "Weapons for Alkenia"
  tasks: [
      description: "Have 6 crates of Vailian weapons"
      conditions:
        '|cargo|Weapons': {gte: 6}
    ,
      description: "Bring them to Alkenia"
      conditions:
        '|cargo|Weapons': {gte: 6}
        '|location': {is: Place.Alkenia}
  ]

Job.AlkeniaForestry2 = class AlkeniaForestry2 extends Job
  officers:
    Nat: '|officers|Nat'
    James: '|officers|James'
  label: 'Explore Forest'
  conditions:
    '|cargo|Weapons': {gte: 6}
  type: 'special'
  text: ->"""Alkenia provides most of the lumber for Vailia's shipyards. One of their foremen asked her to bring weapons to defend against raiders from Nonkenia."""
  energy: -2

ShipJob.JamesNoWeapons = class JamesNoWeapons extends ShipJob
  label: "James upset"
  type: 'special'
  conditions:
    '|cargo|Weapons': {gte: 6}
  text: ->"""James isn't entirely happy with selling weapons to Alkenia. It's time to speak with him and address his concerns."""

Job.AlkeniaForestry::next = Page.AlkeniaForestry = class AlkeniaForestry extends Page
  conditions:
    Nat: {}
  text: ->"""|| bg="day|storm"
    -- Alkenia was something of an exception to the normal rules. Few cities dared venture as far and as regularly into the wild as they did. More amazing still was the fact that, as best Natalie could tell from rumors and talk, almost no one disappeared.

  ||
    -- <q>The biggest danger is raiders from Nonkenia,</q> the lumberjack spat the name. <q>They have some devilish pact or other that keeps 'em hidden until too late. You take my advice, miss,</q> he leaned against his burden, a tree trunk almost as big around and tall as as she was,<q> you won't go out there without a nice big group to keep you safe.</q>

    #{q @Nat}I'm not planning on going myself, but thanks for the tip. Mostly I was wondering if there's anything you need?</q> She hadn't been expecting to find the owner of a relatively large company out and carrying logs himself, but it was a pleasant surprise. He was easier to deal with by far than a conniving desk clerk.

  ||
    -- <q>Hah, a Vailian looking to help, there's a new one. You said you were a captain? Not much use to me, then. Kind of you to ask, though.</q> With a grunt he heaved the log back to his shoulder, getting ready to leave. He paused, turning back to her, and she had to duck the swing of his beam. <q>Well, maybe there is something. Bring me a dozen bows with spears and knives to match, good Vailian ones, not the dreck they make down by the pier, and I might start thinking you mean it.</q> He laughed at her expression. That much weaponry was, not to put too fine a point on it, rather expensive.

  ||
    --> <em>New quest: Weapons for Alkenia</em>"""
  effects:
    remove:
      '|location|jobs|forestry': Job.AlkeniaForestry
    add:
      '|missions|AlkeniaWeapons': Mission.AlkeniaWeapons
      '|location|jobs|forestry2': Job.AlkeniaForestry2
      '|map|Ship|jobs|jamesNoWeapons': ShipJob.JamesNoWeapons

ShipJob.JamesNoWeapons::next = Page.JamesNoWeapons = class JamesNoWeapons extends PlayerOptionPage
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.cabinNight"
    #{@James.image 'serious', 'left'}
    -- #{q}Are you sure we should be doing this, Nat?</q> James kicked the crate, producing no sound. The bows inside were well packed. Compared to the beating they'd take during loading or unloading, a stray kick was nothing. It did waft out the scent of the pine oil sealing the contents against saltwater in case the hold flooded. #{q}I don't like being an arms merchant.</q>

  ||
    #{@Nat.image 'normal', 'right'}
    -- #{q}Alkeina's a next door neighbor. It's not like we're selling them to some bloodthirsty warlord. He's just a lumberjack. This is hunting gear anyway, bows and spears and knives.</q> The lantern swayed in her hand, casting dancing shadows across the interior of the cargo hold.

  ||
    #{@James.image 'serious', 'left'}
    --> #{q}I know, I know what we're doing isn't wrong. It just feels like a foot in the door. Once you do this, you're the sort of person who does it, you know? Do me a favor. Let's take these back to Vailia and sell them there.</q>
      #{options ['Carry on', 'Abandon mission'], ["<em><span class='happiness'>+2 happiness</span> for James</em>", "<em><span class='happiness'>+6 happiness</span> for James</em>"]}"""
  effects:
    remove:
      '|map|Ship|jobs|jamesNoWeapons': ShipJob.JamesNoWeapons
  @next: {}

Page.JamesNoWeapons.next['Carry on'] = Page.JamesNoWeaponsIgnore = class JamesNoWeaponsIgnore extends Page
  conditions:
    James: {}
    Nat: {}
  text: ->"""|| bg="Ship.cabinNight"
    #{@Nat.image 'normal', 'right'}
    -- She laid a hand on Jame's forearm with an encouraging smile. #{q}We won't be those sorts of people, I promise. I'm doing this to make a friend, not for money. Thank you for telling me. I really do want to hear it, even if I don't agree this time.</q>

  ||
    #{@James.image 'serious', 'left'}
    --> #{q}I'm glad you listened, at least. Can I say I told you so, next time?</q>He sighed, nodded, and kicked the crate again. A smile took the sting out of his words though. He wasn't the sort to say something like that without meaning it.

    <em><span class="happiness">+2 happiness</span> for James</em>"""
  apply: ->
    super()
    @context.James.add 'happiness', 2

Page.JamesNoWeapons.next['Abandon mission'] = Page.JamesNoWeaponsAgree = class JamesNoWeaponsAgree extends Page
  conditions:
    James: {}
    Nat: {}
  text: ->"""|| bg="Ship.cabinNight"
    #{@Nat.image 'serious', 'right'}
    -- She laid a hand on Jame's forearm with an encouraging smile. #{q @Nat}We won't be those sorts of people, I promise. We'll take them back to Vailia, though I'll take a loss.</q>

  ||
    #{@James.image 'normal', 'left'}
    --> James tilted his head, eyebrows rising. #{q @James}I didn't think you'd actually listen. Huh.</q> His surprise turned into a pleased smile, and he patted her hand where it still lay on his arm. #{q}Thank you, Natalie.</q>

    <em><span class="happiness">+6 happiness</span> for James</em>"""
  apply: ->
    super()
    @context.James.add 'happiness', 6
  effects:
    remove:
      '|missions|AlkeniaWeapons': Mission.AlkeniaWeapons
      '|location|jobs|forestry2': Job.AlkeniaForestry2

Job.AlkeniaForestry2::next = Page.AlkeniaForestry2 = class AlkeniaForestry2 extends Page
  text: ->"""|| bg="day|storm"
    -- <q>Ha, now those are some fine bows,</q> he grinned as he ran his hand along the curve. Smooth, beautiful wood, laminated with horn and polished until it gleamed. Though more expensive than locally made self-bows, the smaller size of Vailian composite weapons made them better suited for dealing with dense foliage and tight spaces, he'd explained. Natalie had simply nodded along, while James wondered in a quiet whisper whether the benefit was really worth the cost of importing them across the ocean.

  ||
    -- #{q g.officers.Nat}I'm glad you like them. It makes my quartermaster a bit uncomfortable shipping weapons though, so I'm afraid it'll be difficult to obtain replacements from me.</q>

    He slapped her on the back, making her stagger with the force of his friendly approval. <q>Nonkenians won't know what hit 'em.</q>

    <em>-2β Wood cost in Alkenia</em>"""
  apply: ->
    super()
    w = g.map.Alkenia.jobs.market.buy.Wood
    w = [w[0], w[1] - 2]
    g.map.Alkenia.jobs.market.buy.Wood = w
  effects:
    cargo:
      Weapons: -6
    remove:
      '|location|jobs|forestry2': Job.AlkeniaForestry2
      '|missions|AlkeniaWeapons': Mission.AlkeniaWeapons
      '|map|Ship|jobs|jamesNoWeapons': ShipJob.JamesNoWeapons

Place.Alkenia::jobs.raid = Job.AlkeniaRaid = class AlkeniaRaid extends Job
  officers:
    James: '|officers|James'
  crew: 2
  label: 'Raid'
  conditions:
    '|weather': {eq: 'storm'}
    '|events|AlkeniaForestry|length': {gte: 1}
  type: 'special'
  energy: -4
  text: ->"""Shouting and the clamor of battle is barely audible over the sounds of the storm, but they're getting closer...

  #{Page.statCheckDescription('combat', 50, Page.AlkeniaRaid.next, @)}"""

Job.AlkeniaRaid::next = Page.AlkeniaRaid = class AlkeniaRaid extends Page
  conditions:
    James: {}
    0: {}, 1: {}, 2: {}, 3: {}, 4: {}, 5: {}
  text: ->"""|| bg="storm"
    --| An alarm beat in the distance, brass gong barely audible over the crash of waves in the harbor. James shielded his eyes, trying to keep the driving rain out of them long enough to see something useful, but to no avail. Alkenia looked quiet as ever, the same buildings huddling together for shelter and same empty streets washing storm water down to the harbor.

  ||
    --> Another alarm, still distant. He and Natalie had heard them a few times in the city, warnings that attackers were in the area. Usually the Alkenians mustered quickly, and a show of force and a few quick arrows were be enough to scare away the small raiding party. A lumber mill would be set fire, a house looted - small damages, mostly meant to reassure the city that the Nonkenians had neither forgotten nor forgiven them.

  ||
    --> It was easy to see how the attackers had penetrated so far into the city today without being confronted. James had to keep a hand on the rail to prevent being tossed about by powerful gusts of wind, and he shuddered to imagine trying to direct a military force in brutal conditions like these.

  ||
    --> Time to get moving. They'd have to defend themselves if the Alkenians were too busy hiding from the storm.

  ||
    #{@James.image 'serious', 'left' }
    -- #{q}That's far enough,</q> James held up an empty hand, the other resting on the sword at his hip. He had to shout to make himself heard. #{q}Docks are off limits.</q> The sailors around him held steady, forming a grim line.

  ||
    --> The raiders stopped. Half a dozen women, each with the same barbed vine painted across their left cheek and running down their necks, slowly smudging as rain washed them clean, each with the same vicious looking dagger in one hand. They didn't say anything. The silence was more terrifying shouting would have been.
  """
  stat: 'combat'
  difficulty: 50
  next: Page.statCheck
  @next: {}

Page.AlkeniaRaid.next['good'] = Page.AlkeniaRaidGood = class AlkeniaRaidGood extends Page
  conditions:
    James: {}
    0: {}
  text: ->"""|| bg="storm"
    -- No one moved. A gust of wind made everyone present stagger.

  ||
    --> Without word or any seeming need to communicate, they turned and departed. #{@[0]} raised a spear to throw at their backs, but James stopped #{him} with a hand on the shoulder. Even if the wind hadn't made the attempt useless, it was better not to provoke them.

  ||
    --> <em><span class="happiness">+3 happiness</span> for James</em>
  """
  apply: ->
    super()
    @context.James.add('happiness', 4)
  effects:
    remove:
      '|location|jobs|raid': Job.AlkeniaRaid

Page.AlkeniaRaid.next['bad'] = Page.AlkeniaRaidBad = class AlkeniaRaidBad extends Page
  conditions:
    James: {}
    victim:
      fill: ->
        crew = g.last.context.filter((p)-> not (p instanceof Officer))
        return Math.choice(crew)
  text: ->"""|| bg="storm"
    -- No one moved. A gust of wind made everyone present stagger.

  ||
    --> Without warning they swept forward again, seeming to move with a single mind, and James barely drew his sword in time to parry the wicked dagger aimed at his chest. Beside him, #{@victim} screamed and fell, tangled with a vine-woman, but he had his own problems to attend to. His attacker ducked under his counterattack and came at him again.

  ||
    -- It was over in an instant, too quickly to think. #{@victim} lay in a bloody heap, while the Nonkenian attackers fled silently. Two of them supported a wounded woman between them, her lip curled back in a silent snarl as she tried to hold the wound closed where James had slashed her. The Vailians were too busy crowding around #{@victim} to pursue, even had they felt a taste for further violence.

  ||
    --> <em>#{@victim} is severely injured. <span class='happiness'>-45 happiness</span>.</em>
  """
  apply: ->
    super()
    @context.victim.add('happiness', -45)
