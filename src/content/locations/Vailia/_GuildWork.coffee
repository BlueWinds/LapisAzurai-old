Place.Vailia.adultPay = 11

Job.GuildWork = class GuildWork extends Job
  label: 'Guild Work'
  text: ->"Work as a whore in Ben Oakly's brothel."
  officers:
    worker:
      is: [Officer.Natalie, Officer.Kat]
      matches: (person)->g.events['SearchGuildWork' + person.name]?
      label: -> switch
        when g.events.SearchGuildWorkKat then 'Nat or Kat'
        else 'Natalie'
  energy: -2
  next: Page.randomMatch
  @next = []

Place.Vailia::jobs.searchGuildWork = Job.SearchGuildWork = class SearchGuildWork extends Job
  label: 'Find Sex Work'
  text: ->"""Have the assigned officer search for safe, fun and well-paid work through Natalie's connections with The Guild."""
  type: 'special'
  conditions:
    notAllDone:
      matches: ->
        for event in Job.SearchGuildWork.next
          if not g.events[event.name] and g.officers[event.name.split('Work')[1]] then return true
        return false
      optional: true
  officers:
    worker:
      matches: (person)-> switch
        when not g.events.SearchGuildWorkNatalie then person instanceof Officer.Natalie
        when not g.events.SearchGuildWorkJames then person instanceof Officer.James
        when not g.events.SearchGuildWorkKat then person instanceof Officer.Kat
        when not g.events.SearchGuildWorkAsara then person instanceof Officer.Asara
      label: -> switch
        when not g.events.SearchGuildWorkNatalie then 'Natalie'
        when not g.events.SearchGuildWorkJames then 'James'
        when not g.events.SearchGuildWorkKat then 'Kat'
        when not g.events.SearchGuildWorkAsara then 'Asara'
  energy: -2

  next: Page.firstNew
  @next = []

Job.SearchGuildWork.next.push Page.SearchGuildWorkNatalie = class SearchGuildWorkNatalie extends Page
  conditions:
    worker: {is: Officer.Natalie}
  effects:
    add: '|location|jobs|guildWork': Job.GuildWork
  text: ->"""|| bg="marketDay|marketStorm"
    -- There were other ways of making money than taking goods between ports. And however distasteful James might find them, Natalie had both the skills and the will to use them. Not forever – she had no intention of giving up the Azurai to work as a whore – but to fill some time, to make some extra money while the others repaired the ship? Sure.

  ||
    #{@worker.image 'normal', 'left'}
    -- #{q}So, who's hiring?</q> She leaned over the counter, crossing her arms and resting her head on them.

  ||
    --> <q>I thought you were too good for us these days, Nat?</q> The girl at the desk teased. Natalie knew her well. They were both Guild children, picked up off the street or abandoned by parents, to work at jobs that didn't need adults. It was hardly a fair deal. The children worked two days a week and in return the Guild fed, housed, raised, educated, and doted upon them. Though James felt bad for her for not having any parents, Natalie preferred to imagine that she instead had hundreds.

  ||
    #{@worker.image 'normal', 'left'}
    -- #{q}'Us'?</q> She quirked an eyebrow at the girl, teasing back.

  ||
    --> <q>Well, I'll be too young for another six months, but you know what I mean. I think Red Strings is your best bet. Monbach's expanding again.</q>

  ||
    #{@worker.image 'serious', 'left'}
    --> Natalie reached over to rap the girl's forehead with a knuckle. #{q}I'm not touching him with a ten foot pole, and neither should you. Who else?</q>

  ||
    -- <q>Well, if you just want something quick, I heard Ben Oakly's been having trouble with higher-end clients ever since Wend ran off with that trader to Kantis. Did you hear about that fuss?</q>

  ||
    #{@worker.image 'normal', 'left'}
    --> #{q}Yeah, she told me about a week before they disappeared. My lips are sealed though.</q>

  ||
    --> <q>Huh, I didn't know that. You think she's doing OK?</q> The girl was naturally concerned for Wend. She'd been the first Child rescued from the streets, blazing the way for those that followed. In a way, both of them owed her their lives.

  ||
    #{@worker.image 'normal', 'left'}
    -- #{q}It's Wend we're talking about here. She could charm blossoms out of a stone with a smile. She'll be fine,</q> Natalie reassured her. #{q}I'll talk with Ben. He's over near the market, isn't he?</q>

  ||
    --> <q>Yep. North side.</q>
  """

Page.SearchGuildWorkNatalie::next = Page.SearchGuildWorkNatalie2 = class SearchGuildWorkNatalie2 extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="day|storm"
    -- Ben Oakly's business establishment straddled the line between legitimate business brothel and shady, slum-servicing whorehouse. Not a distinction most bothered with, but Natalie knew the difference and, for her purposes, straddling the line was perfect. She knocked.

  || bg="tavern"
    -- <q>Not open yet,</q> a voice called out from the closed door.

  ||
    #{@worker.image 'normal', 'left'}
    --> #{q}That's fine, I'm not a customer.</q>

  ||
    --> <q>What do you want then?</q> A man she could only presume was Ben pushed the door half-open with one foot. He held several feathers between his teeth, hands busy with needle and thread sewing another feather into place on a dancer's costume.

  ||
    #{@worker.image 'normal', 'left'}
    -- #{q}I hear you may be in need of another girl.</q>

  ||
    --> <q>Sure, I'm always hiring. 2β a shift, you come in at noon and leave at midnight. Six days a week, food is...</q>

  ||
    #{@worker.image 'serious', 'left'}
    --> Natalie rolled her eyes and shook her head, cutting him off. #{q}I can do better on a street corner. I'm skilled, pretty, clean, young and I've worked for the Guild. I want the jobs you used to have Wend doing.</q>

  ||
    -- That made him pause. He examined her more closely, transferring the feathers from his mouth to one hand. Despite the urge to recoil from the sensation of his oily eyes running up and down her body, Natalie pushed one hip forward and pulled her shirt up, striking a sexy bare-midriff pose for him.

  ||
    --> <q>Yes, nice, nice. Come in, let's talk. Wend was a good girl. Little loony, but a good girl. You loony?</q>
  """

Job.SearchGuildWork.next.push Page.SearchGuildWorkJames = class SearchGuildWorkJames extends Page
  conditions:
    worker: {is: Officer.James}
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.deckDay|Ship.deckStorm"
    #{@worker.image 'angry', 'right'}
    -- #{q}Absolutely not.</q> James stomped his foot on the deck, face beet red.

  ||
    #{@Nat.image 'excited', 'left'}
    --> #{q}It's fun. You get to meet interesting people and fuck 'em. And get paid. Good time all around.</q> Natalie teased her friend, unable to keep a grin from spreading across her face. He was too easy to rattle, really, far too easy.

  ||
    #{@worker.image 'upset', 'right'}
    --> #{q}No way! And I wish you wouldn't joke about things like this either.</q>

  ||
    #{@Nat.image 'normal', 'left'}
    -- #{q}Aww, come on. You're not getting any action around here,</q> she pinched his cheek, pulling her hand away before he could swat it. #{q}So...</q>

  ||
    #{@worker.image 'blush', 'right'}
    --> #{q}Stop it, Nat, not funny.</q> He swatted her hand away before she could grab his other cheek. #{q}Look, I know you were raised to see it as no big deal, but this is important to me. I'm not going to sleep with some random woman just because I want a few coins in my pocket.</q>
  """

# Job.SearchGuildWork.next.push Page.SearchGuildWorkAsara = class SearchGuildWorkAsara extends Page
#   conditions:
#     worker: {is: Officer.Asara}
#     Nat: '|officers|Nat'
#   text: ->"""|| bg="Ship.deckDay|Ship.deckStorm"
#     -- Asara hung her head despondently, clutching her arms across her chest.
#
#   ||
#     #{@Nat.image 'upset', 'left'}
#     --> #{q}I'm sorry, Asara, please, I didn't mean you had to, it was just a thought,</q> Natalie desperately wanted to hold her shoulder, or maybe hug her, but physical contact was not a thing Asara handled well. Natalie felt like shit.</q>
#
#   ||
#     #{@Nat.image 'upset', 'left'}
#     -- Asara hung her head despondently, clutching her arms across her chest.
#       #{q}I'm sorry, Asara, please, I didn't mean you had to, it was just a thought,</q> Natalie desperately wanted to hold her shoulder, or maybe hug her, but physical contact was not a thing Asara handled well. Natalie felt like shit. #{q}I'm sorry I suggested it.</q>
#
#   ||
#     --> Asara started to cry.
#
#   ||
#     #{@Nat.image 'upset', 'left'}
#     -- #{q}Shhh, shh, it's going to be alright, no one's going to make you do anything.</q> Natalie gave in and hugged her, pressing the young woman against her chest even as she shuddered. Asara just hugged herself tighter and broke into sobs.
#   """

Job.SearchGuildWork.next.push Page.SearchGuildWorkKat = class SearchGuildWorkKat extends Page
  conditions:
    worker: {is: Officer.Kat}
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.deckDay|Ship.deckStorm"
    -- #{q @worker}I told you a long time ago I don't want to be a whore,</q> Kat turned her back on Natalie, leaning over the edge of the ship.

  ||
    #{@Nat.image 'normal', 'left'}
    --> #{q}Neither do I, Kat, neither do I. But acting like one is fun occasionally. You're a sexy lady, and no one's going to make you do something you don't want to. I just thought you might like a chance to act on some of those lewd comments you're always making.</q>

  ||
    #{@worker.image 'normal', 'right'}
    --> #{q}Oh, I like sex alright. But, doncha'know, I'd rather sleep with you than anyone else,</q> she wiggled her rear, punctuating the motion by winking over her shoulder.

  ||
    #{@Nat.image 'excited', 'left'}
    -- #{q}Doesn't work on me. James would blush, but I'll just take you up on the offer.</q> Natalie slapped the presented rump, and Kat squealed. #{q}Tell you what. Do it just this once, and if you don't like it I won't ask again.</q>

  ||
    #{@worker.image 'normal', 'right'}
    --> She got a calculating look in her eye for a moment, then turned back to face Natalie fully. #{q @worker}And what, hypothetically speaking, would you gain from this?</q>

  ||
    #{@Nat.image 'normal', 'left'}
    --> #{q}Well, 25%, I'd expect.</q>

  ||
    -- #{q @worker}And why would I pay you, for work I was doing?</q>

  ||
    #{@Nat.image 'normal', 'left'}
    --> #{q}Because I'll find you your clients, of course. And make sure you get paid fairly. Oh, and of course I have a Guild license for you to operate under. I don't think you have 800β to be spending on one of those, at the moment, do you?</q>

  ||
    --> Kat's eyebrows shot up at that figure. If she saved every penny working on the Lapis for five years, she might be able to afford something like that.

  ||
    #{@Nat.image 'normal', 'left'}
    -- #{q}Gifted by the Guildmaster. He's the one you have to pay for them in the first place, and it made a fine birthday present for me when I came of age.</q> Natalie quirked an eyebrow at Kat and smirked.

  ||
    #{@Nat.image 'normal', 'left'}
    --> Natalie quirked an eyebrow at Kat and smirked. #{q}So, my cute little doxy, shall we sally forth?</q>
  """

Job.GuildWork.next.push Page.GuildNat = class GuildNat extends Page
  conditions:
    worker: {is: Officer.Natalie}
  text: ->"""|| bg="night|storm"
    -- Natalie knocked on Ben Oakly's back door half an hour before sunset – late enough that she wouldn't have to waste time loitering around and trying to pick up stragglers, but early enough that not too many would have drifted away.

  ||
    --> The door opened to reveal a maid – an older woman, careworn and tired looking. <q>What do you want?</q>

  ||
    #{@worker.image 'normal', 'left'}
    -- #{q}I believe Ben will wish to see me, if he's available. Tell him Natalie is here for some work.</q>

  ||
    --> The old woman nodded and closed the door in her face. A few minutes later it opened again, this time with her prospective employer, or at least prospective middle-man.
  """
  next: Page.randomMatch
  @next: []

Page.GuildNat.next.push Page.GuildNatBang = class GuildNatBang extends PlayerOptionPage
  conditions:
    worker: {}
  text: ->"""|| bg="night|storm"
    -- <q>I have just the thing. Party of six, looking for a cum slut for the night. All men, though they don't look like the type of play too rough. All my girls were already too tired for that when they came in, though I have a private room. Interested?</q>
      #{options ['Sure', 'No']}
  """
  @next: {}

Page.GuildNatBang.next['No'] = Page.GuildNatBangNo = class GuildNatBangNo extends Page
  ignoreNew: true
  conditions:
    worker: {}
  text: ->"""|| bg="night|storm"
    #{@worker.image 'normal', 'left'}
    -- #{q}Sorry, I think I'll pass. They sound like delightful people, though, so give them my regards.</q> Though she wasn't particularly sensitive about her body or sex, Ben made it sound like just <em>sooooo</em> much fun.

  ||
    --> Ben rolled his eyes. <q>My, you are picky. But that's all I had tonight. Maybe another day, or if you come back later.
  """

Page.GuildNatBang.next['Sure'] = Page.GuildNatBangSure = class GuildNatBangSure extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="night|storm"
    #{@worker.image 'normal', 'left'}
    -- #{q}Sounds good. What do they look like?</q>

  ||
    --> <q>Can't miss 'em, blue uniforms right in the middle of the lobby, sitting and gabbing all night long. I expect to be paid my share,</q> he waggled a finger at her.

  ||
    -- She ignored the insinuation and pushed past him. Through the kitchen she went, pausing only to straighten her messy hair at least a little and nodding to another woman resting against one of the counters.

  || bg="tavern"
    --> The main room was surprisingly busy for such a disreputable business. She spotted her boys easily – as he'd said, hard to miss, in their matching blue uniforms. They looked sharp, despite rough faces. Probably the crew for some important diplomat. A merchant would never waste money outfitting their sailors with such fine cloth, no matter how well off.

  ||
    #{@worker.image 'excited', 'left'}
    -- #{q}Hey,</q> she inserted herself into their circle, sliding down onto the table where they'd all set their drinks. Several of them hurried to retrieve theirs as she leaned back, extending her legs and resting on her elbows.

  ||
    --> <q>Hey yourself, good looking. You here for our entertainment?</q>

  ||
    #{@worker.image 'normal', 'left'}
    --> #{q}I'm here to have some fun. If you think it'll be entertaining, who am I to complain?</q> She smirked and rolled her shoulders sensuously. #{q}Shall we find a room?</q>
  """

Page.GuildNatBangSure::next = Page.GuildNatBangSure2 = class GuildNatBangSure2 extends Page
  conditions:
    worker: {}
  text: ->"""|| verySlow="true"
    --| Natalie moaned and arched her back, finger nails digging into the arms holding her in place. They didn't stop bouncing her up and down, impaled on two cocks and held up between them, each thrust making her breasts bounce as she clung to the man in front of her. She didn't know his name. She didn't know any of their names, so she just addressed him by looking up into his eyes as she spoke.

  ||
    --> #{q @worker}Cum in me, cum in me, cum in me,</q> she repeated, and he responded by thrusting faster, bouncing her even harder. She clung to him, mouth half open and dazed as his partner sped up his motions as well, pounding her ass with equal vigor. They both groaned, but the one in front held on while the one behind emptied his load deep into her bowels.

  ||
    --> He wasn't the first – she was already dripping with semen down there – and he also wasn't the last. Natalie hung from the man in front of her while another took his place in her rear. The fresh cock was shorter, but also thicker. She whimpered as he slid in, the sound only serving to further ignite the passions that surrounded her, and soon she was again being pounded in both holes.

  || verySlow="true"
    -- Natalie didn't think of anything much as she collected the coins scattered around the room. Though she'd used all her cunning to become more than just a whore (the usual fate of Guild children), working as one for a bit of extra cash on the side wasn't bad. One didn't grow up serving drinks and cleaning rooms at a brothel without losing the inhibitions around a subject.

  || bg="tavern"
    #{@worker.image 'normal-nude', 'left'}
    --> And it had felt good, after all. She was not indifferent to the attractions of having sex with half a dozen sculpted and beautiful men. There was no sense lying about that to herself.

  ||
    #{@worker.image 'normal-nude', 'left'}
    -- She searched about for the dress she'd worn and found it underneath a chair, torn apart along the back seam. She pursed her lips. It had been a nice dress.

  ||
    #{@worker.image 'serious-nude', 'left'}
    --> Natalie tossed it on the bed with the cum-drenched sheets. Let the maid take it home and repair it if she liked. Though it didn't bother her overmuch, to do such things for money, she wanted no reminders. Her panties were mercifully intact, and she wrapped herself in a towel to go downstairs. Ben wanted his share, and she needed to collect her spare clothes.
# TODO FIX CONTINUITY - See previous comment, line 301. This clashes.
  ||
    --> <em><span class="money">+#{Place.Vailia.adultPay}β</span></em>
  """
  effects:
    money: Place.Vailia.adultPay
  apply: ->
    super()
    @context.worker.add 'happiness', -0.5

Page.GuildNat.next.push Page.GuildNatDom = class GuildNatDom extends PlayerOptionPage
  conditions:
    worker: {}
  text: ->"""|| bg="night|storm"
    -- <q>Hm, I think I have something you might enjoy. Two girls, nervous, who get scared whenever I send someone to try and grease them up. You can have whatever they'll pay you for. Minus my part, of course.</q>

  ||
    #{@worker.image 'upset', 'left'}
    --> #{q}What makes you think they want anything at all, that they aren't just here on a dare?</q>

  ||
    --> <q>Oh, they want something alright. They're just too scared to ask for it,</q> Ben gave her a leer.
      #{options ['Sure', 'No'], []}
  """
  @next: {}

Page.GuildNatDom.next['No'] = Page.GuildNatDomNo = class GuildNatDomNo extends Page
  ignoreNew: true
  conditions:
    worker: {}
  text: ->"""|| bg="night|storm"
    #{@worker.image 'upset', 'left'}
    -- She swatted him on the shoulder. #{q}Keep your mind out of my pants, and let them make their own decisions. I'm not in the business of convincing people to do things they'll regret.</q>

  ||
    --> <q>If you say so, Ms. Princess. Let me know when you actually want to work.</q> He rolled his eyes and shut the door in her face.
  """

Page.GuildNatDom.next['Sure'] = Page.GuildNatDomSure = class GuildNatDomSure extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="night|storm"
    #{@worker.image 'normal', 'left'}
    -- She swatted him on the shoulder. #{q}Keep your mind out of my pants.</q>

  ||
    #{@worker.image 'normal', 'left'}
    --> #{q}I'll see what I can do.</q> Natalie nodded and stepped inside, pushing her way past him. A pair of whores twittered in one corner of the kitchen, waiting for their bread to toast over the fire and talking nonsense. One waved at Natalie and she waved back with a smile. Sisters in the business, worlds apart in everything else.

  || bg="tavern"
    -- The girls in question sat in one corner, occupying both seats of a couch and watching the scene around them nervously. Natalie stopped before they noticed her and observed for a moment. They looked at the ground whenever anyone came too close, but Ben hadn't been wrong. Their nerves were those of anticipation, their body language towards each other geared towards seeming braver than they really were to work up courage.

  ||
    #{@worker.image 'serious', 'left'}
    -- #{q}This isn't a park, ladies,</q> she addressed them, standing with a slight smile and one hand on her hip. The woman she'd addressed was about her own height, strawberry blonde hair just past her shoulders and breasts that looked over-sized on her small frame.

  ||
    --> <q>Yes, I... we know, Ms,</q> the other girl responded, taking Natalie's attention off her friend. She was a little plump, soft and freckled with short brown curls.

  ||
    #{@worker.image 'normal', 'left'}
    --> #{q}Well, let's get moving then.</q>

  ||
    --> <q>We're going to... to... pick someone soon. Don't make us leave. Please?</q>

  ||
    #{@worker.image 'serious', 'left'}
    -- Natalie smirked. #{q}Not out, to my room. You've picked me.</q>

  ||
    --> The strawberry girl opened her mouth, closed it again, leaned in to whisper something to her friend with a blush that quickly spread to her friend's freckled face, who whispered something back. Natalie smiled to herself. She'd judged them right, a thought confirmed by their next words, or lack thereof.

  ||
    --> Both of them nodded to each other, and stood uncertainly, ready to follow.
  """

Page.GuildNatDomSure::next = Page.GuildNatDomSure2 = class GuildNatDomSure2 extends Page
  conditions:
    worker: {}
  text: ->"""|| verySlow="true"
    --| #{q}That's a good girl, Derria. Deep breath.</q> Natalie caressed the plump girl's cheek with one hand, her other still gripping Daria's hair tightly. After a moment to let her catch her breath Natalie pressed forward again. Her friend moaned and writhed as Derria's lips and nose pressed into her crotch. #{q}Stay still!</q> Natalie commanded, and she did so.

  ||
    --> Really, there wasn't much for her to do – as she'd figured, the two friends were far more attracted to each other than they were to her or anyone else. They just needed a stern voice telling them to do what they already wanted, to help overcome shyness and fear of rejection.

  ||
    --> No rejection here.

  ||
    --> Derria returned to her task enthusiastically, lapping and slurping at her friend's pussy with a variety of rather lewd noises. As much as her friend was enjoying the sensations, Natalie could also tell that she was equally anxious to return the favor and make sure Derria felt good as well. It was rather endearing, and arousing, leaving Natalie horny but unneeded and still dressed. At least she could make sure they both had a good time. She dipped her fingers into Derria's slit, pushing the curly brown head deeper into her friend's crotch.

  || verySlow="true" bg="tavern"
    -- Natalie wiped her hands on a towel and examined herself in the mirror – still presentable. She hadn't even taken her shirt off. Quietly she opened the door and stepped out, so as not to wake them.

  ||
    --> <em><span class="money">+#{Place.Vailia.adultPay}β</span>, <span class="happiness">+1 happiness</span></em>

  ||
    #{@worker.image 'normal', 'left'}
    -- Downstairs and back in the #{q}staging area,</q> she tapped Ben Oakly on the shoulder, interrupting his heart-to-heart with a plate of mashed potatoes. #{q}I left them sleeping upstairs. The blonde one will pay when they leave.</q>

  ||
    --> <q>Doesn't look like you did much,</q> Ben sniffed experimentally, poking his head closer to her than was, strictly speaking, appropriate.

  ||
    #{@worker.image 'blush', 'left'}
    --> She pushed him away gently. #{q}They're satisfied. Send my share to the Guild, I'll get it there.</q> Natalie shook her head. #{q}Whatever you're thinking, don't try it. Treating me fairly is the cheaper option by far.</q>

  ||
    --> <em><span class="money">+#{Place.Vailia.adultPay}β</span></em>
  """
  effects:
    money: Place.Vailia.adultPay
  apply: ->
    super()
    @context.worker.add 'happiness', 1


Job.GuildWork.next.push Page.GuildKat = class GuildKat extends Page
  conditions:
    worker: {is: Officer.Kat}
  text: ->"""|| bg="night|storm"
    -- Kat paused in front of the door. Though Natalie had introduced her to Ben Oakly and walked with her through the establishment, she was still somewhat nervous#{if g.events.GuildKat then " her first time here alone" else ""}. She stepped out of the way of a drunken man wobbling out the front door, beer on his foul breath filling her nose. Not the most encouraging sign.

  ||
    #{@worker.image 'serious', 'left'}
    -- She slapped her cheeks and stood up straight. Nat had asked her to try this. Asked, not told. She wasn't going to back out now. Sex was fun. She'd had it before. It was not something to be afraid of.

  ||
    --> The front door swung open again, blasting her with the scents of so many half-dressed bodies, perfume and sweat and alcohol. This time, it was a woman holding it open for her. Kat pressed inside.
"""
  next: Page.randomMatch
  @next: []

Page.GuildKat.next.push Page.GuildKatEasy = class GuildKatEasy extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="tavern"
    -- <q>You're a cute one, aren'cha, love?</q> The lady draped a strong arm over her shoulder and guided her towards the back halls. <q>Natalie spoke with me, told me you're new to all this, so don' worry. I'll make sure you have a nice and easy one. You like boys or girls?</q>

  ||
    #{@worker.image 'excited', 'left'}
    --> #{q}Both!</q> Kat attempted to reassert some control over the encounter by loudly proclaiming her preference. #{q}Either, I meant. Not both-right-now.</q>

  ||
    -- The woman laughed at her enthusiasm. <q>That's a good attitude. Keep that smile on and they'll love you. Now, it's not your job to worry about the money. You just go over to that man there. He's a regular. Tell him you're new here. He'll love that. Room 3 in back is yours. Keep in mind that the longer he stays with you, the more you make.</q>

  ||
    --> He looked nice enough, and entirely too respectable to ever want anything to do with her. On the street, that was. In here, she reminded herself with a grin, he was paying for the privilege of spending time with her.

  ||
    --> #{q}Hi!</q>

  ||
    --| Kat trembled and bit her lip, pressing back into the bed. Her partner was gentle yet insistent, taking what he wanted and leaving no doubt that he was going to get it. Hot breath against her stomach and intense eyes looking up along her body while his finger worked its magic, thrusting in and out, teasing her insides... They locked eyes for a moment before she dropped her head back to the pillow and gave up trying to be quiet.

  ||
    --> In response to her moans he dipped a second finger inside, eliciting a stronger reaction yet. Though her legs were pinned beneath him, held in place by his weight on half-removed trousers, her hips bucked, at least until he shifted his weight and pressed her stomach down into the bed with one hand. He leaned forward to nip at her breast with his teeth before flashing a grin. "No getting away from me that easily."

  ||
    --> Getting away was the last thing on her mind when he removed his hand, leaving her suddenly empty. Her plaintive sigh changed to a giggle as he tugged at her legs, dragging her closer to the edge of the bed and pulling her ankles up and over his shoulders.
  """

Page.GuildKatEasy::next = Page.GuildKatEasy2 = class GuildKatEasy2 extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="tavern"
    --| <q>Let me help you with that.</q> Kat sat up, leaving her ankles on his shoulders, and laughed at the look her flexibility gathered. She began working on his belt, fumbling a little from the awkward, though for him arousing, position.

  ||
    --> Finally his cock sprang free and with a growl he wrapped her up in a bear hug. The motion impaled her all the way, his rod slipping into her wet slit effortlessly. She cried out breathlessly at the sudden sensation, filled and crushed and folded in half. She wrapped her arms around his neck, and he responded by burying his head in her neck and biting down.

  ||
    --> She moaned and pulled him tighter against her as he began to rock his hips, grinding her pelvis against him, his cock deep inside her. Already dripping from his tongue a moment ago, the motion made a wet mess of the area where they were connected. From the way he growled into her neck and the tensing in his groins, she could tell he was getting close.

  ||
    --> She screamed as he came, as much from the force with which he bit into her neck as from the flood of cum he was pumping deep into her pussy. Clamped down like a vampire on her neck, he thrust into her with short strokes while he emptied his load.

  ||
    --> Finally spent, he relaxed his grip, both teeth and arms. She slid her legs down off his shoulders as he collapsed on top of her and wrapped her arms around his head, holding it nestled against her chest. They crawled further onto the bed, pulled the blanket up, and slept.

  || bg="none" verySlow="verySlow"

  || bg="tavern"
    -- <q>That's outrageous!</q>

  ||
    --> Kat watched from behind a curtain as the man she'd just slept with, both literally and in the sexual sense, argued over the fee with Ben Oakly. Ben just pointed to the sign again - an hourly rate.

  ||
    -- <q>Just because I fell asleep doesn't mean I'm paying five times the usual! She was great, I'll grant you that,</q> his gaze wandered off with a dreamy look for a moment before snapping back to focus, <q>and I'll gladly add an extra half, but...</q>

  ||
    #{@worker.image 'normal-nude', 'far-left'}
    --> Time to let Ben do his job. Kat ducked back back into the room to start searching for her clothes. It still smelled like sex. Good times.

  ||
    --> <em><span class="money">+#{Place.Vailia.adultPay}β</span></em>
  """
  effects:
    money: Place.Vailia.adultPay
