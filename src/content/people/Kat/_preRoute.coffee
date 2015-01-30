Place.Alkenia::jobs.meetKat = Job.MeetKat = class MeetKat extends Job
  label: "Pickpocket"
  type: 'plot'
  text: ->"""Someone running through the crowd, a merchant shaking their head and looking appologetic... wait, where's Natalie's purse?#{if g.events.MeetKat then "" else " <em>-35β</em>"}"""
  energy: -1
  officers:
    Natalie: '|officers|Nat'
  conditions:
    '|weather': {eq: 'calm'}
    '|events|AlkeniaMarket|length': {gte: 1}
    '|officers|Nat|money': {gte: 35}
    '|events|MeetKat': # If it's happened before, must be at least a week ago.
      matches: (days)-> if days then days[0] + 7 < g.day else true
      optional: true
  next: Page.firstNew
  @next = []

Job.MeetKat.next.push Page.MeetKat2 = class MeetKat2 extends Page
  conditions:
    Natalie: {}
  text: ->"""<page bg="#{g.location.images.day}">
    <text><p>Alkenia's market was a crowded place, stalls buying and selling almost every imaginable good - though, Natalie noted, the prices were often rather inflated compared to what one would pay in Vailia itself. She had never before had enough money to even consider most of the items on sale – or at least not had the intention to spend that much money, since she was too busy saving up for her grand adventure. Now, though... now she could sample whatever she liked, and call it a business expense. A merchant had to know what exactly they were selling, after all!</p></text>
  </page>
  <page>
    <text><p>The aroma of a spice rack drew her irresistibly towards it. Most of the scents she could at least identify, but not one that stood out.</p></text>
  </page>
  <page>
    <text continue><p><q>Sin-namon. You're smelling sin-namon,</q> the merchant smiled at her twitching nose. <q>Special import. I hear tell it comes from beyond Kantis, north and east so far I didn't even recognize the name of the place. Amazing, isn't it?</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'normal', 'left'}
    <text continue><p>Natalie leaned close to the jar – it had a perforated top and sat over a candle to spread the smell as far as possible. A dirty trick, but effective advertising none the less. #{q}It does smell marvelous. What is it?</q></p></text>
  </page>
  <page>
    <text><p>#{q}Tree bark, boil it or grind it up. 10 obols an ounce, but a little goes a long way. Limited supplies,</q> he gestured to a single, half empty crate behind him.</p></text>
  </page>
  <page>
    <text continue><p>Natalie whistled at that. Truly it must come from halfway around the world to warrant that price – or he was a con artist, a splendid one. The smell though - she'd never scented anything like it in her life, nor heard of it. A cargo hold full of that and she'd be set for life. #{q}Interesting. Does it taste like it smells? I might consider...</q></p></text>
  </page>
  <page>
    <text><p>A flash of movement caught her eye, and a sudden feeling of a breeze. She patted her pocket, and found no bundle of coins. She spun on her heels, catching another flash of motion – a young woman, disappearing into the crowd.</p></text>
  </page>
  <page>
    #{@Natalie.image 'upset', 'left'}
    <text continue><p>#{q}Pickpocket!</q> Natalie shouted. Heads turned, a path cleared, but too late. The girl was gone, lost somewhere in the crowd.</p></text>
  </page>
  <page>
    #{@Natalie.image 'serious', 'left'}
    <text continue><p>Natalie stopped, shook her head in dismay, assessed the situation. It wasn't all that much money, all told, but still... she shook her head. She was getting careless, to let someone lift off her.</p></text>
  </page>"""

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
  text: ->"""<page bg="#{g.location.images.day}">
    #{@Natalie.image 'normal', 'left'}
    <text><p>Wandering the market, enjoying the scene, looking for new and exotic items, Natalie was enjoying her afternoon. A slight breeze, a feeling of lightness, a...</p></text>
  </page>
  <page>
    #{@Natalie.image 'excited', 'left'}
    <text continue><p>#{q}Not this time, thief,</q> Natalie's hand closed around a wrist, fumbled as it tried to pull away, then gripped tightly.</p></text>
  </page>
  <page>
    #{@Natalie.image 'angry', 'left'}
    <text><p>She managed to catch the young woman in the side of the head with a fist. The blow dazed her, and Natalie took the opportunity to wrap an arm around her neck, bending her over and holding her firmly in place. Natalie wasn't the strongest woman, but compared to her, the pickpocket might as well have been a feather.</p></text>
  </page>
  <page>
    #{@Kat.image 'upset', 'right'}
    <text continue><p>A feather that fought dirty. She stomped on Natalie's toes (mildly effective through thick ship-boots), then elbowed her in the stomach (quite effective through a thin shirt), and shoved her way free in the sudden confusion.</p></text>
  </page>
  <page>
    #{@Kat.image 'serious', 'right'}
    <text><p>She made a quick run for it... straight into the stomach of a burly guard, who held onto the tiny woman with somewhat more success despite her struggles.</p></text>
  </page>
  <page>
    #{@Natalie.image 'upset', 'left'}
    <text continue><p>#{q}She was... oof... taking my money,</q> Natalie gasped out, leaning on one arm against a nearby stone wall. #{q}Wasn't expecting a fight.</q></p></text>
  </page>
  <page>
    #{@Guard.image 'serious', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    <text continue><p>The girl became still, quickly realizing the futility of further escape attempts. She was younger than Natalie, probably, and though taller, skinny enough to shame a pole. Little more than skin and bones, really, with big, soulful eyes that made Natalie want to give her a hug.</p></text>
  </page>
  <page>
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'serious', 'far-right'}
    <text><p>The guard shook the woman's bag. It rattled with the sound of silverware. <q>If I talk to the woman selling these, am I going to find they were bought properly, Kat?</q> He seemed to know her, and the exasperated tone of his voice suggested this was not the first such incident. <q>Is she going to be able to tell me what's in your bag better than you can?</q></p></text>
  </page>
  <page>
    #{@Guard.image 'serious', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    <text continue><p>"Kat" didn't say anything, just shuffled her feet and hung her head. It looked like she was going to start crying any moment.</p></text>
  </page>
  <page>
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'serious', 'far-right'}
    <text><p><q>I'm sorry for the trouble, miss,</q> he addressed Natalie, tightening his hold on the thief's arm even more until Natalie winced in sympathy.</p></text>
  </page>
  <page>
    #{@Natalie.image 'normal', 'left'}
    <text continue><p>#{q}Not at all. thank you for catching her. 18β in mixed coinage, primarily Valian silver, if I may,</q> she gestured to her purse laying on the ground where Kat had dropped it during the struggle. The guard nodded, not bothering to check the exact contents and verify that they matched Natalie's description.</p></text>
  </page>
  <page>
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    <text><p><q>If you're interested, I suspect the judge has finally had enough of her shenanigans,</q> he shook the captive waif by the shoulder. <q>There should be a trial in a week or so.</q></p>
    #{options ['Sure', 'Stolen purse?', 'Not interested'], katOptions}</text>
  </page>"""
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
  text: ->"""<page bg="#{g.location.images.day}">
    #{@Natalie.image 'normal', 'left'}
    <text><p>#{q}I'll be there.</q> Natalie took a moment to count the money in her pouch.</p></text>
  </page>
  <page>
    #{@Guard.image 'normal', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    <text continue><p>Kat started to cry silently, hiccing as the guard cuffed her ear. She aimed a dispirited kick at his shin, but he didn't much seem to notice through heavy leggings.</p></text>
  </page>
  <page>
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    <text><p>#{q}Don't feel too bad for her – she and her boyfriend have been terrorizing the market for months. You're just the first fast enough to catch her in the act.</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'sad', 'left'}
    <text continue><p>Natalie nodded and looked away. Don't feel too bad for her indeed.</p></text>
  </page>"""
  apply: ->
    super()
    g.people.Kat.add 'happiness', 3

Page.MeetKat3.next['Stolen purse?'] = Page.MeetKatMoney = class MeetKatMoney extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: {}
  text: ->"""<page bg="#{g.location.images.day}">
    #{@Natalie.image 'normal', 'left'}
    <text><p>#{q}Any chance I can get the other money she stole back?</q> Natalie took a moment to count the contents of her returned pouch.</p></text>
  </page>
  <page>
    #{@Guard.image 'normal', 'far-right'}
    #{@Kat.image 'sad', 'right'}
    <text continue><p>#{q}No,</q> Kat, finally spoke, tugging at her blouse. It looked both brand new and none too cheap. One of the shoulders was torn where Natalie had grabbed her. She stared at the rip a moment then started to cry silently. She hicced as the guard cuffed her ear.</p></text>
  </page>
  <page>
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    <text><p>#{q}Don't feel too bad for her – she and her boyfriend have been terrorizing the market for months. You're just the first fast enough to catch her in the act.</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'sad', 'left'}
    <text continue><p>Natalie nodded and looked away. Don't feel too bad for her indeed.</p></text>
  </page>"""
  apply: ->
    super()
    g.officers.Nat.add 'diplomacy', 1

Page.MeetKat3.next['Not interested'] = Page.MeetKatNo = class MeetKatNo extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: {}
  text: ->"""<page bg="#{g.location.images.day}">
    #{@Natalie.image 'normal', 'left'}
    <text><p>#{q}No thanks, I have better things to do.</q> She took a moment to count the money in her pouch, steadfastly ignoring her as the thief began to cry. Kat hicced as the guard cuffed her ear, and sobbed silently.</p></text>
  </page>
  <page>
    #{@Kat.image 'sad', 'right'}
    #{@Guard.image 'normal', 'far-right'}
    <text continue><p>#{q}Don't feel too bad for her – she and her boyfriend have been terrorizing the market for months. You're just the first fast enough to catch her in the act.</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'sad', 'left'}
    <text continue><p>Natalie nodded and looked away. Don't feel too bad for her indeed.</p></text>
  </page>"""
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
  text: ->"""<page bg="#{if g.weather is 'calm' then g.location.images.day else g.location.images.storm}">
    <text><p>Natalie arrived somewhat early to the courthouse – one of two in Alkenia, and by far the poorest and busiest. This one handled justice for those neither wealthy nor influential enough to arrange trial away from all the noise and bustle.</p></text>
  </page>
  <page>
    <text><p>She found herself packed in a waiting room with a crowd of supplicants to the court, each waiting their turn before the judge. One could expect no more than fifteen minutes to have their complaint heard, case judged, or contract enforced here – too many waited (or dreaded) for their chance at justice for any single case to take up time. For someone like Kat, clearly a child of the streets and with eyewitness testimony against her, the "guilty" verdict was a foregone conclusion – the only thing still to be decided was her punishment.</p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'far-left'}
    <text><p>#{q}Hey.</q> Someone poked Natalie's back and spoke to her.</p></text>
  </page>
  <page slow>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>She turned around to see, much to her surprise, Kat herself, rubbing her wrists, ankles bound by iron, looking entirely too pleased with herself for someone soon to face sentencing.</p></text>
  </page>
  <page>
    #{@Natalie.image 'serious', 'right'}
    <text continue><p>#{q}What are you doing here? Shouldn't you be watched by a guard, or maybe in a cell?</q></p></text>
  </page>
  <page>
    #{@Kat.image 'excited', 'left'}
    <text><p>#{q}I dunno, I guess they got confused or something, forgot about me,</q> Kat responded with a grin, bending down and trying keys one after another on her ankle-manacles. She was rather pretty, when not crying. On the other side of the crowd, a pair of guards began pushing their way through.</p></text>
  </page>
  <page>
    #{@Natalie.image 'normal', 'right'}
    <text continue><p>Natalie couldn't help but laugh at Kat's bravado, running away then stopping to talk, still inside the courthouse, with one of her victims. #{q}Confused, is it?</q></p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Yep. Couldn't keep track of their own helmets if they weren't held on by a strap,</q> she stood up again, and pressed the ankle-chains and keys into Natalie's hands before she could object. She laughed at the expression it garnered.</p>
    #{options ['Help her', 'Do nothing', 'Hold her'], escapeOptions}</text>
  </page>"""
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
  text: ->"""<page bg="#{if g.weather is 'calm' then g.location.images.day else g.location.images.storm}">
    #{@Natalie.image 'excited', 'right'}
    <text><p>Natalie laughed again – the girl definitely had spirit. #{q}I'll keep that in mind. Guess I might as well head out now, if there's not going to be a trial.</q></p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Oh, they'll hold the trial just fine even without me.</q> She stood on her toes, peering above the crowd to try and catch a glance at the guards. They were getting uncomfortably close. #{q}Stick around, let me know what my punishment is to be. What's your name?</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'normal', 'right'}
    <text continue><p>#{q}Natalie. I'll let you know if we see each other again.</q></p></text>
  </page>
  <page>
    #{@Kat.image 'excited', 'left'}
    <text><p>#{q}You should be so lucky,</q> Kat's grin widened for a moment, then she returned to her primary task of escape, dodging through the crowd on her way to the exit. Natalie squealed and jumped at the stinging slap on her ass Kat delivered on her way past.</p></text>
  </page>
  <page>
    #{@Guard.image 'angry', 'far-left'}
    <text continue><p>#{q}There she is! Stop her!</q> One of the pursuing guards finally made their way close enough to catch sight of Kat ducking through the outside door.</p></text>
  </page>
  <page>
    #{@Natalie.image 'upset', 'left'}
    <text><p>Natalie "accidentally" backed in front of him as he tried to push past, tangling their legs and bringing both crashing to the ground. #{q}What are you doing, letting her get away? She stole nearly 5 obols from me!</q> she confronted him, hands on hips, raising her voice and stepping in front to prevent him from making any headway.</p></text>
  </page>
  <page>
    #{@Guard.image 'serious', 'left'}
    <text continue><p>#{q}Please Ms, out of the way...</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'upset', 'right'}
    <text continue><p>#{q}Don't 'Ms' me, I want to know how she got out of your hands, much less halfway across the room before you even...</q> By the time he finally escaped her distraction, Kat was long gone.</p></text>
  </page>"""
  apply: ->
    super()
    @context.Kat.add 'happiness', 1

Page.KatTrial.next['Do nothing'] = Page.KatTrialNothing = class KatTrialNothing extends Page
  conditions:
    Natalie: {}
    Kat: {}
    Guard: '|people|AlkeniaGuard'
  text: ->"""<page bg="#{if g.weather is 'calm' then g.location.images.day else g.location.images.storm}">
    #{@Natalie.image 'normal', 'right'}
    <text><p>#{q}How did you even get those keys,</q> Natalie shoved the chains back into Kat's arms, or at least tried to. The thief was too busy grinning, and had no intention of taking them back.</p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}I told you, they'd lose their helmets if they could. Well, one forgot his chin strap, so I nicked it, and while he was getting it back from me I grabbed his wallet, and while two of them tried to hold me down I got the keys, and then when the whole group piled on, I squirmed out and... been fun, but I gotta run. What's your name?</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'normal', 'right'}
    <text><p>#{q}Natalie,</q> she answered reflexively, wondering exactly why she wasn't stopping someone who'd taken money from her, and now expressed no shame at all.</p></text>
  </page>
  <page>
    #{@Kat.image 'excited', 'left'}
    <text continue><p>#{q}See you around, Nat,</q> Kat grinned and saluted. She pushed past, on her way to the door, and Natalie spun around in time to swat away Kat's hand from slapping her ass.</p></text>
  </page>
  <page>
    #{@Guard.image 'angry', 'far-left'}
    <text continue><p>#{q}There she is! Stop her!</q> One of the pursuing guards finally made their way close enough to catch sight of Kat ducking through the outside door. Natalie just stepped out of the way and watched with a laugh – somehow she didn't think Kat would get caught again any time soon.</p></text>
  </page>"""

Page.KatTrial.next['Hold her'] = Page.KatTrialHinder = class KatTrialHinder extends Page
  conditions:
    Natalie: {}
    Kat: {}
  text: ->"""<page bg="#{if g.weather is 'calm' then g.location.images.day else g.location.images.storm}">
    #{@Natalie.image 'normal', 'right'}
    <text><p>Natalie decided that, rather than wrestle with her, it might be easier to simply keep her talking. #{q}Neat trick, escaping out of the courthouse right before your hearing. Couldn't pick the lock to your cell?</q></p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Pick locks? No idea how to do that. I just kicked a guard in the shin, knocked his buddy over when he came for me, and high-tailed it out of there.</q> Kat stood on her toes, looking over the heads of the rest of the crowd to see how close the guards pushing their way through the crowd were before popping back down to Natalie's level and grinning at her again. #{q}Shouting and kicking doesn't work real well on stone walls.</q></p></text>
  </page>
  <page>
    #{@Natalie.image 'normal', 'right'}
    <text><p>#{q}Neat trick. Bet it doesn't work more than once, though. I'm Natalie, by the way.</q> She held out her hand to shake, but perhaps sensing some ill-will, Kat didn't take her hand.</p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Nat, is it? Well, it's been fun, but I'll have to see you later.</q></p></text>
  </page>
  <page>
    #{@Kat.image 'upset', 'left'}
    <text continue-inline> She ducked and tried to push past toward the exit, but Natalie managed to catch her with an arm around her waist. Kat was quick – she reversed her momentum, slamming into Natalie and knocking her off balance and into their neighbors. While her captor tried to regain her balance, another quick shift of weight and she knocked them together into another closely-packed group of people.</text>
  </page>
  <page>
    <text continue><p>Natalie tried to keep hold of her, but by the time she extracted herself from the confusion, Kat was already gone.</p></text>
  </page>"""
  apply: ->
    super()
    @context.Kat.add 'happiness', -1

Job.KatJames::next = Page.KatJames = class KatJames extends Page
  conditions:
    James: {}
    Kat: '|people|Kat'
  text: ->"""<page bg="#{g.location.images.night}">
    #{@Kat.image 'excited', 'left'}
    <text><p>#{q}Hiya!</q></p></text>
  </page>
  <page>
    #{@James.image 'normal', 'right'}
    <text continue><p>James turned to find the owner of the hand on his shoulder, a young woman matching his own height. She was scrawny, raggedy, her clothes fraying around the edges. #{q}Hello?</q></p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Hi! I'm Kat, nice to meet you.</q> She grabbed his hand and shook it enthusiastically. #{q}You work with Natalie, right?</q></p></text>
  </page>
  <page>
    #{@James.image 'serious', 'right'}
    <text><p>James offered his hand skeptically, making sure to keep a hand on his pocket so nothing could vanish from it. She looked like that sort. #{q}I do. And who are you?</q></p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Oh, we spoke a few days ago, she helped me out a little.</q> Kat kept glancing over her shoulder, looking out for something. #{q}Anyway, I gotta run. They're handing out free blankets at the church this afternoon. What's your name?</q></p></text>
  </page>
  <page>
    #{@James.image 'normal', 'right'}
    <text continue><p>#{q}James Thadel, quartermaster.</q> If Natalie had helped her, she couldn't be that bad.</p></text>
  </page>
  <page>
    #{@Kat.image 'excited', 'left'}
    <text><p>#{q}Ooh, she's a sailor, then?</q></p></text>
  </page>
  <page>
    #{@James.image 'upset', 'right'}
    <text continue><p>#{q}Captain,</q> James bristled.</p></text>
  </page>
  <page>
    #{@Kat.image 'normal', 'left'}
    <text continue><p>#{q}Captain! Wow, a big shot. Anyway, see you later.</q> Kat dodged past him and down an alleyway. She was quick.</p></text>
  </page>
  <page>
    #{@James.image 'normal', 'right'}
    <text continue><p>He shook his head, trying to make sense of the conversation, and gave up.</p></text>
  </page>"""
  effects:
    remove:
      '|location|jobs|katJames': Job.KatJames
