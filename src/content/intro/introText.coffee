hairColor = {}
for color of Officer.Natalie.colors[2]
  hairColor[color] = color

skinColor = {}
for color of Officer.Natalie.colors[0]
  skinColor[color] = color

eyeColor = {}
for color of Officer.Natalie.colors[1]
  eyeColor[color] = color.capitalize()

Page.Intro = class Intro extends Page
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
    Ship: '|map|Ship'
  text: ->
    element = $.render("""<page>
      <text class="full center"><em>Click anywhere on the page or use the down arrow key to advance</em></text>
    </page>
    <page slow>
      <text class="full center">
        Natalie dreamt of Fire.
      </text>
    </page>
    <page slow>
      <text class="full center" continue>
        Not the tame fire of a lantern, or even the fierce danger of a forest fire. No, her dream was of Fire, the blaze with which the gods made the stars or with which they burned the skies and scorched the world clean at the dawn of an age.
      </text>
    </page>
    <page slow>
      <text class="full center" continue>
        She also dreamt of Ocean, a vast and barren wasteland separating pinpricks of land. In her dream she knew the ocean was waiting for her, waiting for her to see something no one else has ever seen before, and that no one would see again before storms wiped the land clean.
      </text>
    </page>
    <page slow>
      <text class="full center" continue>
        And she dreamt of Love. Neither fire nor water, she finally had a body made of flesh, and in her heart grew a secret warmth that even the end of the world could not smother. Her secret love could neither be burned nor drowned, and it would flower into a beautiful life if only it would grow large enough, surrounded by chaos and flood and storm. She curled around it protectively.
      </text>
    </page>
    <page verySlow bg="Ship.cabinDay">
      <text>
        Thud.
      </text>
    </page>
    <page>
      <text continue>
        The dream ended abruptly as she fell off the bed. Groggy and disoriented, but definitely awake, she rubbed her head and opened her eyes. Morning light. She stumbled to her feet, grabbing the edge of her bed for support as the ship rocked beneath her. The roll of the Lapis Azurai was gentle, calming even, chasing away fraying fragments of her dreams and reminding her of where and who she was.
      </text>
    </page>
    <page>
      <text>
        She was on a ship. On her ship. Captain Natalie. She liked the sound of that. Provisional captain. If she brought it back from its maiden voyage she'd have earned the rank for real. If she didn't bring it back, well, not much use thinking about that. Nearly a tenth of all vessels that set sail sank, all hands lost. The ocean was not safe.
      </text>
    </page>
    <page>
      <text continue>
        Not hers though. This was her ship. It would come back with her aboard, and not just the first time. Every time.
      </text>
    </page>
    <page class="select-color">
      #{@Nat.image 'normal', 'left'}
      <text>
        Grinning at the thought of herself in wrinkles and walking across the deck with a cane – as if! - she brushed #{dropdown hairColor, @Nat.color[2]} hair out of her eyes and examined herself in the mirror. #{dropdown eyeColor, @Nat.color[1]} eyes, still sleepy. She slapped her #{dropdown skinColor, @Nat.color[0]} cheeks and stuck her tongue out at the reflection. There were old sailors and old captains, good enough or lucky enough, and she was going to be one of them. No cane though.
        #{options ['Done']}
      </text>
    </page>""")

    element.find('input').change =>
      # Update each layer with a new HSL value
      checked = $ 'input:checked', element
      @Nat.color = [
        checked.eq(2).val()
        checked.eq(1).val()
        checked.eq(0).val()
        'none'
      ]

      # Now update the image (including invalidating the cache)
      $('.person', element).replaceWith @Nat.image 'normal', 'left', false

    element.filter('.select-color').help(
      target: 'options'
      title: "Many pages require your input before you can proceed. Like this one, where you can select your appearance."
    )

    $('options button', element).click ->
      (new Page.Intro2).apply()
      Game.gotoPage()

    return element

  next: false

Page.Intro2 = class Intro2 extends Page
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
  text: -> """<page bg="Ship.cabinDay">
    <text>
      #{q @James}Nat! You ok?</q> James called.
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue>
      #{q}Yeah, fine.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue>
      #{q @James}I heard you thumping around.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue>
      #{q}It's nothing. How much time do we have?</q> She splashed water on her face, dried it back off with a towel, then started looking for her boots.
    </text>
  </page>
  <page>
    <text>
      #{q @James}Should have left ten minutes ago!</q> He hadn't woken her up though – Natalie had learned long ago that James would worry himself sick at the slightest excuse, but it wasn't until he was practically vibrating with impatience that she actually needed to hurry.
    </text>
  </page>
  <page slow bg="Ship.deckDay">
    #{@Nat.image 'serious', 'left'}
    <text>
      #{q}I don't believe you,</q> she opened the door and stepping out to join him on deck. #{q}You were rather drunk last night. How are your eyes not red?</q>
    </text>
  </page>
  <page bg="Ship.deckDay">
    #{@Nat.image 'excited', 'left'}
    <text continue>
      Natalie poked James in the forehead, causing him to wince. #{q}I knew it, you just woke up too.</q>
    </text>
  </page>
  <page>
    #{@James.image 'blush', 'right'}
    <text continue>
      He shook his head, trying to deny it, but she quirked an eyebrow, and he finally relented. #{q}Hey, it was our very first night on board your new ship. A little drinking seemed in order.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text>
      #{q}Never said it wasn't. Now, come on, I want breakfast before we meet with the Guildmaster.</q>
    </text>
  </page>
  <page>
    #{@James.image 'serious', 'right'}
    <text continue>
      #{q}Should have left half an hour ago,</q> he grumbled.
    </text>
  </page>"""
  effects:
    add:
      '|missions|meet': Mission.MeetGuildmaster
      '|location|jobs|visit': Job.IntroVisitGuildmaster


Job.IntroVisitGuildmaster::next = Page.IntroVisitGuildmaster = class IntroVisitGuildmaster extends Page
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
    Guildmaster: '|people|Guildmaster'
    Vailia: '|map|Vailia'
  text: ->"""<page bg="guildOffice">
    <text>
      The Guild.
    </text>
  </page>
  <page>
    <text continue>
      James hesitated at the doors, then hurried to join Natalie when she shot him an impatient look. The lobby was rather busy this morning, filled with preparations for the annual Festival of Lights, the longest day of the year made even longer by a celebration that ran until dawn.
    </text>
  </page>
  <page>
    <text>
      <q>The Guildmaster is waiting for you in his office,</q> the young man at the front desk prompted, sounding a little envious. Natalie was barely a year older than him. That she'd have the attention of the Guildmaster was unusual, to say the least. He'd never even spoken with many of the "Guild Children."
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text continue>
      #{q}Thanks. Light a candle for me,</q> she leaned over the desk and pinched his cheek. He was cute, but she couldn't remember his name. #{q @Nat}I'm going to have to miss the festival this year.</q>
    </text>
  </page>
  <page>
    <text continue>
      <q>Will do, Nat,</q> he swatted away her hand with a grin. Envious or not, children lifted off the streets and raised together looked out for their own.
    </text>
  </page>
  <page>
    <text>
      Natalie entered the Guildmaster's office, trailed a moment later by James. She immediately went over and flopped into a seat across from him, while James hovered behind her and looked nervous.
    </text>
  </page>
  <page>
    #{@Guildmaster.image 'normal', 'right'}
    <text continue>
      Guildmaster Janos looked up from his reading and smiled at them. Though he had assistants to handle all the papers necessary, he still preferred to touch at least some of that work himself. Understanding the details and not merely the overview of the Guild's operations gave him important advantages, he'd once told her. Natalie briefly saw a column of figures – expenses, deposits – before he leaned forward, covering it with one arm.
    </text>
  </page>
  <page>
    #{@Guildmaster.image 'smiling', 'right'}
    <text>
      #{q}Please, I'm not going to bite. James Thadel, is it? I understand you're to be Natalie's first mate?</q>
    </text>
  </page>
  <page>
    #{@James.image 'blush', 'left'}
    <text continue>
      #{q}Sorry sir, yes sir.</q> James stood up straighter, self consciously moving out from his position half hidden behind her. #{q}Quartermaster,</q> he corrected.
    </text>
  </page>
  <page>
    #{@Guildmaster.image 'thinking', 'right'}
    <text>
      #{q}Please take as good care of her as we have.</q> He gestured to a pair of chairs in front of his desk. Natalie relaxed into hers, while James perched on the edge. It was his first time meeting Janos, and she couldn't help but chuckle at his nervousness. She'd been awed too, her first time meeting the second most powerful man in the city – but eight year old Natalie had gotten over that nervousness by promptly sitting in his lap, rather than the offered chair. She smiled at the memory. He'd approved, as Wend had said he would, rather than scolding her.
    </text>
  </page>
  <page>
    #{@Guildmaster.image 'normal', 'right'}
    <text continue>
      #{q}When do you set sail?</q> he went on.
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'left'}
    <text>
      #{q}Soon. Two, three days. We've finished going over every inch of planking, and the initial trials around the island went well – if you see him, please thank Captain Johnson for assisting us with that. I discussed prices for our first cargo with...</q> Natalie listed off the preparations she'd made for departure, while Janos listened attentively, interjecting occasionally with tidbits of advice. He was one of the finest business minds in the city, and it comforted her to know that he would catch anything she'd forgotten. Which was, she suspected, the actual point of this meeting – protecting his investment. Managing a merchant ship was not the Guild's usual line of business.
    </text>
  </page>
  <page>
    #{@Guildmaster.image 'thinking', 'right'}
    <text>
      #{q}Very thorough. I have nothing more to add.</q> He jotted down a note, and nodded.
    </text>
  </page>
  <page>
    #{@Nat.image 'excited', 'center'}
    <text continue>
      Natalie grinned at that, as much approval as he ever showed of anything. Impulsively she stood and leaned over the desk and planted a kiss on his cheek before he could say anything. She quickly retreated back to her seat, sitting on her hands lest they do anything else untoward.
    </text>
  </page>
  <page>
    #{@Guildmaster.image 'normal', 'right'}
    <text>
      #{q}Please let me know when you return.</q> He didn't react to her gesture, other than to adjust a stack of papers back into place, but she suspected he was pleased. Hard to tell, with the Guildmaster. She also knew a dismissal when she heard one.
    </text>
  </page>
  <page class="given-mission">
    #{@Guildmaster.image 'normal', 'right'}
    <text continue>
      <em>New Mission: <strong>Prepare to set sail</strong></em>
    </text>
  </page>"""

  effects:
    remove:
      '|missions|meet': Mission.MeetGuildmaster

Job.IntroSail::next = Page.IntroSail = class IntroSail extends Page
  conditions:
    James: {}
    Nat: {}
    Ship: '|map|Ship'
  text: ->"""<page bg="Ship.cabinDay">
    #{@Nat.image 'serious', 'right'}
    <text>
      Natalie laid aside her pen and admonished James, looming in the doorway. #{q}If you're going to fill the room with dread, at least enter all the way.</q>
    </text>
  </page>
  <page bg="Ship.cabinDay">
    #{@James.image 'sad', 'left'}
    <text continue>
      He started guiltily, and stepped into her bedroom, closing the door behind him with a foot. He remained standing – other than the chair she occupied, the only place to sit would be on her bed, and he wasn't the sort to be comfortable with that. The space was cramped, but a private room was still more than most people aboard a ship this size would get, even the quartermaster. He'd have to share with the first-mate, once they had one.</text>
  </page>
  <page>
    #{@James.image 'sad', 'left'}
    <text>
      #{q}Nat...</q> he trailed off, then started again. #{q}I'm not sure I can do this.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'sad', 'right'}
    <text continue>
      She waited for him to go on, but he didn't, just fidgeted and leaned against the door, resisting the swell and roll of the deck beneath them. Timber creaked, adjusting to new stresses. #{q}What can't you do?</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'upset', 'right'}
    <text continue>
      #{q}We've hired a crew, loaded a cargo, and are planning to set sail in the morning. It's a bit late for second thoughts now.</q>
    </text>
  </page>
  <page>
    #{@James.image 'sad', 'left'}
    <text>
      #{q}It's just... I can't shake this feeling of doom. Do you know how many ships survive a storm? I did some figuring – it's less than a third, if you get caught out to sea.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'right'}
    <text continue>
      Natalie stood and moved over to the bed, patting the chair and indicating that he should take the seat. #{q}The Azurai is a good ship. She'll see us through. The shipwrights knew what they were doing when they built her. She may be small, but she's fast and sturdy.</q> She patted his knee, attempting to reassure him of something she wasn't entirely sure of herself.
    </text>
  </page>
  <page>
    #{@James.image 'sad', 'left'}
    <text>
      #{q}What are we even doing here, Natalie? There's plenty of opportunity at home, without risking our lives.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'sad', 'right'}
    <text continue>
      #{q}You have a future in Vailia, and I never asked you to give it up. It's not my future. I don't have anyone to hand me a house and a trade. James, do you know what I'd be doing, right now, if I weren't a captain?</q>
    </text>
  </page>
  <page>
    #{@James.image 'sad', 'left'}
    <text>
      Natalie was too small and too smart to desire any form of manual labor, and too poor to set herself up in any other trade.
    </text>
  </page>
  <page>
    #{@James.image 'blush', 'left'}
    <text continue>
      Red crept along his cheeks as he considered the question. Young, attractive, raised by the Guild... really, there was only one way to that question. She'd be selling her body, same as plenty of other Vailian girls her age pretty enough to make it a trade. #{q}I, ah, sorry,</q> he apologized lamely.</q>
    </text>
  </page>
  <page>
    #{@Nat.image 'normal', 'right'}
    <text>
      #{q}Don't be. I chose this, you chose this, and if we'd chosen differently, we'd be different.</q> She poked his forehead, trying to break the mood before he turned into a beet. It had happened before, if she teased him about sex too much, but now wasn't the time.
    </text>
  </page>
  <page>
    #{@James.image 'blush', 'left'}
    <text continue>
      #{q}I suppose so,</q> he rubbed his forehead, rolled his shoulders, stood up. Despite his slight frame, Natalie knew just how strong he was – one wasn't born as a blacksmith's son without working up some strength.
    </text>
  </page>
  <page>
    #{@Nat.image 'sad', 'right'}
    <text continue>
      #{q}Have a good night. Stop worrying.</q> She looked away and picked up her pen again.
    </text>
  </page>"""

  effects:
    remove:
      '|missions|crewCargo': Mission.CrewCargo
      '|location|jobs|sail': Job.IntroSail
