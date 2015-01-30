Place.Vailia.adultPay = 11

marketImage = ->
  if g.weather is 'storm' then g.map.Vailia.images.marketStorm else g.map.Vailia.images.marketDay
portImage = ->
  if g.weather is 'storm' then g.map.Vailia.images.storm else g.map.Vailia.images.day

Job.GuildWork = class GuildWork extends Job
  label: 'Guild Work'
  text: ->"<p>Work as a whore in Ben Oakly's brothel.</p>"
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
  label: 'Search for Sex Work'
  text: ->"""<p>Have the assigned officer search for safe, fun and well-paid work through Natalie's connections with The Guild.</p>"""
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
  text: ->"""<page bg="#{marketImage()}">
    <text><p>There were other ways of making money than taking goods between ports. And however distasteful James might find them, Natalie had both the skills and the will to use them. Not forever – she had no intention of giving up the Azurai to work as a whore – but to fill some time, to make some extra money while the others repaired the ship? Sure.</p></text>
  </page>

  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}So, who's hiring?</q> She leaned over the counter, crossing her arms and resting her head on them.</p></text>
  </page>
  <page>
    <text continue><p><q>I thought you were too good for us these days, Nat?</q> The girl at the desk asked in a teasing voice. Natalie knew her well – they were both Guild children, picked up off the street or abandoned by parents, to work at jobs that didn't need adults. It was hardly a fair deal. The children worked two days a week, and in return the Guild fed, housed, raised, educated, and doted upon them. Though James felt bad for her for not having any parents, Natalie preferred to imagine that she instead had hundreds.</p></text>
  </page>

  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}'Us'?</q> She quirked an eyebrow at the girl, teasing back.</p></text>
  </page>
  <page>
    <text continue><p><q>Well, I'll be too young for another six months, but you know what I mean. I think Red Strings is your best bet – Monbach's expanding again.</q></p></text>
  </page>
  <page>
    #{@worker.image 'serious', 'left'}
    <text continue><p>Natalie reached over to rap the girl's forehead with a knuckle. #{q}I'm not touching him with a ten foot pole, and neither should you. Who else?</q></p></text>
  </page>
  <page>
    <text><p><q>Well, if you just want something quick, I heard Ben Oakly's been having trouble with higher-end clients ever since Wend ran off with that trader to Kantis. Did you hear about that fuss?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}Yeah, she told me about a week before they disappeared. My lips are sealed though.</q></p></text>
  </page>
  <page>
    <text continue><p><q>Huh, I didn't know that. You think she's doing OK?</q> The girl was naturally concerned for Wend – she'd been the first Child. In a way, both of them owed her their lives.</p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}It's Wend we're talking about here. She could charm blossoms out of a stone, if she smiled at it nicely. She'll be fine,</q> Natalie reassured her. #{q}I'll talk with Ben. He's over near the market, isn't he?</q></p></text>
  </page>
  <page>
    <text continue><p><q>Yep. North side.</q></p></text>
  </page>"""

Page.SearchGuildWorkNatalie::next = Page.SearchGuildWorkNatalie2 = class SearchGuildWorkNatalie2 extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{portImage()}">
    <text><p>Ben Oakly's business establishment straddled the line between legitimate business brothel and shady slum-servicing whorehouse. Not a distinction most bothered with, but Natalie knew the difference, and for her purposes, straddling the line was perfect. She knocked.</p></text>
  </page>

  <page bg="#{g.map.Vailia.images.tavern}">
    <text><p><q>Not open yet,</q> a voice called out from the closed door.</p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}That's fine, I'm not a customer.</q></p></text>
  </page>
  <page>
    <text continue><p><q>What do you want then?</q> A man she could only presume was Ben pushed the door half-open with one foot. He held several feathers between his teeth, hands busy with needle and thread sewing another feather into place on a dancer's costume.</p></text>
  </page>

  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}I hear you may be in need of another girl.</q></p></text>
  </page>
  <page>
    <text continue><p><q>Sure, I'm always hiring. 2β a shift, you come in at noon and leave at midnight. Six days a week, food is...</q></p></text>
  </page>
  <page>
    #{@worker.image 'serious', 'left'}
    <text continue><p>Natalie rolled her eyes and shook her head, cutting him off. #{q}I can do better on a street corner. I'm skilled, pretty, clean, young and I've worked for the Guild. I want the jobs you used to have Wend doing.</q></p></text>
  </page>

  <page>
    <text><p>That made him pause. He examined her more closely, transferring the feathers from his mouth to one hand. Despite the urge to recoil from the sensation of his oily eyes running up and down her body, Natalie pushed one hip forward and pulled her shirt up, striking a sexy bare-midriff pose for him.</p></text>
  </page>
  <page>
    <text continue><p><q>Yes, nice, nice. Come in, let's talk. Wend was a good girl. Little loony, but a good girl. You loony?</q></p></text>
  </page>"""

Job.SearchGuildWork.next.push Page.SearchGuildWorkJames = class SearchGuildWorkJames extends Page
  conditions:
    worker: {is: Officer.James}
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{if g.weather is 'storm' then g.map.Ship.images.deckStorm else g.map.Ship.images.deckDay}">#{@worker.image 'angry', 'right'}
    <text><p>#{q}Absolutely not.</q> James stomped his foot on the deck, face beet red.</p></text>
  </page>
  <page>
    #{@Nat.image 'excited', 'left'}
    <text continue><p>#{q}It's fun. You get to meet interesting people and fuck 'em. And get paid. Good time all around.</q> Natalie teased her friend, unable to keep a grin from spreading across her face. He was too easy to rattle, really, far too easy.</p></text>
  </page>
  <page>
    #{@worker.image 'blush', 'right'}
    <text continue><p>#{q}No way! And I wish you wouldn't joke about things like this either.</q></p></text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text><p>#{q}Aww, come on. You're not getting any action around here,</q> she pinched his cheek, pulling her hand away before he could swat it, #{q}so...</q></p></text>
  </page>

  <page>
    #{@worker.image 'upset', 'right'}
    <text continue><p>#{q}Stop it, Nat, not funny.</q> He swatted her hand away before she could grab his other cheek.</p></text>
  </page>
  <page>
    #{@worker.image 'blush', 'right'}
    <text continue-inline> #{q}Look, I know you were raised to see it as no big deal, but this is important to me. I'm not going to sleep with some random woman just because I want a few coins in my pocket.</q></text>
  </page>"""

# Job.SearchGuildWork.next.push Page.SearchGuildWorkAsara = class SearchGuildWorkAsara extends Page
#   conditions:
#     worker: {is: Officer.Asara}
#     Nat: '|officers|Nat'
#   text: ->"""<page bg="#{if g.weather is 'storm' then g.map.Ship.images.deckStorm else g.map.Ship.images.deckDay}">
#     <text><p>Asara hung her head despondently, clutching her arms across her chest.</p></text>
#   </page>
#   <page>
#     #{@Nat.image 'upset', 'left'}
#     <text continue><p>#{q}I'm sorry, Asara, please, I didn't mean you had to, it was just a thought,</q> Natalie desperately wanted to hold her shoulder, or maybe hug her, but physical contact was not a thing Asara handled well. Natalie felt like shit.</q></p></text>
#   </page>
#   <page>
#     #{@Nat.image 'upset', 'left'}
#     <text><p>Asara hung her head despondently, clutching her arms across her chest.</p>
#     <p>#{q}I'm sorry, Asara, please, I didn't mean you had to, it was just a thought,</q> Natalie desperately wanted to hold her shoulder, or maybe hug her, but physical contact was not a thing Asara handled well. Natalie felt like shit. #{q}I'm sorry I suggested it.</q></p></text>
#   </page>
#   <page>
#     <text continue><p>Asara started to cry.</p></text>
#   </page>
#
#   <page>
#     #{@Nat.image 'upset', 'left'}
#     <text><p>#{q}Shhh, shh, it's going to be alright, no one's going to make you do anything.</q> Natalie gave in and hugged her, pressing the young woman against her chest even as she shuddered. Asara just hugged herself tighter and broke into sobs.</p></text>
#   </page>"""

Job.SearchGuildWork.next.push Page.SearchGuildWorkKat = class SearchGuildWorkKat extends Page
  conditions:
    worker: {is: Officer.Kat}
    Nat: '|officers|Nat'
  text: ->"""<page bg="#{if g.weather is 'storm' then g.map.Ship.images.deckStorm else g.map.Ship.images.deckDay}">
    <text><p>#{q @worker}I told you a long time ago I don't want to be a whore,</q> Kat turned her back on Natalie, leaning over the edge of the ship.</p></text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue><p>#{q}Neither do I, Kat, neither do I. But acting like one is fun occasionally. You're a sexy lady, and no one's going to make you do something you don't want to. I just thought you might like a chance to act on some of those lewd comments you're always making.</q></p></text>
  </page>
  <page>
    <text continue><p>#{q @worker}Oh, I like sex alright. But doncha'know, I'd rather sleep with you than anyone else,</q> she wiggled her rear, punctuating the motion by winking over her shoulder.</p></text>
  </page>

  <page>
    #{@Nat.image 'excited', 'left'}
    <text><p>#{q}Doesn't work on me. James would blush, but I'll just take you up on the offer.</q> Natalie slapped the presented rump, and Kat squealed. #{q}Tell you what. Do it just this once, and if you don't like it I won't ask again.</q></p></text>
  </page>
  <page>
    <text continue><p>She got a calculating look in her eye for a moment, then turned back to face Natalie fully. #{q @worker}And what, hypothetically speaking, would you gain from this?</q></p></text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue><p>#{q}Well, 25%, I'd expect.</q></p></text>
  </page>
  <page>
    <text continue><p>#{q @worker}And why would I pay you, for work I was doing?</q></p></text>
  </page>"""

Page.SearchGuildWorkKat::next = SearchGuildWorkKat2 = class SearchGuildWorkKat2 extends Page
  conditions:
    worker: {}
    Nat: {}
  text: ->"""<page>
    #{@Nat.image 'normal', 'left'}
    <text><p>#{q}Because I'll find you your clients, of course. And make sure you get paid fairly. Oh, and of course I have a Guild license for you to operate under. I don't think you have 800β to be spending on one of those, at the moment, do you?</q></p></text>
  </page>
  <page>
    <text continue><p>Kat's eyebrows shot up at that figure. If she saved every penny working on the Lapis for five years, she might be able to afford something like that.</p></text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue><p>#{q}Gifted by the Guildmaster. He's the one you have to pay for them in the first place, and it made a fine birthday present for me when I came of age.</q> Natalie quirked an eyebrow at Kat and smirked.</p></text>
  </page>
  <page>
    #{@Nat.image 'happy', 'left'}
    <text continue><p>Natalie quirked an eyebrow at Kat and smirked. #{q}So, my cute little doxy, shall we sally forth?</q></p></text>
  </page>"""

portNightImage = -> if g.weather is 'storm' then g.location.images.storm else g.location.images.night

Job.GuildWork.next.push Page.GuildNat = class GuildNat extends Page
  conditions:
    worker: {is: Officer.Natalie}
  text: ->"""<page bg="#{portNightImage()}">
    <text><p>Natalie knocked on Ben Oakly's back door half an hour before sunset – late enough that she wouldn't have to waste time loitering around and trying to pick up stragglers, but early enough that not too many would have drifted away.</p></text>
  </page>
  <page>
    <text continue><p>The door opened to reveal a maid – an older woman, careworn and tired looking. <q>What do you want?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}I believe Ben will wish to see me, if he's available. Tell him Natalie is here for some work.</q></p></text>
  </page>
  <page>
    <text continue><p>The old woman nodded and closed the door in her face. A few minutes later it opened again, this time with her prospective employer – or at least prospective middle-man.</p></text>
  </page>"""
  next: Page.randomMatch
  @next: []

Page.GuildNat.next.push Page.GuildNatBang = class GuildNatBang extends PlayerOptionPage
  conditions:
    worker: {}
  text: ->"""<page bg="#{portNightImage()}">
    <text><p><q>I have just the thing. Party of six, looking for a cumslut for the night. All men, though they don't look like the type of play too rough. All my girls were already too tired for that when they came in, though I have a private room. Interested?</q></p>
    #{options ['Sure', 'No']}</text>
  </page>"""
  @next: {}

Page.GuildNatBang.next['No'] = Page.GuildNatBangNo = class GuildNatBangNo extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{portNightImage()}">
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}Sorry, I think I'll pass. They sound like delightful people, though, so give them my regards.</q> Though she wasn't particularly sensitive about her body or sex, Ben made it sound like just <em>sooooo</em> much fun.</p></text>
  </page>
  <page>
    <text continue><p>Ben rolled his eyes. <q>My, you are picky. But that's all I had tonight. Maybe another day, or if you come back later.</p></text>
  </page>"""

Page.GuildNatBang.next['Sure'] = Page.GuildNatBangSure = class GuildNatBangSure extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{portNightImage()}">
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}Sounds good. What do they look like?</q></p></text>
  </page>
  <page>
    <text continue><p><q>Blue uniforms. Can't miss 'em, right in the middle of the lobby, sitting and gabbing all night long. I expect to be paid my share,</q> he waggled a finger at her. </p></text>
  </page>

  <page>
    <text><p>She ignored the insinuation and pushed past him. Through the kitchen she went, pausing only to straighten her messy hair at least a little and nodding to another woman resting against one of the counters.</p></text>
  </page>
  <page bg="#{g.map.Vailia.images.tavern}">
    <text continue><p>The main room was surprisingly busy for such a relatively irreputible business. She spotted her boys easily – as he'd said, hard to miss, in their matching blue uniforms. They looked sharp, despite rough faces. Probably the crew for some important diplomat – a merchant would never waste money outfitting their sailors so, no matter how well off.</p></text>
  </page>

  <page>
    #{@worker.image 'excited', 'left'}
    <text><p>#{q}Hey,</q> she inserted herself into their circle, sliding down onto the table where they'd all set their drinks. Several of them hurried to retrieve theirs as she leaned back, extending legs and resting on her elbows.</p></text>
  </page>
  <page>
    <text continue><p><q>Hey yourself, good looking. You here for our entertainment?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}I'm here to have some fun. If you think it'll be entertaining, who am I to complain?</q> She smirked and rolled her shoulders sensuously. #{q}Shall we find a room?</q></p></text>
  </page>"""

Page.GuildNatBangSure::next = Page.GuildNatBangSure2 = class GuildNatBangSure2 extends Page
  conditions:
    worker: {}
  text: ->"""<page verySlow>
    <text class="full"><p>Natalie moaned and arched her back, finger nails digging into the arms holding her in place. They didn't stop bouncing her up and down, impaled on two cocks and held up between them, each thrust making her breasts bounce as she clung to the man in front of her. She didn't know his name – she didn't know any of their names – so she just addressed him by looking up into his eyes as she spoke.</p></text>
  </page>
  <page>
    <text continue class="full"><p>#{q @worker}Cum in me, cum in me, cum in me,</q> she repeated, and he responded by thrusting faster, bouncing her even harder. She clung to him, mouth half open and dazed as his partner sped up his motions as well, pounding her ass with equal vigor. They both groaned, but the one in front held on while the one behind emptied his load deep into her bowels.</p></text>
  </page>
  <page>
    <text continue class="full"><p>He wasn't the first – she was already dripping with semen down there – and he also wasn't the last. Natalie hung from the man in front of her while another took his place in her rear. The fresh cock was shorter, but also thicker. She whimpered as he slid in, the sound only serving to further ignite the passions that surrounded her, and soon she was again being pounded in both holes.</p></text>
  </page>

  <page verySlow>
    <text><p>Natalie didn't think of anything much as she collected the coins scattered around the room. Though she'd resisted becoming a whore with all her cunning and might, working as one was something she was used to. One didn't grow up serving drinks at a brothel or cleaning rooms the morning after without losing the inhibitions around a subject.</p></text>
  </page>
  <page bg="#{g.map.Vailia.images.tavern}">
    #{@worker.image 'normal', 'left'}
    <text continue><p>And it had felt good, after all. She was not indifferent to the attractions of having sex with half a dozen sculpted and beautiful men. No sense lying about that to herself.</p></text>
  </page>

  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>She searched about for the dress she'd worn, and found it underneath a chair, torn apart along the back seam. She pursed her lips. It had been a nice dress.</p></text>
  </page>
  <page>
    #{@worker.image 'serious', 'left'}
    <text continue><p>Natalie tossed it on the bed with the cum-drenched sheets. Let the maid take it home and repair it if she liked. Though it didn't bother her overmuch, to do such things for money, she wanted no reminders. Her panties were mercifully intact, and she wrapped herself in a towel to go downstairs. Ben wanted his share, and she needed to collect her spare clothes.</p></text>
  </page>
  <page>
    <text continue><p><em><span class="money">+#{Place.Vailia.adultPay}β</span></em></text>
  </page>"""
  effects:
    money: [Place.Vailia.adultPay, 'Worked in Vailian brothel']
  apply: ->
    super()
    @context.worker.add 'happiness', -0.5

Page.GuildNat.next.push Page.GuildNatDom = class GuildNatDom extends PlayerOptionPage
  conditions:
    worker: {}
  text: ->"""<page bg="#{portNightImage()}">
    <text><p><q>Hm, I think I have something you might enjoy. Two girls, nervous, who get scared whenever I send someone to try and grease them up. You can have whatever they'll pay you for. Minus my part, of course.</q></p></text>
  </page>
  <page>
    #{@worker.image 'upset', 'left'}
    <text continue><p>#{q}What makes you think they want anything at all, aren't just here on a dare?</q></p></text>
  </page>
  <page>
    <text continue><p><q>Oh, they want something alright. They're just too scared to ask for it,</q> Ben gave her a leer.</p>
    #{options ['Sure', 'No'], []}</text>
  </page>"""
  @next: {}

Page.GuildNatDom.next['No'] = Page.GuildNatDomNo = class GuildNatDomNo extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{portNightImage()}">
    #{@worker.image 'upset', 'left'}
    <text><p>She swatted him on the shoulder. #{q}Keep your mind out of my pants, and let them make up their own decisions. I'm not in the business of convincing people to do things they'll regret.</q></p></text>
  </page>
  <page>
    <text continue><p><q>If you say so, Ms. Princess. Let me know when you actually want to work,</q> he rolled his eyes and shut the door in her face.</p></text>
  </page>"""

Page.GuildNatDom.next['Sure'] = Page.GuildNatDomSure = class GuildNatDomSure extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{portNightImage()}">
    #{@worker.image 'normal', 'left'}
    <text><p>She swatted him on the shoulder. #{q}Keep your mind out of my pants.</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}I'll see what I can do.</q> Natalie nodded and stepped inside, pushing her way past him. A pair of whores twittered in one corner of the kitchen, waiting for their bread to toast over the fire and talking about nonsense. One waved at Natalie, and she waved back with a smile. Sisters in the business – worlds apart in everything else.</p>
  </page>

  <page bg="#{g.map.Vailia.images.tavern}">
    <text><p>The women in question sat in one corner, occupying both seats of a couch and watching the scene around them nervously. Natalie stopped before they noticed her and observed for a moment. They looked at the ground whenever anyone came too close, but Ben hadn't been wrong – their nerves were those of anticipation, their body language towards each other geared towards seeming braver than they really were to work up courage.</p></text>
  </page>

  <page>
    #{@worker.image 'serious', 'left'}
    <text><p>#{q}This isn't a park, ladies,</q> she addressed them, standing with a slight smile and one hand on her hip. The woman she'd addressed was about her own height, strawberry blond hair just past her shoulders and breasts that looked over-sized on her small frame.</p></text>
  </page>
  <page>
    <text continue><p><q>Yes, I... we know, Ms,</q> the other girl responded, taking Natalie's attention off her friend. She was a little plump, soft and freckled with short brown curls.</p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}Well, let's get moving then.</q></p></text>
  </page>
  <page>
    <text continue><p><q>We're going to... to... pick someone soon. Don't make us leave. Please?</q></p></text>
  </page>

  <page>
    #{@worker.image 'serious', 'left'}
    <text><p>Natalie smirked. #{q}Not out, to my room. You've picked me.</q></p></text>
  </page>
  <page>
    <text continue><p>The strawberry girl opened her mouth, closed it again, leaned in to whisper something to her friend with a blush that quickly spread to her friend's freckled face, who whispered something back. Natalie smiled to herself – she'd judged them right, a thought confirmed by their next words. Or lack thereof.</p></text>
  </page>
  <page>
    <text continue><p>Both of them nodded to each other, and stood uncertainly, ready to follow.</p></text>
  </page>"""

Page.GuildNatDomSure::next = Page.GuildNatDomSure2 = class GuildNatDomSure2 extends Page
  conditions:
    worker: {}
  text: ->"""<page verySlow>
    <text class="full"><p>#{q}That's a good girl, Derria. Deep breath.</q> Natalie caressed the plump girl's cheek with one hand, her other still gripping Daria's hair tightly. After a moment to let her catch her breath Natalie pressed forward again. Her friend moaned and writhed as Derria's lips and nose pressed into her crotch. #{q}Stay still!</q> Natalie commanded, and she did so.</p></text>
  </page>
  <page>
    <text continue class="full"><p>Really, there wasn't much for her to do – as she'd figured, the two friends were far more attracted to each other than they were to her or anyone else. They just needed a stern voice telling them to do what they already wanted, to help overcome shyness and fear of rejection.</p></text>
  </page>
  <page>
    <text continue class="full"><p>No rejection here.</p>
  </page>
  <page>
    <text continue class="full"><p>Derria returned to her task enthusiastically, lapping and slurping at her friend's pussy with a variety of rather lewd noises, and as much as her friend was enjoying the sensations, Natalie could also tell that she was equally anxious to return the favor and make sure Derria felt good as well. It was rather endearing – and also somewhat arousing to watch, leaving Natalie horny but unneeded, still dressed. At least she could make sure they both had a good time – she dipped her fingers it's Derria's slit, pushing the curl brown head deeper into her friend's crotch.</p></text>
  </page>
  <page verySlow bg="#{g.location.images.tavern}">
    <text><p>Natalie wiped her hands on a towel and examined herself in the mirror – still presentable. She hadn't even taken her shirt off. Quietly she opened the door and stepped out, so as not to wake them.</p></text>
  </page>
  <page>
    <text continue><p><em><span class="money">+#{Place.Vailia.adultPay}β</span>, <span class="happiness">+1 happiness</span></em></p>
  </page>

  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>Downstairs and back in the #{q}staging area,</q> she tapped Ben Oakly on the shoulder, interrupting his heart-to-heart with a plate of mashed potatoes. #{q}I left them sleeping upstairs. The blond one will pay when they leave.</q></p></text>
  </page>
  <page>
    <text continue><p><q>Doesn't look like you did much,</q> Ben sniffed experimentally, poking his head closer to her than was strictly speaking appropriate.</p></text>
  </page>
  <page>
    #{@worker.image 'blush', 'left'}
    <text continue><p>She pushed him away gently. #{q}They're satisfied. Send my share to the Guild, I'll get it there.</q> Natalie shook her head. #{q}Whatever you're thinking, don't try it. Treating me fairly is the cheaper option by far.</q></p></text>
  </page>"""
  effects:
    money: [Place.Vailia.adultPay, 'Worked in Vailian brothel']
  apply: ->
    super()
    @context.worker.add 'happiness', 1
