Game::location = Place.VailiaIntro = class VailiaIntro extends Place
  images: Place.Vailia::images
  name: "Vailia"
  description: ->
    """<p class="intro-help">Your crew are listed on the right of the page, all the jobs they can perform - and the requirements for each - are on the left. You can begin a day once everyone in your crew has a task.</p>
    <p class="intro-help">You can also hover over the Lapis Azurai logo in the top left for your current status.</p>
    <div class="intro-main">#{Place.Vailia::description.call @}</div>"""
  jobs: new Collection

content =
  sfw: 'No explicit content'
  nsfw: 'Explicit text'
  lewd: 'Sexy images and text'

Page.Config = class Config extends Page
  next: false
  text: ->"""<page>
    <img src="game/content/misc/world.png" class="full-background">
    <form>
      <div class="col-md-4 col-xs-6 col-md-offset-2">
        <h3>Content</h3>
        #{dropdown content, (g?.content or 'sfw')}
      </div>
      <div class="col-md-4 col-xs-6">
        <h3>Animation</h3>
        #{dropdown {no: 'No transitions', yes: 'Animated pages'}, if not g? or g.animation then 'yes' else 'no'}
      </div>
      <button class="btn btn-primary center-block">Ready!</button>
    </form>
    <text>
      <p><em>Before we get started, take a moment to look over the configuration. You can update these settings at any later time with the Config button up top.</em></p>
    </text>
  </page>"""
  apply: (element)->
    element.find('input').change ->
      inputs = $ 'input:checked', element
      g.content = inputs.eq(0).val()
      g.animation = if inputs.eq(1).val() is 'yes' then true else false
    element.find('button').click ->
      (new Page.Intro).show()

hairColor = {}
for effect in Person.Natalie.colors[3]
  hairColor[effect[0]] = effect[0]

eyeColor = {}
for effect in Person.Natalie.colors[2]
  eyeColor[effect[0]] = effect[0]

skinColor = {}
for effect in Person.Natalie.colors[1]
  skinColor[effect[0]] = effect[0]

Page.Intro = class Intro extends Page
  conditions:
    James: '|crew|James'
    Nat: '|crew|Nat'
    Ship: '|map|Ship'
  text: ->"""<page class="slowFadeOut"><text class="full center">
    <p><em>Move between pages using the arrows on the right of the page, your mouse wheel, or the arrow keys.</em></p>
  </text></page>
  <page class="slowFadeIn verySlowFadeOut"><text class="full center">
    <p>Natalie dreams of fire.</p>
  </text></page>
  <page class="verySlowFadeOut"><text class="full center">
    <p>Natalie dreams of fire.</p>
    <p>Not the tame fire of a lantern, or even the fierce danger of a forest fire - no, her dream is of Fire, the sort of blaze with which the gods made the stars, or with which they burned the skies and scorched the land baren three thousand years ago. She sees it raging in the palm of someone's hand, a fist clenching it tight to prevent it from spreading and once again consuming the world.</p>
  </text></page>
  <page class="verySlowFadeOut"><text class="full center">
    <p>Natalie dreams of fire.</p>
    <p>Not the tame fire of a lantern, or even the fierce danger of a forest fire - no, her dream is of Fire, the sort of blaze with which the gods made the stars, or with which they burned the skies and scorched the land baren three thousand years ago. She sees it raging in the palm of someone's hand, a fist clenching it tight to prevent it from spreading and once again consuming the world.</p>
    <p>She also dreams of Ocean, the vast stretches of water separting pinpricks of land. In her dream she knows that the ocean is waiting for her, waiting for her to see something no one else has ever seen before, and that the storms sweeping away cities will end, if only she can spot what's hidden in plain sight.</p>
  </text></page>
  <page class="verySlowFadeOut"><text class="full center">
    <p>Natalie dreams of fire.</p>
    <p>Not the tame fire of a lantern, or even the fierce danger of a forest fire - no, her dream is of Fire, the sort of blaze with which the gods made the stars, or with which they burned the skies and scorched the land baren three thousand years ago. She sees it raging in the palm of someone's hand, a fist clenching it tight to prevent it from spreading and once again consuming the world.</p>
    <p>She also dreams of Ocean, the vast stretches of water separting pinpricks of land. In her dream she knows that the ocean is waiting for her, waiting for her to see something no one else has ever seen before, and that the storms sweeping away cities will end, if only she can spot what's hidden in plain sight.</p>
    <p>And she dreams of love. Neither fire nor water, she finally has a body, and in her heart grows a secret warmth that even the end of the world cannot smother. Her secret love can neither be burned nor drowned, and it will flower into a beautiful life, if only she can protect it. Natalie curls around it protectively...</p>
  </text></page>
  <page style="background-image:url('#{@Ship.images.dayCabin}');" class="verySlowFadeIn">
    <text>
      <p>#{q @James}Wakey wakey!</q> Someone pounds on the door, heavy thumps disturbing the early morning air. Morning... no, not morning. The light seeping around the heavy curtain seems closer in quality to afternoon. It lacks dawn's golden tint, a certain yellow quality...</p>
      #{bq}Are you even in there, Natalie? It's already noon!</blockquote>
    </text>
  </page>
  <page style="background-image:url('#{@Ship.images.dayCabin}');">
    <text>
      <p>Natalie sits up, rubbing hands in eyes and trying to make sense of the world. It shouldn't be noon. It should still be early morning.</p>
      <p>#{q @Nat}Mhgph. I'm here. It can't be afternoon. Waking up is for morning. I'm waking up, it's morning.</q> The impeccible logic of the half asleep.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Ship.images.dayCabin}');">
    <text>
      <p>#{q @James}Never the less it is noon, sleepyhead. I'll be waiting on deck when you're ready.</q> Deck, yes. That is an exciting sound. It's why Natalie was too nervous and excited to sleep last night, laying awake in bed, pacing the deck and generally being neither productive nor restful. The gentle roll of the floor beneath her feet reminds her that she's now Captain.</p>
      <p>Captain Natalie. That's a good sound too.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Ship.images.dayCabin}');">
    #{@Nat.image 'normal', 'mid-left'}
    <text>
      <p>Stumbling over to a mirror, Natalie runs a hand through her hair, trying to bring some semblance of order to the #{dropdown hairColor, (@Nat.color?[3] or 'fiery')} mess. #{dropdown eyeColor, (@Nat.color?[2] or 'green')} eyes stare back. She slaps her cheeks, makes a face and turns away. Lots to do today. Her #{dropdown skinColor, (@Nat.color?[1] or 'light')} hands are soft for now, but not for long. A life at sea and the hard physical labor of managing a ship will callus them soon enough.</p>
    </text>
  </page>"""
  apply: (element)->
    element.find('input').change =>
      # Update each layer with a new HSL value
      checked = $ 'input:checked', element
      @context.Nat.color = [
        false
        checked.eq(2).val()
        checked.eq(1).val()
        checked.eq(0).val()
        false
      ]

      # Now update the image (including invalidating the cache)
      $('.person', element).replaceWith @context.Nat.image 'normal', 'mid-left', false

Page.Intro::next = Page.Intro2 = class Intro2 extends Page
  conditions:
    James: '|crew|James'
    Nat: '|crew|Nat'
    Ship: '|map|Ship'
    Vailia: '|map|Vailia'
  text: -> """<page style="background-image:url('#{@Vailia.images.day}');">
    #{@James.image 'normal', 'mid-right reversed'}
    <text>
      <p>James is waiting for her when Natalue finally emerges, tapping his foot impatiently.</p>
      <p>#{q @James}It's about time! Were you planning on sleeping all day? You have an appointment with Guildmaster Janos any minute now!</q> He has been her friend for six years, and she'd be lost without him. Natalie has, however, learned that "right now," "immediately" and "this very second!" generally translate into "plenty of time." They're not running late until he's actually vibrating with impatience.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Ship.images.day}');">
    <text>
      <p>Natalie stops to admire her new ship from the docks. It still smells like fresh pine and pitch, the deck smooth and unworn. The Lapis Azurai, she's named it, fresh out of Vailia's famous shipyards. It's the latest in naval technology - two main masts and a smaller forward sail, flat bottomed for exploring unfamiliar seas and rivers, wide enough to carry supplies for two full years for a normal crew - or a pretty penny in trade goods for shorter voyages. Vailia's shipwrights are the best in the world. The Lapis is one of the fastest ships ever built.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.day}');">
    #{@James.image 'upset', 'mid-right reversed'}
    <text>
      <p>Now James is actually vibrating, tugging on Natalie's hand and stamping his feet at every momentary delay. There will be plenty of time to admire the ship later. Time to get going.<p>
    </text>
  </page>"""
  next: Page.Port

Place.VailiaIntro::jobs.visit = Job.IntroVisitGuildmaster = class IntroVisitGuildmaster extends Job
  label: "Visit Guildmaster"
  text: ->"Guildmaster Janos would like to speak with Natalie before she leaves."
  conditions:
    times:
      path: '|location|jobs|visit'
      'days|length': {lt: 1}
    Guildmaster: '|people|Guildmaster'
  workers:
    Nat: '|crew|Nat'
    James: '|crew|James'

Job.IntroVisitGuildmaster::next = Page.IntroVisitGuildmaster = class IntroVisitGuildmaster extends Page
  conditions:
    James: '|crew|James'
    Nat: '|crew|Nat'
    Guildmaster: '|people|Guildmaster'
    Vailia: '|map|Vailia'
  text: ->"""<page style="background-image:url('#{@Vailia.images.marketDay}');">
    #{@Guildmaster.image 'thinking', 'mid-right reversed'}
    <text>
      <p>The Guildmaster is waiting alone in his office, watching the city below. It's an impressive view from up here, not just the third floor, but from Uptown in general, perched as the richest part of the city is on a hill overlooking the rest of the city. Far in the distance Natalie can just see the spires of the palace, the other center of power, sandwiching the populace between them. She's never had much to do with the palace, the king or the nobility - her focus has always been narrower and closer to home.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.marketDay}');">
    #{@Guildmaster.image 'smiling', 'mid-right reversed'}
    <text>
      <p>Janos turns and gives a genial smile as James quietly closes the door behind himself and Natalie.</p>
      <p>#{q @Guildmaster}Thank you for coming. I'm sure you have far too much to do and are eager to get to it, but indulge an old man to share some advice for a few minutes.</q> The Guildmaster may sound rambling, but Natalie listens attentively. Janos can call it indulgence all he wants, but he's one of the sharpest business minds in the known world. Any advice he cares to give should be well heeded. And besides which - the Guild is built on friendly smiles and soft words - there may very well be important orders cloaked in the form of polite suggestions.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.marketDay}');">
    #{@Guildmaster.image 'serious', 'mid-right reversed'}
    <text>
      <p>#{q @Guildmaster}I will say only three things. Do not sail in a storm - you may believe you can handle it, but 15% of the ships we send out founder within a year. Use your connection with the Guild sparingly - we are not universally beloved, outside these city walls.</q></p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.marketDay}');">
    #{@Guildmaster.image 'smiling', 'mid-right reversed'}
    <text>
      <p>#{q @Guildmaster}I will say only three things. Do not sail in a storm - you may believe you can handle it, but 15% of the ships we send out founder within a year. Use your connection with the Guild sparingly - we are not universally beloved, outside these city walls.</q></p>
      <p>#{q}And finally, wash your face before you arrive at an important meeting.</q></p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.marketDay}');">
    #{@Nat.image 'blush', 'mid-left'}
    <text>
      <p>James snickers in the background as Natalie tries to melt through the floor in embarrassment.</p>
      <p>#{q @Nat}Yes sir, will do.</q> She wipes her face on her sleeve.</p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.marketDay}');">
    #{@Nat.image 'excited', 'mid-left'}
    <text>
      <p>In a moment of abandon, she leans in and hugs Janos enthusiastically. The normally dignified Guildmaster smiles, and turns the tables by licking his thumb and appempting to wipe the smudge off her face as though she were no more than a child. Mortified, Natalie retreats back and blushes, repeating the act of cleaning her face on her sleeve.</p>
      <p>#{q}Yes sir, will do.</q></p>
    </text>
  </page>
  <page style="background-image:url('#{@Vailia.images.night}');">
    <text>
      <p>The rest of the day is something of a blur, filled with final papers to be filled out, letters to be written and double checking every item on a list of things to do - crew, supplies, tread goods, picking a new destination. Without James's guidance and assistance Natalie would be completely lost - but the authority and risk both ultimately come back to rest on her shoulders. James gets paid regardless of whether they make a profit on each trade run. He won't be on the hook if they lose the ship.</p>
    </text>
  </page>
  <page style="background-image:url('#{g.map.Ship.images.cabinNight}');">
    #{@James.image 'normal', 'mid-right reversed'}
    <text>
      <p>#{q @James}We have to do two things before we can set sail - hire the rest of the crew at the tavern and stock up on supplies and trade goods at the market.</q> He hesitates for a moment before offering advice - Natalie can be prickly if he pretends to dispense more wisdom that he possesses. #{q}Hiring a crew first will let us shift more goods if you buy something heavy from the market, so that might be a good place to start. Or we could split up to cover more ground.</q></p>
    </text>
  </page>"""

Place.VailiaIntro::jobs.hire = Job.GuildIntroHire = class GuildIntroHire extends Job.VailiaHireCrew
  conditions:
    times:
      path: '|location|jobs|visit'
      'days|length': {gte: 1}
  description: ->"""<p>#{@Recruiter} talks to the bartender, passes over a coin for the trouble and sets #{him @Recruiter}self up at a table. It isn't long before #{he} has some interested recruits.</p><p><em>Click on any of the recruits in the bar (the left column) you want to hire and then in the box holding your crew (on the right).</em></p>"""
