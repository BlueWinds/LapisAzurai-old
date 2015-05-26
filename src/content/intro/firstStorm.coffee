
Place.Vailia::firstVisit = Page.FirstStorm = class FirstStorm extends Page
  conditions:
    Ship: '|map|Ship'
    Nat: '|officers|Nat'
    James: '|officers|James'
    sailor: {
      fill: ->Math.choice g.crew
    }
  text: ->"""|| bg="Ship.cabinStorm"
    -- #{q @James}Natalie! <b>Nat! Get up!</b></q> James pounded on her door and shouted.

  ||
    #{@Nat.image 'normal', 'center'}
    --> #{q}What?</q> She slipped up out of bed, on her feet and shrugging on a shirt even while he answered. There was no light outside – still night. No, not night...

  ||
    #{@Nat.image 'serious', 'center'}
    --> #{q @James}A storm is rolling in! I've got the crew pulling up the sails, but it's eating the horizon like you wouldn't believe...</q> He stepped out of the way as she opened the door in his face.

  || bg="Ship.deckStorm"
    -- In one direction lay a peaceful night – dark sky and twinkling stars, ocean quiet but growing rougher. In the other... she groaned.

  || bg="Ship.deckStorm"
    #{@Nat.image 'angry', 'left'}
    --> #{q}Take the sails in, lock down all the booms, get everyone else up,</q> she left the door swinging open and scrambled for something warmer to wear. Waxed cap, waxed jacket, stiff boots – everything she'd need for working outdoors in the worst weather the ocean could throw at them.

  || bg="Ship.storm"
    -- By the time she was dressed, the storm loomed almost overhead, howling winds whipping the water into a dark purple froth. Rain sleeted around them, drenching the deck and making everything slippery. The crew was already hard at work, battening everything down for a blow. She found James at the helm, pushed him aside and took the wheel herself.

  || bg="Ship.deckStorm"
    #{@Nat.image 'serious', 'left'}
    -- #{q}Not good. It's a big one,</q> Natalie had to shout to be heard over the sound of the ocean.

  ||
    #{@James.image 'angry', 'right'}
    --> #{q}How do you know!?</q>

  ||
    #{@Nat.image 'serious', 'left'}
    --> #{q @Nat}It's... it'll take five, six hours to blow past!</q> She tasted the wind, unfurling instincts seldom used. The first wave caught them from the side before she could turn the ship.
    </continue>

  ||
    #{@James.image 'upset', 'right'}
    --> #{q}<b>How do you know!</b></q> James repeated his question, grabbing her waist to steady her as the water washed over the deck below.

  ||
    -- Two sailors snapped to the end of their safety lines, saved by the rope anchoring them to their posts, while the rest remained on their feet. This one hadn't risen high enough to flood over the poop deck, but it was just a warm up. Looking deeper into the storm from their position at the top of the wave, they could see even more monstrous waves coming toward them. Natalie spun the wheel, hoping desperately that the ship would turn fast enough to take the next head-on.

  ||
    -- Storms like this swept across the world, leaving nothing but wreckage in their wake. Refuges like Mt. Julia were vital for any ships to survive at all. Seagoing vessels existed as fugitives, darting between safe ports in the intervening lulls. No captain set sail in anything except perfect weather, to reduce their chances of getting caught out. Like they had. And even still, as often as not, ships were unlucky. Like they were.
"""

Page.FirstStorm::next = Page.FirstStorm2 = class FirstStorm2 extends Page
  conditions:
    Ship: {}
    Nat: {}
    James: {}
    sailor: {}
  text: ->"""|| bg="Ship.storm"
    -- Another wave towered over them, a tremendous mountain in the ocean. James managed to wrap a rope around Natalie's waist and tie it to the wheel just in time. This one didn't spill over the deck as more than a plume of spray, but surging water and gusting wind spun the ship around like a cork, and the deck tilted precipitously.

  || bg="Ship.deckStorm"
    #{@James.image 'angry', 'right'}
    --> James shouted something at her, but Natalie couldn't hear what he said, drowned out by howling wind that hit them almost like a solid object. He pointed. #{@sailor} hung limply from #{his} line, blood running from #{his} forehead. Natalie shook her head, made a sharp gesture of denial – James shouldn't go down there. He gritted his teeth and ignored her, untied his line and ran down the stairs.

  || bg="Ship.storm"
    -- This was the sort of storm that left no survivors. A Grandmother Storm. The last had been just a month ago. Natalie had helped comb the beach for wreckage and survivors in its wake. There were precious few of the latter, and far too much of the former.

  ||
    --> A wave towered over them, reaching halfway up the main mast for a brief moment before it crashed over the deck. Natalie clung to the wheel, fighting the maelstrom that tried to tear her away from her post. The Azurai popped out of the water on the other side, creaking timbers audible even over the sound of the wind. She checked the deck. James clung to one of the masts, holding #{@sailor} in one arm.

  ||
    -- Against all odds, she felt giddy, alive. Death was so close, and yet... and yet, it wouldn't claim them. She could feel it in her bones, taste it in the wind, smell it in the salt spray. Natalie felt the storm as though it were an extension of her own body, felt the howling power that fed it, felt a hundred miles of terrible elemental force seeking release...

  ||
    -- ...

  || bg="Ship.deckStorm"
    #{@Nat.image 'excited', 'left'}
    -- James looked up at the wheel where Natalie hung onto it, dazed, looking more like a drowned rat than his best friend. In the brief lull between waves, he saw... he rubbed his eyes. She was grinning like a madwoman. #{@sailor} stirred in his arms.

  || bg="Ship.cabinStorm"
    --> He cut away #{his} rope with a knife and dashed towards the door below decks, slamming it behind him just as another wall of water crashed over the ship. He leaned down, examined #{@sailor}'s forehead. Still breathing. Just a crack on the head. #{He}'d be fine.

  || bg="Ship.deckStorm"
    -- James pushed back into the storm, wind instantly cutting away any semblance of warmth he'd gathered inside. Clinging to the rail for stability against the violently pitching deck, he pushed his way back up to the poop deck. Natalie hadn't moved. She still clung to the wheel, grinning madly. He grabbed her shoulder, shouted something even he couldn't hear.

  ||
    -- #{q @Nat}Do you know why they gave me a ship, James? I'm smart, and I'm pretty, but that's not why.</q> Her voice somehow cut through the wind, though he could barely hear his own shouting. He shook his head. This wasn't the time for that.

  ||
    --> #{q}They gave me a ship because I'm not going to die!</q> She let go of the wheel with one hand, gripped his shoulder with manic strength. Another wave crashed over the ship, burying them both in boiling, freezing foam for a moment. When it cleared, one of the sails had ripped away, floating in the ocean nearby, but the mast itself was still intact.

  ||
    -- James shook his head again, trying to clear it. That they hadn't sunk yet was nearly a miracle. Whatever manic state had come over her, Natalie was still alive, and still holding the wheel, turning as best she could to face each new assault from the storm. In a brief lull in the wind, he heard someone below shouting to get buckets and head below decks. He clasped her shoulder again and headed off to help.

  || bg="none" slow="true" auto="4000"
    <h4>...</h4>"""

Job.IntroSickNat = class IntroSickNat extends Job
  label: "Fetch Priest"
  text: ->"""Natalie hasn't stirred since she passed out at the helm yesterday, and her fever is running high. Someone should probably look at her to find out what's wrong."""
  type: 'plot'
  officers:
    James: '|officers|James'
    Natalie: '|officers|Nat'
  acceptInjured: true
  energy: 0

Page.FirstStorm2::next = Page.FirstStorm3 = class FirstStorm3 extends Page
  conditions:
    Ship: {}
    Nat: {}
    James: {}
    sailor: {
      fill: ->Math.choice g.crew
    }
  text: ->"""|| slow="true" bg="Ship.deckNight"
    -- Silence.

  ||
    #{@James.image 'sad', 'right'}
    --> James clung to the railing, shivering, and trying not to pass out from the twin pangs of exhaustion and chill. But he was alive. They were all alive, by some miracle. The sea still rolled, waves still occasionally rose high enough to spray the deck, but it was clear they'd passed through the worst of the storm. Light grew on the horizon - dawn, slowly pressing its way through the clouds overhead.

  ||
    -- He stumbled to his feet, slipped on a loose rope, steadied himself with an arm on the railing. Deep weariness penetrated all the way to his bones, sapping every ounce of strength. Just a little more. He dragged himself across the deck, slapping #{@sailor} on the back where #{he} doggedly passed on pails of water handed up from below decks.

  ||
    -- Up on the poop deck he found Natalie, passed out and still tied to the wheel.  Numb fingers fumbled with the rope, then he bypassed them by using a knife to cut her free. They had plenty of rope. He winced away from the contact. Unlike his own icy skin, she was burning hot to the touch, as if wracked by a terrible fever. Only the strength and steadiness of her breaths reassured him she wasn't on death's doorstep.

  || bg="Ship.cabinNight"
    -- He carried her down below decks, to her cabin. Against all odds, the interior was still dry. Even a Grandmother Storm that had snapped both masts and torn away every sail hadn't been a match for the rubber seal around the door to the captain's cabin.

  ||
    --> Efficiently he stripped her, all the way down to bare skin. Any other time he would have hesitated, or at the very least been blushing and mortified as he worked, but not now. Any feelings beyond mere practicality were gone, washed away somewhere in the last six hours.

  ||
    #{@James.image 'serious', 'right'}
    -- He pulled the sheets up around her neck, then a blanket, then fumbled another one from a chest to lay over her. She didn't stir. Her skin still burned.

  ||
    #{@James.image 'serious', 'right'}
    --> He slumped to the floor, his back to her bed, and waited.

  ||
    --> Waited.

  || bg="none"
    --> Slept.
"""
  apply: ->
    super()
    g.passDay()
    @context.Nat.energy = -10
    g.map.Ship.damage = 18
  effects:
    add:
      '|location|jobs|sick': Job.IntroSickNat

Job.IntroNatAwake = class IntroNatAwake extends Job
  label: "Awake"
  text: ->"""Too much sleeping. Time to get up and up and at'em."""
  type: 'plot'
  officers:
    Natalie: '|officers|Nat'
  acceptInjured: true
  energy: 4

Job.IntroSickNat::next = Page.IntroSickNat = class IntroSickNat extends Page
  conditions:
    James: {}
    Natalie: {}
  text: ->"""|| bg="marketDay"
    -- <q>And she hasn't moved since?</q> The priest shook his head, trying to keep pace with the young man as he pushed his way through the crowd.

  || bg="day"
    #{@James.image 'serious', 'left'}
    --> #{q}Right. She was burning hot at first, like a harsh fever, but she wasn't sweating at all, and looked perfectly comfortable.</q> James gave everyone apologetic looks, but didn't stop bulling towards the ship, priest in tow.

  ||
    --> No one had expected a ship to come into dock the day after a Grandmother Storm, and even with two masts snapped, the Azurai was in remarkably good condition. No hands lost. That was news. News attracted crowds. Natalie would know how to deal with this, but that wasn't much help when Natalie was the thing that needed dealing with.

  ||
    #{@James.image 'serious', 'left'}
    --> James nodded to #{Math.choice g.crew}, guarding the deck, and looking somewhat overwhelmed. #{He} didn't have any answers to give about how they'd survived. None of them did.

  || bg="Ship.cabinDay"
    -- Natalie looked exactly as she had yesterday, cheerful cheeks the perfect picture of health, chest rising and falling steadily. The priest glanced at James for permission, then knelt down next to her and put his ear to her chest. James wished he could sense magic, even the slightest bit, but his family had never displayed an inch of talent, no matter how far back they went. He had no way of telling a charlatan from a healer.


  ||
    --> Not that there was really any danger in that - the Ocean Father's temple was the largest in Vailia, and they'd have quickly chased away anyone standing in their sanctuary wearing their robes who didn't belong.

  ||
    -- After only a minute of listening to Natalie breathe, the priest shook his head as though to clear it and stood again. <q>I'm afraid there is nothing I can do. Rest, rest and time is the only solution.</q>

  ||
    #{@James.image 'serious', 'left'}
    --> #{q}Solution to what?</q> James pursed his lips, trying to dispel the previous thought. That it had been unfair of him to consider such a thing.

  ||
    --> The priest tilted his head, as though confused by the question. <q>The shock.</q>

  ||
    #{@James.image 'serious', 'left'}
    -- James just stared, waiting for him to go on.

  ||
    --> <q>Magical drain. She must be quite powerful, to bring your ship through a storm like that.</q> Seeing the confusion reflected in James' face, he finally deigned to explain. <q>Your captain here is a sorceress. And as I said, quite a powerful one at that. I wouldn't dare touch storm-energy. It's amazing she survived, but she'll make a full recovery, given enough time.</q> He patted James' arm. <q>No charge, since I didn't do anything. Please ask her to stop by our temple once she awakens, if she is so inclined.</q>
"""

Page.IntroSickNat::next = Page.IntroSickNat2 = class IntroSickNat2 extends Page
  conditions:
    James: {}
    Natalie: {}
  text: ->"""|| bg="Ship.cabinDay"
    -- Given the lack of response from James, he settled for patting him on the shoulder again. <q>I'll see myself out.</q>

  ||
    --> A sorceress.

  ||
    --> Damn.

  ||
    -- He cupped his face in both hands and rubbed his eyes. It was an answer to far too many questions, but it raised more questions still. First among them, why hadn't she told him? They'd been friends since he was old enough to walk. Magic never manifested until puberty. They would have been best friends for a decade when she learned what she was.

  ||
    --> It was a rare gift. One in ten thousand had a spark of magic, enough to light a candle. To hold a ship safe through a storm? He wondered if there were more than five mages that powerful in the entire city.

  ||
    --> Why hadn't she told him?
"""
  effects:
    remove:
      '|location|jobs|sick': Job.IntroSickNat
    add:
      '|location|jobs|sick2': Job.IntroNatAwake
  apply: ->
    super()
    @context.Natalie.energy = -6

Mission.VailiaTradeRoutes = class VailiaTradeRoutes extends Mission
  label: "Find Trade Routes"
  tasks: [
      description: "Find a route to a nearby city, Alkenia"
      conditions:
        '|location|destinations|Alkenia': {gt: 0}
    ,
#       description: "Find a route to Black Sands, a major source of raw iron"
#       conditions:
#         '|location|destinations|BlackSands': {gt: 0}
#     ,
      description: "(try the library)"
  ]
  removeWhenDone: true

# Mission.VailiaFindJobs = class VailiaFindJobs extends Mission
#   label: "Get Hired"
#   tasks: [
#       description: "More profitable than pure bulk shipping is a specific job from someone who needs a ship. Find one."
#       conditions:
#         '|day': {eq: 0} # Always false, this mission is just removed directly.
#   ]

Mission.VailiaExploreCity = class VailiaExploreCity extends Mission
  label: "Explore Vailia"
  tasks: [
      description: "While foreign shores have a draw of their own, Vailia is possibly the most prosperous city in the world, and has plenty of attractions."
    ,
      description: "Visit the beach"
      conditions:
        '|events|Beach|length': {gte: 1}
    ,
      description: "Read in the Library"
      conditions:
        '|events|Library|length': {gte: 1}
    ,
      description: "Take a lesson"
      conditions:
        '|events|Defense|length': {gte: 1}
  ]
  removeWhenDone: true

Mission.VailiaFirstMoney = class VailiaFirstMoney extends Mission
  label: "Raise Capital"
  tasks: [
      description: "One bad disaster could be enough to bankrupt Natalie, an uncomfortable position to be in."
    ,
      description: "Increase your savings to 1000β."
      conditions:
        '|officers|Nat|money': {gte: 1000}
  ]
  removeWhenDone: true

Job.IntroNatAwake::next = Page.IntroNatAwake = class IntroNatAwake extends Page
  conditions:
    Natalie: {}
  text: ->"""|| bg="Ship.cabinDay"
    -- Natalie jerked awake, pulse pounding. The ship... the ship was safe, rocking gently beneath her. Instinctively she reached out, feeling fractures and weak points... and winced back, mind burning. Like touching a half-healed wound, or pulling with a strained muscle, the minor effort she'd put forth was enough to warn her that further pressing her magic would only lead to passing out again.

  ||
    --> She felt weak, swinging her legs down off the edge of the bed, but steady enough. Someone had dressed her in a nightgown, and a cup of water waited on the desk for her attention. Also a roll, freshly baked even. Very considerate of them. She tore into it with an appetite.

  ||
    -- They were, she surmised, back in Vailia. Mount Julia didn't have fresh baked garlic-cheese-rolls. They. Better check who <q>they</q> were. Her last memory was of pounding power surging through her body and a wave towering over the ship, threatening to reduce the Lapis to splinters if she couldn't grip the entire vessel tightly enough.

  || bg="Ship.deckDay"
    #{g.crew[0].image 'happy', 'right'}
    --> #{g.crew[0]} and #{g.crew[1]} grinned at her as she stood in the doorway, blinking owlishly in the bright light. #{q g.crew[0]}Welcome back, Captain,</q> #{g.crew[0]} volunteered, with a lazy salute and a grin.

  ||
    #{@Natalie.image 'normal', 'left'}
    -- #{q}How long was I asleep?</q> Natalie rubbed her eyes, looking out on the busy port. Standing in her nightshirt and underwear, she attracted no attention - women wearing less were an everyday sight in this city.

  ||
    #{g.crew[0].image 'normal', 'right'}
    --> #{q}Two days. You passed out at the wheel, but we made it through the storm, somehow, and limped home on one sail. The quartermaster is out in the city right now. Anything you need, captain?</q>

  ||
    #{@Natalie.image 'excited', 'left'}
    --> #{q}Nope, just a little something to eat and I'll be back in action. Good work,</q> she punched #{g.crew[0]} lightly in the shoulder. #{q @Natalie}We made it. That's one for the record books.</q>

  ||
    -- <em>New Mission: <strong>Find Trade Routes</strong></em>
      <em>New Mission: <strong>Explore the City</strong></em>
      <em>New Mission: <strong>Get Hired</strong></em>
      <em>New Mission: <strong>Raise Capital</strong></em>
  """
  effects:
    remove:
      '|location|jobs|sick2': Job.IntroNatAwake
    add:
      '|missions|tradeRoutes': Mission.VailiaTradeRoutes
#       '|missions|findJobs': Mission.VailiaFindJobs
      '|missions|exploreCity': Mission.VailiaExploreCity
      '|missions|raiseFunds': Mission.VailiaFirstMoney
      '|map|Ship|jobs|jamesUpset': ShipJob.JamesUpset
