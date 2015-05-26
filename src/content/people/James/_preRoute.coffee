ShipJob.JamesUpset = class JamesUpset extends ShipJob
  label: "Talk with James"
  type: 'plot'
  text: ->"""James has been avoiding Natalie. Something is bothering him. They should talk."""

ShipJob.JamesUpset::next = Page.JamesUpset = class JamesUpset extends Page
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.cabinNight"
    #{@Nat.image 'serious', 'right'}
    -- #{q}So, when're you going to say something?</q>

  ||
    #{@James.image 'normal', 'left'}
    --> #{q}What do you mean?</q> James didn't look in her direction, instead continuing his tallying of numbers.

  ||
    #{@Nat.image 'serious', 'right'}
    --> #{q}You're kidding me. What ever's got you so knotted up you look me in the eyes. Spit it out.</q>

  ||
    #{@James.image 'serious', 'left'}
    -- #{q}I don't want to talk about it. Let's just finish this.</q> He leaned over to check her numbers – they matched, arrived at independently.

  ||
    #{@Nat.image 'serious', 'right'}
    --> Natalie stole the pen out of his hand before he could use it to mark his paper and set it on the desk out of easy reach. #{q}Let's not. Let's talk.</q>

  ||
    #{@James.image 'upset', 'left'}
    -- #{q}I'm keeping my secret for now.</q> He stood and walked out.

  ||
    --> She considered catching him at the door, chasing him out onto the deck, running after him down the plank... He was gone below deck while she still sat at her desk, considering what to do.
"""
  effects:
    remove:
      '|map|Ship|jobs|jamesUpset': ShipJob.JamesUpset

Place.Ship::jobs.jamesMagic = ShipJob.JamesMagic = class JamesMagic extends ShipJob
  label: "Talk with James"
  conditions:
    '|events|JamesUpset':
      matches: (days)-> days[0] + 35 < g.day
  type: 'special'
  text: ->"""Something is bothering James again."""

ShipJob.JamesMagic::next = Page.JamesMagic = class JamesMagic extends PlayerOptionPage
  conditions:
    James: '|officers|James'
    Natalie: '|officers|Nat'
  text: ->"""|| bg="Ship.cabinNight"
    -- A hesitant knock. That could only mean one thing. James never hesitated to address business, no matter how bad the news. He must finally want to discuss whatever has been bothering him. Natalie hesitated a moment, then, #{q @Natalie}Enter.</q>

  ||
    #{@James.image 'serious', 'left'}
    --> #{q}Can I come in?</q>

  ||
    #{@James.image 'serious', 'left'}
    --> She gestured to the bed, the only other place to sit in the room besides her chair, but he remained standing, closing the door behind him. #{q}Why didn't you tell me?</q>

  ||
    -- Straight to the point – it caught her off guard. How much time must he have spent agonizing over that question, to work up the nerve to ask her straight out?

  ||
    #{@Natalie.image 'serious', 'right'}
    --> #{q}I've never told anyone, James. Until the... the storm, there were precisely three people in the world who knew: me, the Guildmaster, and the hedge wizard he hired to teach me, with an unbreakable seal upon his mind to keep his silence.</q>

  ||
    #{@James.image 'upset', 'left'}
    --> #{q}I would protect your secrets with my life, Nat, you know that.</q>

  ||
    #{@Natalie.image 'upset', 'right'}
    -- #{q}That's exactly the problem!</q> She punched his leg – not playfully, but with genuine anger. He didn't flinch. #{q}I don't want you to die!</q> She slumped back in her chair, hating herself for the sudden display. #{q}Do you know what happens to a childless sorceress of my power and inexperience and age?</q>

  ||
    #{@James.image 'serious', 'left'}
    --> #{q}I... that's not fair...</q>

  ||
    #{@Natalie.image 'sad', 'right'}
    -- #{q}There aren't any.</q>

  ||
    #{@Natalie.image 'serious', 'right'}
    -- #{q}There aren't any. They all learn to use their magic to defend themselves, or they have a child with someone powerful who can protect them. If that secret got out, do you think a little girl without family wouldn't just disappear? Even from Vailia. In a heartbeat.</q>

  ||
    #{@Natalie.image 'upset', 'right'}
    --> She'd stood up from her chair by this point. Natalie couldn't tower over him, but she could certainly press him back against the door with her unfair words. #{q}I was eight, when I learned. Could you have kept that secret for me? Not even hinted at it to your parents, when you were eight fucking years old?</q>
    #{options ["Push him away", "Start crying"], ["<em><span class='happiness'>-2 happiness</span> for Natalie</em>", "<em><span class='happiness'>+4 happiness</span> for James, <span class='happiness'>-4</span> for Natalie</em>"]}
"""
  effects:
    remove:
      '|map|Ship|jobs|jamesMagic': ShipJob.JamesMagic
  @next: {}

Page.JamesMagic.next['Push him away'] = Page.JamesMagicPush = class JamesMagicPush extends Page
  conditions:
    James: {}
    Natalie: {}
  text: ->"""|| bg="Ship.cabinNight"
    #{@Natalie.image 'angry', 'right'}
    -- James didn't get angry. He just looked uncomfortable and hurt, and, somehow that only fueled Natalie's anger. She stood reached around him and slammed the door open, a clear signal of "get out" if there ever was one. He opened his mouth to say something, then looking over his shoulder – they had spectators now – snapped it shut again with a click of teeth.

  ||
    #{@James.image 'sad', 'left'}
    --> #{q}I would have, Nat, even at eight, I would have died rather than betray your trust.</q> He shot her a pleading look, but she turned away. He stepped out and closed the door gently behind him.

  ||
    -- She slumped into her chair, exhausted and upset – angry far more at herself than at him. He had done nothing to provoke that. It was all on her shoulders. She started to cry, softly, muffling her sobs in her arms so no one outside would be able to hear, occasionally wiping her eyes with the back of her sleeve.

  ||
    --> He deserved an apology. She deserved a brick to the head. She sniffled and hugged her chest.
"""
  apply: ->
    super()
    @context.Natalie.add 'happiness', -2

Page.JamesMagic.next['Start crying'] = Page.JamesMagicCry = class JamesMagicCry extends Page
  conditions:
    James: {}
    Natalie: {}
  text: ->"""|| bg="Ship.cabinNight"
    #{@Natalie.image 'angry', 'right'}
    -- James didn't get angry. He just looked uncomfortable and hurt, and somehow that only fueled Natalie's anger. She let out an angry cry and punched his chest, unable to find any better way to express herself. She tried to hit him again, but rather than taking this one, he caught her fist in one hand. She struggled a moment trying to free it, but his grip was too strong, and he pulled her into a hug with his other arm.

  ||
    #{@James.image 'sad', 'center'}
    -- #{q}I would have, Nat, even at eight I would have died rather than betray your trust.</q>

  ||
    --> She burst into tears. Sobs wracked her body as she stopped struggling and clung. He let go her hand and wrapped his other arm around her, supporting them both as she sagged against his chest. She wailed and shook in his arms, letting out a tiny portion of two decades of uncertainty and fear.

  || verySlow="true"
    -- It didn't take long for Natalie to cry herself out. She was too self-aware to let loose for long, and she quickly quieted and stilled. She'd hurt him, even if her fist hadn't connected.

  ||
    -->  She tilted her head up to look into his eyes, #{@James.color[2]} and #{@Natalie.color[1]} meeting in a quick and mutually aborted glance. They both blushed and stepped back to conversational distance. His own glance downward suggested that yes, he'd suddenly become as intensely aware of the way her breasts pressed against him as she had.

  ||
    -- #{q @Natalie}I'm sorry. Please, lets talk another time.</q>

  ||
    --> He nodded and made a hurried escape from her room.

  ||
    --> Natalie slumped against the wall and rubbed her eyes with the heel of her palms. He deserved an apology. She deserved a brick to the head. She sniffled and hugged her chest.
"""
  apply: ->
    super()
    @context.Natalie.add 'happiness', -4
    @context.James.add 'happiness', 4
