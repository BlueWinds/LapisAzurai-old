randomLoot = (value)->
  sum = 0
  sold = {}
  cargo = Math.sumObject g.cargo
  while sum < value and cargo
    item = Math.weightedChoice(g.cargo)
    unless g.cargo[item] > (sold[item] or 0)
      continue
    sold[item] or= 0
    sold[item]--
    cargo--
    sum += Item[item].price
  return [sum, sold]

Place.Ship::jobs.otherShip = ShipJob.OtherShip = class OtherShip extends ShipJob
  label: "Another Ship"
  type: 'special'
  conditions:
    chance:
      matches: -> return Math.random() <= 0.1
      optional: true
    '|events|FirstStorm': {}
  text: ->"""In the distance, #{Math.choice g.crew} spots another ship. It'll be easy to avoid, or you could investigate."""

ShipJob.OtherShip::next = Page.OtherShip = class OtherShip extends Page
  conditions:
    sailor:
      fill: -> Math.choice g.crew
  text: ->"""|| bg="Ship.deckDay"
    #{@sailor.image 'normal', 'right'}
    -- #{q @sailor}Ship ahoy!</q> #{@sailor} called out from #{his} position on the starboard side of the deck, and everyone turned to look. Natalie shaded her eyes, trying to make out anything in the bright sun."""
  next: Page.randomMatch
  @next: []

Page.OtherShip.next.push Page.Pirates = class Pirates extends PlayerOptionPage
  conditions:
    sailor: {}
  text: ->
    pirateOptions = [
      Page.statCheckDescription('combat', 50, Page.PiratesFight.next)
      Page.statCheckDescription('diplomacy', 70, Page.PiratesNegotiate.next)
      Page.statCheckDescription('sailing', 65, Page.PiratesFlee.next)
    ]
    return """|| bg="Ship.deckDay"
      --   #{q @sailor}Ship ahoy!</q> #{@sailor} called out from #{his} position on the starboard side of the deck, and everyone turned to look. Natalie shaded her eyes, trying to make out anything in the bright sun.

      There was indeed a dark spot on the horizon – and watching it for several minutes, one by one everyone convinced themselves it was a ship, sailing in their direction, crossing paths at an angle.

    ||
      #{g.officers.Nat.image 'normal', 'left'}
      --   #{q}Everyone take a rest, we're letting them catch us!</q> Natalie's shouted command slowed shipboard activity to a crawl. Meeting with another vessel out in the middle of the ocean might not be the safest possible action, and it would be good to have everyone rested and alert by the time they were close in case there was trouble. James fetched his sword, buckled it on. The rest of the crew did the same. Just in case.

    ||
      -->   Coming in from the windward-side, the vessel bearing down on them was significantly larger than the Azurai, though not nearly as sleek. Harder angles, square sails, and flying no colors. It was fast for its size. The number of crew on its deck and their drawn swords weren't particularly encouraging.
        #{options ['Fight', 'Negotiate', 'Flee'], pirateOptions}
    """
  @next: {}

Page.Pirates.next['Fight'] = Page.PiratesFight = class PiratesFight extends Page
  text: ->"""|| bg="Ship.deckDay"
    #{g.officers.Nat.image 'angry', 'left'}
    -- #{q}Yah!</q> Natalie raised one arm to the sky, her cheer echoed by that of the crew. Though outnumbered, they would put an end to this sea-born menace. The watery depths were dangerous enough on their own, without human marauders adding to the menace.

  ||
    -- She spun the wheel, turning the Azurai into the wind at the last moment, so the two ships shuddered together with a minimum of damage, hulls grinding together with the sound of splintering wood. From the deck of the pirate ship – for that's surely what it was, up close – attackers leapt over the gap between the decks, or swung across on ropes.

  ||
    --> James drew his sword, a ferocious snarl upon his lips directed at anyone who would dare lay hand upon his captain. #{Math.choice g.crew} let out a whooping war cry, and battle was joined on the deck of the Lapis Azurai."""
  next: Page.statCheck
  stat: 'combat'
  difficulty: 50
  @next = {}

Page.PiratesFight.next.veryGood = Page.PiratesFightEasy = class PiratesFightEasy extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Shouting, confusion, blood everywhere... Natalie watched from the poop deck, feeling lightheaded and giddy. Flames licked at both ships from dropped torches and spilled lanterns, but somehow never managed to get a hold of the Azurai, no matter how many tarred-ropes or oiled sails they were thrust against.

  ||
    --> She clung to the wheel, dazed, as the other ship's sails roared up in flames - and somehow even then they didn't spread, flames warded away from her ship even as her crew finished driving off the attackers. #{firstSailor = Math.choice g.crew} even managed to swing across to the other ship and cut several crates of supplies free and toss them into the ocean, but had to cut #{his} daring raid short as it and the Azurai began to drift apart.

  ||
    -- #{q g.officers.Nat}How is everyone? Casualties?</q> Natalie called out.

  ||
    --> #{q g.officers.James}#{secondSailor = Math.otherChoice g.crew, firstSailor} is down with a broken arm and gash in #{his} leg,</q> James reported, and #{secondSailor} waved feebly from the deck below, #{q g.officers.James}but #{he secondSailor}'ll be fine.</q> He slumped against the railing next to her. Though they were all exhausted, they were also elated - outnumbered and outmassed, they'd still done amazingly well.

  ||
    --> <em>+3 Naval Supplies, <span class="energy">-3 energy</span> for all officers, <span class="happiness">+3 happiness</span> for sailors</em>"""
  effects:
    cargo:
      'Naval Supplies': 3
  apply: ->
    super()
    for name, officer of g.officers
      officer.add 'energy', -3
    for name, sailor of g.crew
      sailor.add 'happiness', 3

Page.PiratesFight.next.good = Page.PiratesFightWin = class PiratesFightWin extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Shouting, confusion, blood everywhere... Natalie stumbled backwards, nearly tripping over a fallen pirate. She'd been forced away from the poop deck by the attackers, most of whom had disappeared below decks to find what they could, leaving her to face only two.

  ||
    --> She felt a surge of light-headedness, and one of the attackers screamed, dropping his suddenly red-hot sword. The other paused in disbelief, rapidly shifting eyes darting back and forth the between his companion and the woman they'd thought helpless. He charged.

  ||
    #{g.officers.James.image 'angry', ''}
    -- #{q g.officers.James}Yah!</q> James crashed into him, sending the pirate sprawling across the deck, and ran a sword through him before he could recover from the second bout of surprise. #{q}Get inside, Nat! Now!</q>

  ||
    --> She shook her head, taking a deep breath and a moment to evaluate the situation. Behind them, the roaring of flames began to overwhelm the sounds of battle, the pirate ship burning. Nearly half of the combatants were down on either side, but the pirates were rapidly retreating, realizing that if they wanted to sail away from this on their own ship, they needed to fight the fire and not the Azurai's crew.

  ||
    -- #{q g.officers.Nat}Let them go!</q> Natalie shouted, cutting #{sailor = Math.choice g.crew} off from #{his} charge after one of the retreating pirates. #{He} took one final swipe at his quarry and stopped, turning to where #{Math.otherChoice g.crew, sailor} lay bleeding on the deck.

  ||
    --> James slumped against the railing, closing his eyes for a moment and taking a few deep breaths. They'd won. It was close, but they'd won.

  ||
    --> <em><span class="energy">-3 energy</span> for all officers, <span class="happiness">+1 happiness</span> for sailors</em>"""
  apply: ->
    super()
    for name, officer of g.officers
      officer.add 'energy', -3
    for name, sailor of g.crew
      sailor.add 'happiness', 1

Page.PiratesFight.next.bad = Page.PiratesFightLose = class PiratesFightLose extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Outnumbered and outmatched, the crew of the Azurai fought bravely, making the attackers pay for every inch of deck. Pressed back onto the poop deck, they managed to hold the high ground – mostly because the lower deck held everything the pirates were interested in, including the cargo hatch and captain's quarters. Overhead the skies rapidly darkened, clouds swirling in to blanket the battlefield in dim grey.

  ||
    -- Though she dreaded to imagine what was happening to her bedroom, Natalie didn't dare lose focus. Fire was all around, burning brands and spilled oil, and water tried to rush into the cargo hold, first through gaps in the hull from the ramming and now through intentional damage... she felt each axe stroke on the hull like a strike of lightning in her temple. Wind began to pick up, howling out of nowhere, whipping around clothing and ropes.

  ||
    --> #{Math.choice g.crew} screamed on the stairway as #{he} took a gash across the chest, and stumbled back to give up #{his} position to James. Natalie let out a groan and stumbled as well, feeling the wind shift overhead. James looked back at her, nearly letting a spear in through his guard with the distraction.

  || bg="Ship.deckStorm"
    -- CRACK. A sudden, deafened silence fell over the battle as everyone stopped, ears ringing from the thunder. What had once been the main mast of the pirate ship was now a twisted mess of splinters, tottering slowly, sails majestically tipping into the waves. CRACK. Another pillar of lightning struck from a sky that had been clear only a few minutes earlier, this one on the far side of the pirate ship, missing both vessels.

  || bg="none"
    --> Natalie passed out.

  ||
    --> <span class="energy">-15 energy</span> for Natalie, <span class="happiness">-5 happiness</span> for sailors</em>, #{Item.costDescription @goods}"""
  apply: ->
    @context.goods = randomLoot(120)[1]
    super()
    g.applyEffects {cargo: @context.goods}
    g.officers.Nat.energy -= 15

    for name, crew of g.crew
      crew.add 'happiness', -5

Page.PiratesFightLose::next = Page.PiratesFightLose2 = class PiratesFightLose2 extends Page
  conditions:
    James: '|officers|James'
    Natalie: '|officers|Nat'
  text: ->"""|| slow bg="Ship.cabinNight"
    #{@James.image 'normal', 'right'}
    -- #{q}You're making a bad habit of this, you know,</q> James smiled as Natalie's eyes fluttered open. He had a bandage wrapped around one shoulder, holding the arm in a sling.

  ||
    #{@Natalie.image 'sad', 'left'}
    --> #{q}I'll try. What happened?</q> She reached over to weakly grasp his good hand, echoing with a faint smile of her own.

  ||
    #{@James.image 'normal', 'right'}
    --> #{q}Before or after you conjured up a crazy storm and drove away the pirates?</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> #{q}After. Did I really summon a storm?</q>

  ||
    #{@James.image 'sad', 'right'}
    -- #{q}I guess you must have,</q> he shook his head. If she was having trouble believing it, how was he supposed to feel? #{q}Well, they took a bunch of cargo and fled for their lives.</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> #{q}I'm sorry, James. I messed up.</q>

  ||
    #{@James.image 'normal', 'right'}
    -- #{q}You didn't mess up,</q> he squeezed her hand. #{q}You saved us all.</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> #{q}We wouldn't have needed saving in the first place if it hadn't been for me.</q> She shook her head, denying his right to take away her responsibility. #{q}Keep us moving. I think I'll need a few more days before I can stand up again.</q>"""

Page.Pirates.next['Negotiate'] = Page.PiratesNegotiate = class PiratesNegotiate extends Page
  text: ->"""|| bg="Ship.deckDay"
    #{g.officers.Nat.image 'excited', 'left'}
    -- #{q}Hail!</q> Natalie waved her arm overhead enthusiastically, heading forward across the deck to be closer to her counterparts on the other ship. Seeing the Azurai wasn't attempting to flee, they slowed, coming to a bobbing halt alongside it. From up close it was entirely obvious that the other ship was a pirate vessel – no merchant would sail with such a motley band.

  ||
    -- <q>Sensible of 'ye to let us come up so nice and clean. We have to sink ships that run, just on principle.</q> The other captain shouted across the gap, moving so they stood opposite each other, rails and twenty feet of water in between. <q>So, goin' ta keep being sensible, and we can work out some sort of deal for your cargo that doesn't involve a whole lot of fish food?</q> His none-too-subtle ultimatum drew chuckles from his crew – they certainly outnumbered those aboard the Azurai.

  ||
    #{g.officers.Nat.image 'normal', 'left'}
    -- #{q}I'm sure we can. I'll even discount things slightly for fine upstanding gentlemen like yourselves,</q> Natalie called back, taking a gamble that acting from a position of strength would be better than seeming fearful. It drew murmurs of anger from the pirates, but an appraising eye from the captain.

  ||
    --> <q>And why shouldn't we slit you your throats and take it all for free?</q> Despite the question, he seemed more curious than threatening at the moment.

  ||
    --> #{q}Because I'm a wizard, and it goes poorly for those who cross me.</q> She raised both arms over her head and between them summoned a ball of fire. She extinguished it quickly, before it guttered out on its own and ruined the illusion. Exhausting, and about all she could manage on-demand. But they didn't need to know that."""
  next: Page.statCheck
  stat: 'diplomacy'
  difficulty: 60
  @next = {}

Page.PiratesNegotiate.next.good = Page.PiratesNegotiateSuccess = class PiratesNegotiateSuccess extends Page
  text: ->"""|| bg="Ship.day"
    -- He hesitated, eyes darting around to his crew, torn between a desire not to antagonize a woman who could throw fire and the demand that he not lose face before the other members of the band – an excellent way to become an ex-captain.

  ||
    #{g.officers.Nat.image 'normal', 'left'}
    --> She decided to throw him a bone to help tip the scales. #{q}I do have a spare keg of fine Vailian beer, though, that's burning a hole in my hull. Perhaps you'd like to help deal with it?</q>

  ||
    --> The ability to bribe his crew with alcohol was enough to tilt the scales. <q>We can deal. What've you got?</q>

  ||
    -- <em><span class="money">+#{@money}β</span>, #{Item.costDescription(@goods)}</em>"""
  apply: ->
    [value, sold] = randomLoot(200)
    @context.money = Math.floor(value * 0.8)
    @context.goods = sold
    super()
    g.applyEffects {cargo: @context.goods}
  effects:
    money: 'money'

Page.PiratesNegotiate.next.bad = Page.PiratesNegotiateFail = class PiratesNegotiateFail extends Page
  text: ->"""|| bg="Ship.day"
    -- <q>You're a bold one, I'll grant you that,</q> he chuckled, clearly unimpressed with her display. <q>Tell you what. You take my boy over, show him your cargo, and he'll pick out what he thinks is fair, eh?</q> He slapped a scrawny, scared looking teenager on the back, sending him staggering. Clearly the boy didn't think he was being done any sort of favor.

  ||
    --> Though James didn't like being robbed without putting up a fight, and whispered such in her ear, none of the crew objected to Natalie's decision. They could see easily enough how outnumbered and outmatched they were. The whole transaction was surprisingly civil, if somewhat tense – the pirates took what they wanted most, but decided to cut their gains rather than remain under #{Math.choice g.crew}'s glare for too long.

  ||
    -- <em>#{Item.costDescription(@goods)}</em>"""
  apply: ->
    [value, sold] = randomLoot(300)
    @context.goods = sold
    super()

Page.Pirates.next['Flee'] = Page.PiratesFlee = class PiratesFlee extends Page
  text: ->"""|| bg="Ship.deckDay"
    #{g.officers.Nat.image 'upset', 'left'}
    -- #{q}Ok, I've changed my mind. Not good. Full sail!</q> Natalie called out commands, setting the crew back in motion. They kept their weapons close at hand as they worked, canvas billowing up to catch the wind"""
  next: Page.statCheck
  stat: 'sailing'
  difficulty: 65
  @next = {}

Page.PiratesFlee.next.good = Page.PiratesFleeSuccess = class PiratesFleeSuccess extends Page
  text: ->"""|| bg="Ship.day"
    -- #{q g.officers.Nat}Ok, I've changed my mind. Not good. Full sail!</q> Natalie called out commands, setting the crew back in motion. They kept their weapons close at hand as they worked, canvas billowing up to catch the wind.

    Groaning against its weight, the Azurai bobbed precipitously in the wind, full sails heeling it to an uncomfortable angle before the rudder caught hold and swung the prow around. Then, like a bow sprung from an arrow, the ship surged forward. Perpendicular to the wind they cut away.

  ||
    -- The Azurai's crew cheered and whooped as the other ship crossed their wake, still sailing with the wind and unable to arrest its momentum in time to pursue. The pirates – for that's what they clearly were, from up close – returned the jeers and shouts, waving swords and axes, impotent as their own vessel carried them further away.

  ||
    --> Rather than joining in her crew's cheers, Natalie let out a breath she'd been holding. It'd been close."""

Page.PiratesFlee.next.bad = Page.PiratesFleeFail = class PiratesFleeFail extends Page
  text: ->"""|| bg="Ship.day"
    -- #{q g.officers.Nat}Ok, I've changed my mind; not good. Full sail!</q> Natalie called out commands, setting the crew back in motion. They kept their weapons close at hand as they worked, canvas billowing up to catch the wind

    Groaning against its weight, the Azurai bobbed precipitously in the wind, full sails heeling it to an uncomfortable angle before the rudder caught hold and swung the prow around. A moment too slow – Natalie ducked as an arrow sailed across the deck, too close for comfort, then was thrown from her feet by a grinding collision.

  || bg="Ship.deckDay"
    -- The horrible sound of wrenching wood and burbling water finding ways to run inside were nothing compared to the massed roar of the pirates – for that was surely what they were, at close range – as they leaped or swung over towards the Azurai. James stood in front of her, ready to protect his captain from all comers, a grim expression covering his face in the brief moment before he turned away and prepared to fight for his life. #{Math.choice g.crew} let out a shout and met the attackers on deck. Battle was joined.

  ||
    --> <em>+6 ship damage</em>"""
  apply: ->
    super()
    g.map.Ship.applyDamage(6)
  next: Page.statCheck
  stat: 'combat'
  difficulty: Page.PiratesFight::difficulty
  @next = Page.PiratesFight.next

Page.OtherShip.next.push Page.AbandonedShip = class AbandonedShip extends PlayerOptionPage
  conditions:
    sailor: {}
  text: ->"""|| bg="Ship.day"
    -- #{q @sailor}Ship ahoy!</q> #{@sailor} called out from #{his} position on the starboard side of the deck, and everyone turned to look. Natalie shaded her eyes, trying to make out anything in the bright sun.

    Drifting slowly closer, it became apparent that the other ship was abandoned, listing to one side as though it had taken on a great deal of water. The Azurai put on sail to approach more rapidly.

  ||
    -- It was more of a half-floating wreck than a real ship at this point, wind-slashed sails and rotting timbers. #{Math.choice g.crew} suggested immediately that they fire the thing and be on their way – a funeral fitting an abandoned ship. Hard to say though – there might still be something valuable aboard, and even if not, some of the wood or sailcloth might still be salvageable. Not to mention curiosity for its own sake.

    #{options ['Fire it', 'Search'], ["<span class='happiness'>+2 happiness</span> for crew", "You might find something good"]}"""
  @next = {}

Page.AbandonedShip.next['Fire it'] = Page.AbandonedShipBurn = class AbandonedShipBurn extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Bowing to tradition and the crew's unease about robbing a grave, Natalie ordered a bow produced, and had James soak a rag in oil.

  ||
    --> Burning an abandoned ship wasn't hard – with pitch rubbed into the hull, oil in the ropes and wax in the canvas, even a nearly-rotten hulk like this was soon ablaze. They watched solemnly, Natalie giving voice to a prayer they were all thinking.

  ||
    --> When the wreck finally collapsed down the middle, they set sail again. Time to get going, and hope that the Azurai never met the same fate."""
  apply: ->
    super()
    for key, crew of g.crew
      crew.add 'happiness', 2

Page.AbandonedShipDone = class AbandonedShipDone extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Burning an abandoned ship wasn't hard – with pitch rubbed into the hull, oil in the ropes and wax in the canvas, even a nearly-rotten hulk like this was soon ablaze. They watched solemnly, Natalie giving voice to a prayer they were all thinking.

  ||
    --> When the wreck finally collapsed down the middle, they set sail again. Time to get going, and hope that the Azurai never met the same fate."""

Page.AbandonedShip.next['Search'] = Page.AbandonedShipSearch = class AbandonedShipSearch extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Natalie led the expedition, guiding from the prow of the Azurai's longboat as they rowed in closer than she wished to risk the larger vessel. It was with a solemn air that they searched the wreck."""
  next: Page.randomMatch
  @next: []

Page.AbandonedShipSearch.next.push Page.AbandonedShipNothing = class AbandonedShipNothing extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Natalie led the expedition, guiding from the prow of the Azurai's longboat as they rowed in closer than she wished to risk the larger vessel. It was with a solemn air that they searched the wreck.

    Despite a thorough search, they found nothing of value. Other than waterlogged timbers and rotten sailcloth, it had already been stripped bare. Tired out and on edge from having wasted a day to no gain, Natalie ordered the wreck torched."""
  next: Page.AbandonedShipDone

Page.AbandonedShipSearch.next.push Page.AbandonedShipSupplies = class AbandonedShipSupplies extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Natalie led the expedition, guiding from the prow of the Azurai's longboat as they rowed in closer than she wished to risk the larger vessel. It was with a solemn air that they searched the wreck.

    While they didn't find any cargo beyond thoroughly water-ruined provisions, #{sailor1 = Math.choice g.crew} did discover a stash of well-preserved canvas, and #{Math.otherChoice g.crew, sailor1} stumbled upon a still-sealed barrel of pitch. Not the most glamorous of treasure, but combined with a some usable boards pried up from the deck, nothing to scoff at.

  ||
    --> <em>+2 Naval Supplies, +4 Wood</em>"""
  effects:
    cargo:
      'Naval Supplies': 2
      Wood: 4
  next: Page.AbandonedShipDone

Page.AbandonedShipSearch.next.push Page.AbandonedShipCargo = class AbandonedShipCargo extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Natalie led the expedition, guiding from the prow of the Azurai's longboat as they rowed in closer than she wished to risk the larger vessel. It was with a solemn air that they searched the wreck.

    Though most of it was ruined, the crew managed to salvage several crates full of raw iron. The vessel must have been floating abandoned for quite some time for rust to have done as much damage as it had.

  ||
    --> <em>+4 Iron</em>"""
  effects:
    cargo:
      Iron: 4
  next: Page.AbandonedShipDone

Page.AbandonedShipSearch.next.push Page.AbandonedShipMoney = class AbandonedShipMoney extends Page
  text: ->"""|| bg="Ship.deckDay"
    -- Natalie led the expedition, guiding from the prow of the Azurai's longboat as they rowed in closer than she wished to risk the larger vessel. It was with a solemn air that they searched the wreck.

    The cargo hold was empty, but following some instinct or other, Natalie searched the captain's cabin carefully – whoever gutted the ship before had missed a small hidden compartment, just below the waterline. Though the papers within were ruined, gold and silver coins didn't care about spending a few months underwater.

  ||
    --> <em>+93β</em>"""
  effects:
    money: 93
  next: Page.AbandonedShipDone

Page.OtherShip.next.push Page.LocalMerchants = class LocalMerchants extends Page
  conditions:
    location: matches: -> g.location.name not in ['Vailia', 'MtJulia']
  text: ->"""|| bg="Ship.day"
    -- The ship heading for them looking like it might be local to the area, and appearances did not deceive. Slightly larger than the Lapis, it held on its deck a dozen friendly looking sailors. Though they were all armed – a crew would be foolish not to carry weapons when greeting strangers – Natalie sensed no hostility from them, and the assessment was mutual. No blades were drawn as the ships drew up next to each other.

  ||
    -- After a few shouted words, they lay a plank across the gap between the ships, and #{g.officers.asArray().wordJoin()} crossed over to the other deck where there was more room. Though both captains had a schedule to keep, they agreed that at least a few minutes exchanging news was in order.

    <em><span class="happiness">+1 happiness</span>, <span class="business">+1 business</span> for crew</em>"""
  apply: ->
    super()
    for i, sailor of g.crew
      sailor.add('happiness', 1)
      sailor.add('business', 1)

Page.OtherShip.next.push Page.VailianMerchants = class VailianMerchants extends PlayerOptionPage
  conditions:
    location: matches: -> g.location.name not in ['Vailia', 'MtJulia', 'Alkenia', 'Nonkenia', 'BlackSands']
  text: ->"""|| bg="Ship.day"
    -- Triangular sails - #{Math.choice g.crew} was the first to spot them on the other ship - and #{he} loudly guessed that it was a Vailian vessel. Despite all odds, so far from home, #{he} was proven right half an hour later, when they were close enough to make out more details. A Vailian-made ship meant Vailian crew – the city did not sell to outsiders, jealously guarding its ship-building secrets.

  ||
    -- The two vessels pulled up alongside each other and, after a few shouted exchanges, two officers jumped over to the Lapis for a closer discussion. They were just as eager as Natalie and James to share news of home, and the crews spent half an hour shooting the breeze while the officers shared knowledge of the winds and currents in the area.

    <em><span class="sailing">+1 sailing</span> for each officer, <span class="happiness">+2 happiness</span> for crew</em>"""
  apply: ->
    super()
    for i, sailor of g.crew
      sailor.add('happiness', 2)
    for i, officer of g.officers
      officer.add('sailing', 1)
