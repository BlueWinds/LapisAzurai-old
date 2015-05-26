Place.Alkenia::jobs.meetKat = Job.MeetKat = class MeetKat extends Job
  label: "Pickpocket"
  type: 'plot'
  text: ->"""Someone running through the crowd, a merchant shaking their head and looking apologetic... Wait, where's Natalie's purse?#{if g.events.MeetKat then "" else " <em>-35β</em>"}"""
  energy: -1
  officers:
    Natalie: '|officers|Nat'
  conditions:
    '|weather': {eq: 'calm'}
    '|events|AlkeniaMarket|length': {gte: 1}
    '|officers|Nat|money': {gte: 35}
    '|events|MeetKat': # If is has happened before, must be at least a week ago.
      matches: (days)-> if days then days[0] + 7 < g.day else true
      optional: true
  next: Page.firstNew
  @next = []

Job.MeetKat.next.push Page.MeetKat2 = class MeetKat2 extends Page
  conditions:
    Natalie: {}
  text: ->"""|| bg="day"
    -- Alkenia's market was a crowded place, stalls buying and selling almost every imaginable good. Though, Natalie noted, the prices were often somewhat inflated compared to what one would pay in Vailia itself. She had never before had enough money to consider most of the items on sale, or at least not had the intention to spend that much money. She was too busy saving up for her grand adventure. Now, though... now she could sample whatever she liked and call it a business expense. A merchant had to know what, exactly, they were selling, after all!

  ||
    -- The aroma of a spice rack drew her irresistibly towards it. Most of the scents she could at least identify, but not one that stood out.

  ||
    --> <q>Sin-namon. You're smelling sin-namon,</q> the merchant smiled at her twitching nose. <q>Special import. I hear tell it comes from beyond Kantis, north and east so far I didn't even recognize the name of the place. Amazing, isn't it?</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    --> Natalie leaned close to the jar. It had a perforated top and sat over a candle to spread the smell as far as possible. A dirty trick, but effective advertising, none the less. #{q}It does smell marvelous. What is it?</q>

  ||
    -- #{q}Tree bark. Boil it or grind it up. 10 obols an ounce, but a little goes a long way. Limited supplies.</q> He gestured to a single, half empty crate behind him.

  ||
    --> Natalie whistled at that. Truly it must come from halfway around the world to warrant that price – or he was a con artist, and a splendid one. The smell though - she'd never scented anything like it in her life, nor heard of it. A cargo hold full of that and she'd be set for life. #{q}Interesting. Does it taste like it smells? I might consider...</q>

  ||
    -- A flash of movement caught her eye, and a sudden feeling of a breeze. She patted her pocket, and found no bundle of coins. She spun on her heels, catching another flash of motion: a young woman, disappearing into the crowd.

  ||
    #{@Natalie.image 'upset', 'left'}
    --> #{q}Pickpocket!</q> Natalie shouted. Heads turned, a path cleared, but too late. The girl was gone, lost somewhere in the crowd.

  ||
    #{@Natalie.image 'serious', 'left'}
    --> Natalie stopped, shook her head in dismay, assessed the situation. It wasn't much money, all told, but still... She shook her head. She was getting careless, to let someone lift off her.
"""

Job.KatTrial = class KatTrial extends Job
  label: "Kat's Trial"
  conditions:
    '|events|MeetKat': matches: (days)-> return days[0] < g.day - 7
  type: 'plot'
  text: ->"""Kat's hearing is scheduled for... whenever. They're happy to let her rot in a cell until Natalie decides to attend."""
  energy: -1
  officers:
    Natalie: '|officers|Nat'

katOptions = [
  "I'll be there (<em><span class='happiness'>+3 happiness</span> for Kat</em>)"
  "Any chance I can get my other money back? (<em><span class='diplomacy'>+1 diplomacy</span> for Natalie</em>)"
  "No thanks, I have better things to do. (<em><span class='happiness'>-3 happines</span> for Kat, <span class='business'>+2 business</span> for Natalie</em>)"
]

Job.MeetKat.next.push Page.MeetKat3 = class MeetKat3 extends PlayerOptionPage
  conditions:
    Natalie: {}
    Kat: '|people|Kat'
    Guard: '|people|AlkeniaGuard'
  text: ->"""|| bg="day"
    #{@Natalie.image 'normal', 'left'}
    -- Wandering the market, enjoying the scene, looking for new and exotic items, Natalie was enjoying her afternoon. A slight breeze, a feeling of lightness, a...

  ||
    #{@Natalie.image 'excited', 'left'}
    --> #{q}Not this time, thief!</q> Natalie's hand closed around a wrist, fumbled as it tried to pull away, then gripped tightly.

  ||
    #{@Natalie.image 'angry', 'left'}
    -- She managed to catch the young woman in the side of the head with a fist. The blow dazed her, and Natalie took the opportunity to wrap an arm around her neck, bending her over and holding her firmly in place. Natalie wasn't the strongest woman, but compared to her, the pickpocket might as well have been a feather.

  ||
    #{@Kat.image 'upset', 'right'}
    --> A feather that fought dirty. She stomped on Natalie's toes (mildly effective through thick ship-boots), then elbowed her in the stomach (quite effective through a thin shirt), and shoved her way free in the sudden confusion.

  ||
    #{@Kat.image 'serious', 'right'}
    -- She made a quick run for it... straight into the stomach of a burly guard, who held onto the tiny woman with somewhat more success despite her struggles.

  ||
    #{@Natalie.image 'upset', 'left'}
    --> #{q}She was... oof... taking my money,</q> Natalie gasped out, leaning on one arm against a nearby stone wall. #{q}Wasn't expecting a fight.</q>

  ||
    #{@Guard.image 'serious', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    --> The girl became still, quickly realizing the futility of further escape attempts. She was younger than Natalie, probably, and though taller, skinny enough to shame a pole. Little more than skin and bones, really, with big, soulful eyes that made Natalie want to give her a hug.

  ||
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'serious', 'far-right'}
    -- The guard shook the woman's bag. It rattled with the sound of silverware. <q>If I talk to the woman selling these, am I going to find they were bought properly, Kat?</q> He seemed to know her, and the exasperated tone of his voice suggested this was not the first such incident. <q>Is she going to be able to tell me what's in your bag better than you can?</q>

  ||
    #{@Guard.image 'serious', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    --> "Kat" didn't say anything, just shuffled her feet and hung her head. It looked like she was going to start crying at any moment.

  ||
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'serious', 'far-right'}
    -- <q>I'm sorry for the trouble, miss.</q> He addressed Natalie, tightening his hold on the thief's arm even more until Natalie winced in sympathy.

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}Not at all. Thank you for catching her. 18β in mixed coinage, primarily Valian silver, if I may.</q> She gestured to her purse laying on the ground where Kat had dropped it during the struggle. The guard nodded, not bothering to check the exact contents to verify that they matched Natalie's description.

  ||
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    -- <q>If you're interested, I suspect the judge has finally had enough of her shenanigans.</q> He shook the captive waif by the shoulder. <q>There should be a trial in a week or so.</q>
      #{options ['Sure', 'Stolen purse?', 'Not interested'], katOptions}
"""
  effects:
    add:
      '|location|jobs|katTrial': Job.KatTrial
    remove:
      '|location|jobs|meetKat': Job.MeetKat
  @next = {}

Page.MeetKat3.next.Sure = Page.MeetKatSure = class MeetKatSure extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: {}
  text: ->"""|| bg="day"
    #{@Natalie.image 'normal', 'left'}
    -- #{q}I'll be there.</q> Natalie took a moment to count the money in her pouch.

  ||
    #{@Guard.image 'normal', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    --> Kat started to cry silently, hiccing as the guard cuffed her ear. She aimed a dispirited kick at his shin, but he didn't much seem to notice through the heavy leggings.

  ||
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    -- #{q}Don't feel too bad for her. She and her boyfriend have been terrorizing the market for months. You're just the first fast enough to catch her in the act.</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> Natalie nodded and looked away. Don't feel too bad for her indeed.
"""
  apply: ->
    super()
    g.people.Kat.add 'happiness', 3

Page.MeetKat3.next['Stolen purse?'] = Page.MeetKatMoney = class MeetKatMoney extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: {}
  text: ->"""|| bg="day"
    #{@Natalie.image 'normal', 'left'}
    -- #{q}Any chance I can get back the other money she stole from me?</q> Natalie took a moment to count the contents of her returned pouch.

  ||
    #{@Guard.image 'normal', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    --> #{q}No.</q> Kat finally spoke, tugging at her blouse. It looked both brand new and none too cheap. One of the shoulders was torn where Natalie had grabbed her. She stared at the rip a moment then started to cry silently. She hicced as the guard cuffed her ear.

  ||
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    -- #{q}Don't feel too bad for her. She and her boyfriend have been terrorizing the market for months. You're just the first fast enough to catch her in the act.</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> Natalie nodded and looked away. Don't feel too bad for her indeed.
"""
  apply: ->
    super()
    g.officers.Nat.add 'diplomacy', 1

Page.MeetKat3.next['Not interested'] = Page.MeetKatNo = class MeetKatNo extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: {}
  text: ->"""|| bg="day"
    #{@Natalie.image 'normal', 'left'}
    -- #{q}No thanks, I have better things to do.</q> She took a moment to count the money in her pouch, steadfastly ignoring the thief as she began to cry. Kat hicced as the guard cuffed her ear, and sobbed silently.

  ||
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    --> #{q}Don't feel too bad for her. She and her boyfriend have been terrorizing the market for months. You're just the first fast enough to catch her in the act.</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> Natalie nodded and looked away. Don't feel too bad for her, indeed.
"""
  apply: ->
    super()
    g.people.Kat.add 'happiness', -3
    g.officers.Nat.add 'business', 2

escapeOptions = [
  "Help her escape (<em><span class='happiness'>+1 happiness</span> for Kat</em>)"
  "Watch and see what happens"
  "Recapture her (<em><span class='happiness'>-1 happiness</span> for Kat</em>)"
]

Job.KatJames = class KatJames extends Job
  label: "Bothering James"
  type: 'plot'
  text: ->"""James feels like he's being watched. Perhaps he'd better have that checked out."""
  energy: 0
  officers:
    James: '|officers|James'

Job.KatTrial::next = Page.KatTrial = class KatTrial extends PlayerOptionPage
  conditions:
    Natalie: {}
    Kat: '|people|Kat'
  text: ->"""|| bg="day|storm"
    -- Natalie arrived early at the courthouse – one of two in Alkenia, and by far the poorest and busiest. This one handled justice for those neither wealthy nor influential enough to arrange trial away from all the noise and bustle.

  ||
    -- She found herself packed in a waiting room with a crowd of supplicants, each waiting their turn before the judge. One could expect no more than fifteen minutes for their complaint heard, case judged, or contract enforced here. Too many waited, or dreaded, their chance at justice for any single case to take long. For someone like Kat, clearly a child of the streets and with eyewitness testimony against her, the "guilty" verdict was a foregone conclusion. The only thing still to be decided was her punishment.

  ||
    #{@Kat.image 'normal', 'far-left'}
    -- #{q}Hey.</q> Someone poked Natalie's back and spoke to her.

  || slow="true"
    #{@Kat.image 'normal', 'left'}
    --> She turned around to see, much to her surprise, Kat herself, rubbing her wrists, ankles bound by iron, looking entirely too pleased with herself for someone soon to face sentencing.

  ||
    #{@Natalie.image 'serious', 'right'}
    --> #{q}What are you doing here? Shouldn't you be watched by a guard, or maybe in a cell?</q>

  ||
    #{@Kat.image 'excited', 'left'}
    -- #{q}I dunno, I guess they got confused or something, forgot about me,</q> Kat responded with a grin, bending down and trying keys one after another on her ankle-manacles. She was pretty, when not crying. Across the crowd, a pair of guards began pushing their way through.

  ||
    #{@Natalie.image 'normal', 'right'}
    --> Natalie couldn't help but laugh at Kat's bravado, running away then stopping to talk, still inside the courthouse, with one of her victims. #{q}Confused, is it?</q>

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Yep. Couldn't keep track of their own helmets if they weren't held on by a strap.</q> She stood up and pressed the ankle-chains and keys into Natalie's hands before she could object. She laughed at the expression it garnered.
      #{options ['Help her', 'Do nothing', 'Hold her'], escapeOptions}
"""
  @next = {}
  effects:
    remove:
      '|location|jobs|katTrial': Job.KatTrial
    add:
      '|location|jobs|katJames': Job.KatJames

Page.KatTrial.next['Help her'] = Page.KatTrialHelp = class KatTrialHelp extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: '|people|AlkeniaGuard'
  text: ->"""|| bg="day|storm"
    #{@Natalie.image 'excited', 'right'}
    -- Natalie laughed again. The girl definitely had spirit. #{q}I'll keep that in mind. I guess I might as well head out now, if there's not going to be a trial.</q>

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Oh, they'll hold the trial even without me.</q> She stood on her toes, peering above the crowd to try and catch a glance of the guards. They were getting uncomfortably close. #{q}Stick around. Let me know what my punishment is to be. What's your name?</q>

  ||
    #{@Natalie.image 'normal', 'right'}
    --> #{q}Natalie. I'll let you know if we see each other again.</q>

  ||
    #{@Kat.image 'excited', 'left'}
    -- #{q}You should be so lucky.</q> Kat's grin widened for a moment, then she returned to her primary task of escape, dodging through the crowd on her way to the exit. Natalie squealed and jumped at the stinging slap on her ass Kat delivered on her way past.

  ||
    #{@Guard.image 'angry', 'far-left'}
    --> #{q}There she is! Stop her!</q> One of the pursuing guards finally made his way close enough to catch sight of Kat ducking through the outside door.

  ||
    #{@Natalie.image 'upset', 'left'}
    -- Natalie "accidentally" backed in front of him as he tried to push past, tangling their legs and bringing both crashing to the ground. #{q}What are you doing, letting her get away? She stole nearly 5 obols from me!</q> She confronted him, hands on hips, raising her voice and stepping in front to prevent him from making any headway.

  ||
    #{@Guard.image 'serious', 'left'}
    --> #{q}Please, Ms, out of the way...</q>

  ||
    #{@Natalie.image 'upset', 'right'}
    --> #{q}Don't 'Ms' me! I want to know how she got out of your hands, much less halfway across the room before you even...</q> By the time he finally escaped her distraction, Kat was long gone.
"""
  apply: ->
    super()
    @context.Kat.add 'happiness', 1

Page.KatTrial.next['Do nothing'] = Page.KatTrialNothing = class KatTrialNothing extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: '|people|AlkeniaGuard'
  text: ->"""|| bg="day|storm"
    #{@Natalie.image 'normal', 'right'}
    -- #{q}How did you even get those keys?</q> Natalie shoved the chains back into Kat's arms, or at least tried to. The thief was too busy grinning, and had no intention of taking them back.

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}I told you, they'd lose their helmets if they could. Well, one forgot his chin strap, so I nicked it, and while he was getting it back from me I grabbed his wallet, and while two of them tried to hold me down I got the keys, and when the whole group piled on, I squirmed out and... been fun, but I gotta run. What's your name?</q>

  ||
    #{@Natalie.image 'normal', 'right'}
    -- #{q}Natalie,</q> she answered reflexively, wondering exactly why she wasn't stopping someone who'd taken money from her, and now expressed no shame at all.

  ||
    #{@Kat.image 'excited', 'left'}
    --> #{q}See you around, Nat.</q> Kat grinned and saluted. She pushed past, on her way to the door. Natalie spun around in time to swat Kat's hand from before it slapped her ass.

  ||
    #{@Guard.image 'angry', 'far-left'}
    --> #{q}There she is! Stop her!</q> One of the pursuing guards finally made their way close enough to catch sight of Kat ducking through the outside door. Natalie just stepped out of the way and watched with a laugh. Somehow she didn't think Kat would get caught again any time soon.
"""

Page.KatTrial.next['Hold her'] = Page.KatTrialHinder = class KatTrialHinder extends Page
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="day|storm"
    #{@Natalie.image 'normal', 'right'}
    -- Natalie decided that, rather than wrestle with her, it might be easier to simply keep her talking. #{q}Neat trick, escaping out of the courthouse right before your hearing. Couldn't pick the lock to your cell?</q>

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Pick locks? No idea how to do that. I just kicked a guard in the shin, knocked his buddy over when he came for me, and high-tailed it out of there.</q> Kat stood on her toes, looking over the heads of the crowd to see how close the guards pushing their way through the crowd were before popping back down to Natalie's level and grinning at her again. #{q}Shouting and kicking doesn't work real well on stone walls.</q>

  ||
    #{@Natalie.image 'normal', 'right'}
    -- #{q}Neat trick. Bet it doesn't work more than once, though. I'm Natalie, by the way.</q> She held out her hand to shake, but perhaps sensing some ill-will, Kat didn't take her hand.

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Nat, is it? Well, it's been fun, but I'll have to see you later.</q> She ducked and tried to push past toward the exit, but Natalie managed to catch her with an arm around her waist. Kat was quick. She reversed her momentum, slamming into Natalie and knocking her off balance and into their neighbors. While her captor tried to regain her balance, another quick shift of weight knocked them together into a closely-packed group of people.

  ||
    --> Natalie tried to keep hold of her, but by the time she extracted herself from the confusion, Kat was already gone.
"""
  apply: ->
    super()
    @context.Kat.add 'happiness', -1

Job.KatJames::next = Page.KatJames = class KatJames extends Page
  conditions:
    James: {}
    Kat: '|people|Kat'
  text: ->"""|| bg="night"
    #{@Kat.image 'excited', 'left'}
    -- #{q}Hiya!</q>

  ||
    #{@James.image 'normal', 'right'}
    --> James turned to find the owner of the hand on his shoulder, a young woman matching his own height. She was scrawny, raggedy, her clothes fraying around the edges. #{q}Hello?</q>

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Hi! I'm Kat, nice to meet you.</q> She grabbed his hand and shook it enthusiastically. #{q}You work with Natalie, right?</q>

  ||
    #{@James.image 'serious', 'right'}
    -- James offered his hand skeptically, making sure to keep a hand on his pocket so nothing could vanish from it. She looked like that sort. #{q}I do. And who are you?</q>

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Oh, we spoke a few days ago, she helped me out a little.</q> Kat kept glancing over her shoulder, looking out for something. #{q}Anyway, I gotta run. They're handing out free blankets at the church this afternoon. What's your name?</q>

  ||
    #{@James.image 'normal', 'right'}
    --> #{q}James Thadel, quartermaster.</q> If Natalie had helped her, she couldn't be that bad.

  ||
    #{@Kat.image 'excited', 'left'}
    -- #{q}Ooh, she's a sailor, then?</q>

  ||
    #{@James.image 'upset', 'right'}
    --> #{q}Captain,</q> James bristled.

  ||
    #{@Kat.image 'normal', 'left'}
    --> #{q}Captain! Wow, a big shot. Anyway, see you later.</q> Kat dodged past him and down an alleyway. She was quick.

  ||
    #{@James.image 'normal', 'right'}
    --> He shook his head, trying to make sense of the conversation, and gave up.
"""
  effects:
    remove:
      '|location|jobs|katJames': Job.KatJames

Place.Alkenia::jobs.katStorm = Job.KatStorm = class KatStorm extends Job
  conditions:
    '|events|KatJames': {matches: (days)-> return days[0] < g.day - 14}
  label: "Kat in the Rain"
  type: 'plot'
  text: ->"""A familiar face in the rain, Kat huddled beneath an awning and looking miserable."""
  energy: -1
  officers:
    Natalie: '|officers|Nat'

Job.KatStorm::next = Page.KatStorm = class KatStorm extends Page
  conditions:
    Natalie: {}
    Kat: '|people|Kat'
  text: ->"""|| bg="marketNight"
  || bg="marketStorm" verySlow="true"
    -- Though the weather had maintained a pleasant tenor all through the day, as the sun set, clouds began to blow in from the horizon. Not a dangerous storm, just a bit of nasty rain to put a damper on Natalie's plans for the evening in town.

    As she hurried back towards the ship, coat pulled close around her, a hint of movement on the mostly deserted street caught her attention. A form, legs pulled up to its chest, half-hidden in the alleyway. There were people living on the street to be sure, but this... Natalie went over for a closer look.

  ||
    -- It was... what was her name again? The thief. She looked absolutely miserable, huddled up in a corner by the side of the street, raggedy blanket more hole than cloth draped over hunched shoulders. Natalie couldn't blame her. Even in a waxed cloak and well-made clothing it was miserable to be outside, much less the scraps she was wearing. Natalie went over, bent against the rain and crouched down next to her.

  ||
    #{@Kat.image 'sad', 'right'}
    --> #{q}Hey, Natalie.</q> The woman eyed her, trying to sound cheerful but lacking the energy. A particularly brutal gust of wind showered them with freezing water. #{q}Don't worry, I'm not going after your purse today.</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    -- #{q}What are you doing out here?</q> She already knew the answer, of course. There was only one reason someone dressed like that and sat outside in a storm.

  ||
    #{@Kat.image 'sad', 'right'}
    --> Kat didn't answer at first, just pulled her legs in closer to her chest. #{q}I wouldn't say no if you dropped your cloak, though.</q> The misery in her voice at asking for something so bluntly cut straight through to Natalie's heart.

  ||
    #{@Natalie.image 'sad', 'left'}
    --> #{q}Nope, no cloak, but come on. Let's get you out of the rain, at least.</q> She reached over and wrapped an arm around Kat's shoulder, pulling her to her feet.

  ||
    #{@Kat.image 'sad', 'right'}
    -- #{q}Where are we going?</q>

  ||
    #{@Natalie.image 'sad', 'left'}
    --> #{q}My ship. Come on, it's not that far. You stay out here you'll die of exposure.</q>

  ||
    #{@Kat.image 'normal', 'right'}
    --> #{q}That would suck,</q> Kat managed a chuckle, declining to rest her weight on Natalie's shoulder and walking on her own. #{q}I've slept in storms before. Killed Don, but I guess I'm made of pretty stern stuff, eh?</q>

  || bg="Ship.deckStorm" slow="true"

  || bg="Ship.cabinStorm" slow="true"
    -- Kat coughed, the motion wracking her whole body. No matter how many blankets Natalie piled over her, her body still shivered while her forehead burned. More than anything else, Nat worried about food. While she'd been scrawny last time they'd met, Kat had seemed little more than a shadow as she'd peeled off soaking clothes and gotten her in Natalie's bed. She'd asked for something to eat, but fallen asleep before it could be brought.

  ||
    --> Natalie felt her forehead again and sat by Kat's side. It was going to be a long night.
"""
  effects:
    remove:
      '|location|jobs|katStorm': Job.KatStorm

Page.KatStorm::next = Page.KatStorm2 = class KatStorm2 extends PlayerOptionPage
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="Ship.cabinDay" verySlow="true"

  || slow="true"
    -- #{q @Kat}You're a very nice lady, you know that?</q> Natalie woke to a hand patting her shoulder. She'd fallen asleep while tending to Kat, and now it seemed her charge had awakened first.

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}What do you mean?</q>

  ||
    --> #{q @Kat}You brought me here and took care of me.</q> Kat didn't rise, stayed laying on the bed with the blankets covering her.

  ||
    #{@Natalie.image 'normal', 'left'}
    -- #{q}Anyone would do that.</q> Natalie covered the hand on her shoulder with own.

  ||
    --> #{q @Kat}Not anyone. Two people. You and Don. No one else ever did. Can I get some of that milk?</q> She gestured weakly to the small jar of cream at the bedside. Someone, probably James, had left it there before she woke, along with a now cool cup of tea and a biscuit.

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}That's cream. You don't want to drink it. Here, have a biscuit instead. Want tea?</q>

  ||
    #{@Kat.image 'normal', 'right'}
    -- #{q}I sucked on a Maiden's Tea leaf once. Pretty nasty. Biscuit sounds good though.</q> She waited for Natalie to fetch it for her. Finally biting into the biscuit, she chewed thoughtfully, her face growing into a smile. She slowly levered herself into a sitting position. #{q}It's good. Always knew you were a big-shot. It's a nice cabin.</q>

  ||
    #{@Natalie.image 'blush', 'left'}
    --> #{q}Thanks. It's not anything like that. I just have some talents The Guild finds useful.</q>

  ||
    #{@Kat.image 'normal', 'right'}
    --> #{q}A Vailian Guildswoman, eh? A woman of many talents. So, what do you want with the likes of me? Going to turn me in to the guard for the time I took your money?</q>

  ||
    #{@Natalie.image 'upset', 'left'}
    -- #{q}What? No! I saw you dieing by the side of the road and decided to do something about it. That's all.</q> Natalie felt as though she should be indignant, but really, how many times had she walked past someone in exactly the same situation? Too many.
    #{options ['Offer gift', 'Set up in city', 'Offer job'], ["<em>+2 happiness for Kat</em>", "<em>Kat joins the crew</em>"]}
"""
  @next: {}

Page.KatStorm2.next['Offer gift'] = Page.KatStormGift = class KatStormGift extends PlayerOptionPage
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="Ship.cabinDay"
    #{@Natalie.image 'normal', 'left'}
   -- #{q}Look, you seemed to be doing well before you met me and, while I can't approve of pickpocketing as a living, I do feel pretty bad about what happened afterwards. What would you do with 20b?</q>

  ||
    #{@Kat.image 'excited', 'right'}
    -- That definitely caught Kat's attention. She considered a moment, then answered. #{q}Well, I'd start with some new clothes. Then something to eat, of course. I always wanted to try one of those spiced meat pies in the market, but that cook has eyes like a hawk and I never could snatch one. Then a place to stay. A couple tenths a night gets me a nice place by the fire down in the slums...</q>

  ||
    #{@Natalie.image 'serious', 'left'}
    --> Natalie listened with growing dismay. No sense of planning, of saving, of building a plan for the future. Whatever Kat needed, it wasn't a gift, no matter how generous.
    #{options ['Set up in city', 'Offer job'], ["<em>+2 happiness for Kat</em>", "<em>Kat joins the crew</em>"]}
"""
  @next: {}

Job.KatVisit = class KatVisit extends Job
  conditions:
    '|events|KatStorm': {matches: (days)-> return days[0] < g.day - 7}
    '|events|KatVisit':
      optional: true
      matches: (days)-> return not days or days[0] < g.day - 10
    '|weather': {eq: 'calm'}
  label: "Visit Kat"
  type: 'plot'
  text: ->"""Time to pay a visit to your favorite thief friend, see how she's doing in her new job as a respectable member of society."""
  energy: -1
  officers:
    Natalie: '|officers|Nat'


Page.KatStorm2.next['Set up in city'] = Page.KatStormGift.next['Set up in city'] = Page.KatStormCity = class KatStormCity extends Page
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="Ship.cabinDay"
    #{@Natalie.image 'normal', 'left'}
    -- #{q}I know some people who might want some help, if you're interested.</q> Natalie wondered briefly who would accept a known pickpocket street-person into their employ, even one as irrepressible as Kat seemed to be, still joking around even with pneumonia.

  ||
    #{@Kat.image 'normal', 'right'}
    --> #{q}I'm not going to be a whore, Guildswoman.</q> Kat shook her head without anger. #{q}I'm not expensive, and I've seen what happens to cheap ones. I'd rather still be in the gutter.</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}I don't mean whoring. There's desk work and the like,</q> though such an objection did rule out 2/3rds of the possibilities Natalie had thought of suggesting. #{q}There are plenty of other jobs. Can you use a mop?</q>

  ||
    #{@Kat.image 'normal', 'right'}
    -- #{q}Dunno. Never tried.</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}I suppose it's a better answer than 'no.'</q> Natalie laughed, drawing a smile from Kat as well. Despite nearly freezing to death, her mood didn't seem much affected. #{q}Let me ask around a bit today and see what I can arrange.</q>

  ||
    --> <em><span class="happiness">+2 happiness</span> for Kat</em>
"""
  apply: ->
    super()
    @context.Kat.add('happiness', 2)
  effects:
    add:
      '|location|jobs|katVisit': Job.KatVisit

Page.KatStorm2.next['Offer job'] = Page.KatStormGift.next['Offer job'] = Page.KatStormJob = class KatStormJob extends Page
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="Ship.cabinDay"
    #{@Natalie.image 'normal', 'left'}
    -- #{q}Maybe we can help each other out. I'm always looking for more crew members, and you might do well.</q>

  ||
    #{@Kat.image 'excited', 'right'}
    --> Kat laughed. #{q}I've never set foot on a ship before in my life.</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}But you've got a knack for turning people to your side. Just look at me. I must be crazy to be thinking about hiring you, but here I am.</q>

  ||
    #{@Kat.image 'normal', 'right'}
    --> #{q}Accepted.</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    -- #{q}Besides, it's... um... that's good. No time to consider it? You haven't even heard the pay yet.</q>

  ||
    #{@Kat.image 'excited', 'right'}
    --> #{q}I'd get paid?</q> Kat sounded entirely too excited at that prospect, as though getting money for her labor hadn't even crossed her mind. #{q}How much?</q> Another cough wracked her body, and Natalie patted her shoulder.

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}Rest more. We'll talk tomorrow.</q>
"""
  apply: ->
    super()
    g.officers.Kat = g.people.Kat

hireText = "Maybe she'd like to try something more exciting? Like sailing with Natalie"
Job.KatVisit::next = Page.KatVisit = class KatVisit extends PlayerOptionPage
  conditions:
    Natalie: {}
    Kat: '|people|Kat'
  text: ->"""  || bg="marketDay"
    #{@Kat.image 'normal', 'right'}
    -- #{q}Get me out of here.</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    --> Natalie nearly jumped out of her skin at the sudden whisper right in her ear and the weight hanging off her shoulders. She reached up, pried Kat off her back, and turned to face her. #{q}Hey, Kat. I just came by to...</q>

  ||
    #{@Kat.image 'normal', 'right'}
    --> #{q}Save me, Nat, save me from the eternal repetitive workday, repetitive and boring and how do people stand having jobs?</q> Kat didn't look nearly as skeletal as she had last time they spoke, but there was a glimmer in her eyes suggesting an unhealthy level of stir-craziness. #{q}Repetitive. Boring. Did I mention it's...</q>

  ||
    #{@Natalie.image 'normal', 'left'}
    -- #{q}Repetitive. Yes, you did mention it. I take it being a maid isn't to your taste?</q>

  ||
    #{@Kat.image 'normal', 'right'}
    --> Kat spun around, swinging her broom as though it were a dance partner. #{q}Oh, no, I love sweeping! And mopping, that's the best, all grimy and disgusting. Do you know what three day old cum smells like? I know what three day old cum smells like.</q> She gestured upwards, tapping the roof with the broom handle.

  ||
    #{@Natalie.image 'normal', 'left'}
    --> #{q}Hey, it's better than being on the streets, isn't it?</q>

  ||
    #{@Kat.image 'excited', 'reversed'}
    -- #{q}I don't know! I thought it was, during Water, but then I noticed a laundry place I hadn't seen before, with a pretty good crawlspace I could hide in, and I got to thinking that maybe it wasn't so bad after all. But I am so glad to see you! You're not boring.</q>
    #{if g.events.KatVisit.length is 1 then options(['Spend time together', 'Hire her'], ["<em><span class='happiness'>+2 happiness</span> for Kat, Natalie</em>", hireText]) else options(['Hire her'], [hireText])}
"""
  @next: {}

Page.KatVisit.next['Spend time together'] = Page.KatVisitTime = class KatVisitTime extends Page
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="marketDay"
    #{@Natalie.image 'blush', 'left'}
    -- #{q}I suppose it's nice to be appreciated. But anyway, I just thought I'd drop by, see how you were doing.</q>

  ||
    #{@Kat.image 'excited', ''}
    --> #{q}And you've seen how I'm doing. I'm doing great! And going crazy, too, but, you know.</q>

  ||
    #{@Natalie.image 'excited', 'left'}
    --> Natalie laughed at the display, and poked Kat's forehead. #{q}We are going to get you out of here, then, at least for the rest of the day.</q>

  ||
    #{@Kat.image 'excited', 'right'}
    -- Kat poked back with the broom handle, in the shoulder. Natalie made a grab for it, but her hands caught only empty air, and she received a rap on the hip for her trouble. Feinting after the broom again, instead Nat lunged forward, wrapping her arms around Kat's waist and lifting, tossing the giggling girl over one shoulder like a sack of potatoes.

  ||
    #{@Natalie.image 'excited', ''}
    --> #{q}I'm borrowing her for a bit, if you don't mind?</q> Natalie slapped Kat's rump, addressing her comment to the other maid, a forty something man who shrugged his shoulders – not his job to make sure she worked. Kat giggled more and kicked her feet as Nat carried her away.

  || bg="day"
    -- It was good to spend some time away from the cares and responsibilities of captaining, and Kat certainly seemed to enjoy herself as well. They ate lunch together, wandered the city streets, built a pyramid out of bricks and ran away when the owner of said bricks tried to scold them. A good day all around.

  ||
    --> <em><span class="happiness">+2 happiness</span> for Kat and Natalie</em>
"""
  apply: ->
    super()
    @context.Kat.add 'happiness', 2
    @context.Natalie.add 'happiness', 2

Page.KatVisit.next['Hire her'] = Page.KatVisitHire = class KatVisitHire extends Page
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""|| bg="day"
    #{@Natalie.image 'normal', 'left'}
    -- #{q}Well, that's good. I suppose I don't need to remain in suspense, asking if you'd like to join my crew, then?</q>

  ||
    #{@Kat.image 'excited', ''}
    --> She was nearly bowled over as Kat leapt into her arms, an excited sound and a fierce hug, legs wrapping around her waist. Natalie staggered back, trying to catch her balance, bumping against a wall. Kat kissed her, right on the mouth, then unwrapped her legs and detached herself again. Natalie laughed at the girl's sudden false-decorum as she wiped dust off her shirt and spoke formally. #{q}Why yes, Captain Natalie, I would be pleased to sign on.</q> It didn't last. She broke back into a grin.

  ||
    #{@Natalie.image 'serious', 'left'}
    -- #{q}It's hard work, you know. Messing around is fine, but on the ship I brook no laziness.</q>

  ||
    #{@Kat.image 'excited', 'right'}
    --> #{q}Hey, don't worry about it. I kept this shitty job, didn't I? How much worse can it be?</q>
"""
  apply: ->
    super()
    g.officers.Kat = @context.Kat
  effects:
    remove:
      '|location|jobs|katVisit': Job.KatVisit

ShipJob.KatClothes = class KatClothes extends ShipJob # TODO: Include back in game
  label: "Talk with James"
  type: 'plot'
  text: ->"""James has been avoiding Natalie. Something is bothering him. They should talk."""
  conditions:
    '|doesnt|exist': {}
    '|events|GuildKatEasy': {}
    '|events|KatStealClothes': # If it's happened before, must be at least three months ago.
      matches: (days)->
        if not days then return true
        return days[0] + 90 < g.day and days.length < 2
      optional: true

response = [
  'Kat needs some discouraging to stop her pulling this crap. <span class="happiness">-2 happiness</span> for Kat, <span class="happiness">+4</span> for James'
  'Stride out on deck with a grin and confront her. <span class="happiness">-2 happiness</span> for James, <span class="happiness">+4</span> for Kat'
]

ShipJob.KatClothes::next = Page.KatClothes = class KatClothes extends PlayerOptionPage
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.cabinNight"
    -- ...

  || bg="Ship.cabinDay"
    -- Natalie blinked at the empty chest. It was empty. There should have been underwear in there. With slowly increasing worry, she wandered over to the closet - also empty. There should have been clothes in there. Her desk was untouched - map, navigation tools, even a couple of coins she'd left sitting out, all still in place. Whatever mysterious force had taken all her clothing while she slept, clothing had been its only goal.

  ||
    #{@Nat.image 'serious-nude', 'center'}
    -- She snorted. "Mysterious force," right. Kat's antics were occasionally annoying, but never mysterious. The only mysterious part was how she'd managed to empty the entire closet without either waking Natalie or getting stopped by any of the crew.
    #{options ['Angry', 'Laughing'], }
  """
  @next: {}

Page.KatClothes.next.Angry = Page.KatClothesAngry = class KatClothesAngry extends Page
  conditions:
    Kat: '|officers|Kat'
    James: '|officers|James'
    Nat: {}
    crew:
      fill: -> Math.choice g.crew
  text: ->"""|| bg="Ship.cabinDay"
    #{Nat.image 'angry-nude', 'center'}
    -- #{q}James! Find Kat, bring her here, now!</q> Natalie opened her door just a sliver and poked her head out, shouting for someone who should have been on duty. No immediate answer, then... a shuffling sound, and #{crew} came into view, clutching a board to mostly cover #{his} private parts.

  ||
    --> #{q @crew}Sorry, captain, someone stole most of the crew's clothes during the night. I don't think James will be coming out of his room.</q>

  || bg="Ship.deckDay"
    #{Nat.image 'normal-nude', 'center'}
    -- #{q}This is getting ridiculous. Who had watch last night? They had to have been helping her.</q> Natalie threw the door open and strode on deck. Despite the absurdity of the situation, Natalie had to admire Kat's bravado. Hiding every scrap of clothing on the ship was no mean feat. #{q @Nat}Lots of people have seen me naked, what's a few more?</q> She grinned at the stunned sailor to reassure #{him @crew} that her brazen nudity didn't reflect poorly on him.

  ||
    ...

  || bg="Ship.cabinDay'
    #{Kat.image 'nude-excited', 'right'}

  ||
    #{Kat.image 'nude normal', 'right'}

  ||
    #{Kat.image 'nude-sad', 'right'}

  ||
    #{Kat.image 'nude-sad', 'right'}
    -- #{q}...sorry. Don't be too mad, please Nat?</q>

  ||
    #{Nat.image 'upset-nude', 'left'}
    ...

  ||
    #{Kat.image 'nude-sad', 'right'}
    -- #{q}...sorry.</q>

  ||
    --> <span class="happiness">-2 happiness</span> for Kat, <span class="happiness">+4</span> for James
  """
  apply: ->
    super()
    @context.Kat.add 'happiness', -2
    @context.James.add 'happiness', 4

Page.KatClothes.next.Laughing = Page.KatClothesLaughing = class KatClothesLaughing extends Page
  conditions:
    Kat: '|officers|Kat'
    Nat: {}
    crew:
      fill: -> Math.choice g.crew
  text: ->"""|| bg="Ship.cabinDay"
    #{@Nat.image 'normal-nude', 'center'}
    -- Natalie cracked the door to poke her head out, and, to her surprise, saw #{crew} standing on deck, an unhappy hunch to #{his} shoulders. Also, #{he} was completely naked. Natalie threw her door wide open and strode out on deck.

  || bg="Ship.deckDay"
    #{@Nat.image 'normal-nude', 'left'}
    --> #{q}Report,</q> she demanded, causing #{crew} to jump and spin, then blush furiously and try to cover #{his} crotch. #{q @Nat}Why are you naked, sailor?</q> Natalie grinned, and as #{crew} stammered for a response, took pity. #{q}Don't worry. I know. You have to admire her bravado, don't you? Taking just the captains clothing was brazen enough, but I never imagined she'd go for <i>everyone.</i></q>

  ||
    -- {#q @crew}Kat's barricaded herself in the cargo hold.</q>

  ||
    --> #{q @Nat}Oh, has she now? Well, we'll see about that. Cover your ears.</q>

  ||
    #{@Nat.image 'angry-nude', 'center'}
    -- #{q}ALL HANDS ON DECK!</q> Natalie's shout was ear-shatteringly loud. Cursing and thudding from below decks as sailors scrambled to obey, arriving hodge-podge and covering themselves in a motly collection of blankets, hands, and various personal belongings.

  ||
    --> #{q}KAT! Get your ass out here or I will THROW YOU OVER THE RAILING!</q>

  ||
    -- It took a moment, but that finally produced the desired effect, some scraping and moving sounds, followed by a nervous Kat emerging from below-deck, fully clothed. She looked torn between grinning and being terrified, eyes darting back and forth between everyone present, trying to gauge moods.

  ||
    #{@Nat.image 'normal', 'far-right'}
    #{@Kat.image 'normal', 'right'}
    --> Natalie took her by the shoulders and steered her by them, until she stood facing the entire crew. She kept her hands firmly on Kat's shoulders, brooking no argument or evasion. One clothed person, facing down #{(g.crew.objectLength + g.officers.objectLength - 2).toWord()} naked ones, ranging from upset to amused to, in the case of James, hiding all the way in the back and completely mortified.

  ||
    #{@Nat.image 'normal', 'far-right'}
    #{@Kat.image 'normal', 'right'}
    -- #{q @Nat}Now, as you are all doubtless aware, last night someone stole all your clothing. Go get dressed, and gather back here in a few minutes for Kat's punishment. Kat, you stay right here. Don't move an inch.</q>

  ||
    --> A few minutes later, the crew was gathered back together, noticeably happier and significantly less chilly. Except Natalie. She'd gathered only a long overcoat, leaving it unbelted. Flashes of her breasts were visible as she moved, and plenty of unbroken pink flesh left any doubt she was naked underneath.

  ||
    -- #{q}Kat! Punishment time. Undress, now.</q> Natalie grinned at Kat's shocked expression. #{q}What, exactly, did you think would happen? Now, clothes off.</q>

  ||
    #{@Kat.image 'blush-nude', 'far-right'}
    --> Slowly, the thief complied. Though James looked away, refusing to make eye contact with either woman, plenty of the crew took their chance to gather an eye full. Finally, Kat stood back up, the scene reversed from earlier - one naked woman alone, with everyone else dressed.

  ||
    -- #{q}Now, scrub the deck, stem to stern. I'll be taking those.</q> Natalie bent down to scoop Kat's clothing off the deck. #{q}No clothes for you until you've finished. Yes,</q> she quirked an eyebrow at Kat's dismayed look, #{q}that'll take at least two days. Naked. Put on even a scrap and I'll make you do something worse. Now, hands and knees. You've got work to do.</q>

  ||
    -- Natalie turned, her jacket flashing open with the motion. #{q @crew}Are you going to... um... get dressed, captain?</q>

  ||
    --> #{q}Nah, I'm enjoying the breeze. Besides, it's kind of hot out here, don't you think?</q> She gently shoved Kat's rump with one bare foot, eliciting a squeal of indignation and flashing her pussy to the world. #{q}Actually, you can have shoes. Punishment is one thing, splinters are another. No socks though. Your ankles are too sexy to cover up.</q>

  ||
    --> <span class="happiness">-2 happiness</span> for James, <span class="happiness">+4</span> for Kat
  """
  apply: ->
    super()
    @context.James.add 'happiness', -2
    @context.Kat.add 'happiness', 4
