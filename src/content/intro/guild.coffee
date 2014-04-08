Person.PlayerGuildF = class PlayerGuildF extends Person.Tina
  name: 'Natalie'
  business: 10
  diplomacy: 20
  stealth: 10
  combat: 5
  happiness: 100
  endurance: 5
  level: 1
  growth:
    business: 1
    diplomacy: 1
    combat: 1
    stealth: 1
    happiness: 5
  traits: {}
  color:
    text: '#9BBCFF'


Person.PlayerGuildM = class PlayerGuildM extends Person.James
  name: 'David'
  business: 10
  diplomacy: 20
  stealth: 10
  combat: 5
  happiness: 100
  endurance: 5
  level: 1
  growth:
    business: 1
    diplomacy: 1
    combat: 1
    stealth: 1
    happiness: 5
  traits: {}
  color:
    text: '#9BBCFF'


vgm = 'GuildIntroVisitGuildmaster'
Job[vgm] = class GuildIntroVisitGuildmaster extends Job
  name: "Vist the Guildmaster"
  text: -> "Before setting you loose on the world, Guildmaster Janos asked to speak with #{g.player} and #{g.crew.GuildFriend}."
  workers:
    player: {path: 'player'}
    friend: {path: 'crew|GuildFriend'}
  # next is defined below

Place.VailiaIntro = class VailiaIntro extends Place
  images: Place.Vailia::images
  name: "Vailia"
  description: ->"""<p>Your crew are listed on the right of the page, all the jobs they can perform - and the requirements for each - are on the left. You can begin a day once everyone in your crew has a task.</p>"""
  jobs:
    visit: Job[vgm]

guildGame = ->
  window.g = new Game
    day: 0
    player: new Person.PlayerGuildF
    crew:
      GuildFriend: new Person.James
    location: new Place.VailiaIntro
    queue: []

Page.GuildIntro = class GuildIntro extends Page
  transition: 'wink'
  text: ->
    player = g?.player or Person.PlayerGuildF.prototype
    friend = g?.crew.GuildFriend or Person.James.prototype
    """<img src="game/content/scenes/cabin.jpg">
    <div class="well">
      <p>#{@q friend}Wakey wakey!</q> Someone pounds on the door, heavy thumps disturbing the early morning air. Morning... no, not morning. The light seeping around the heavy curtain seems closer in quality to afternoon. It lacks dawn's golden tint, a certain yellow quality...</p>
      #{@bq}Are you even in there,
        <input type="text" class="inline" value="#{player.name}" style="width: 6em; text-align: center;" title="Your Character's Name">? It's already noon!
      </blockquote>
      <p>#{@dropdown {f: 'She', m: 'He'}, player.gender} sits up, rubbing hands in eyes and trying to make sense of the world. It shouldn't be noon. It should still be early morning.</p>
      #{@bq player}Mhgph. I'm here. It can't be afternoon. Waking up is for morning. I'm waking up, it's morning.</blockquote>
      <p>The impeccible logic of the half asleep.</p>
      <p><em>Use the arrows on the side of the screen, a scroll wheel or your up/down keys to continue once you have a name and gender.</em></p>
    </div>"""
  apply: (element)->
    guildGame()
    g.last = @

    element.on 'leave-page', ->
      gender = element.find('input:checked').val()
      if gender is 'm'
        g.player = new Person.PlayerGuildM
        g.crew.GuildFriend = new Person.Tina
      g.player.name = element.find('input[type="text"]').val()

gi = Page.GuildIntro::next = Page.GuildIntro2 = class GuildIntro2 extends Page
  context:
    player: 'player'
    friend: 'crew|GuildFriend'
  text: ->"""<img src="game/content/scenes/cabin.jpg">
  <div class="well">
    #{@bq @friend}Never the less it is noon, sleepyhead. I'll be waiting on deck when you're ready.</blockquote>
    <p>Deck, yes. That is an exciting sound. It's why #{@player} was too nervous and excited to sleep last night, laying awake in bed, pacing the deck and generally being neither productive nor restful. The gentle roll of the floor beneath #{@her @player} feet reminds #{@player} that #{@she}'s now Captain.</p>
    <p>Captain #{@player}. That's a good sound too.</p>
  </div>"""

hairColor =
  silver: 'silver'
  ash: 'ash'
  raven: 'raven'
  chestnut: 'chestnut'
  fiery: 'fiery'
  copper: 'copper'
  strawberry: 'strawberry'
  amber: 'amber'
  green: 'green'
  'dark green': 'dark green'
  blue: 'blue'
  navy: 'navy'
  purple: 'purple'

eyeColor =
  'sky blue': 'Blue'
  green: 'Green'
  yellow: 'Yellow'
  brown: 'Brown'
  red: 'Red'

skinColor =
  ivory: 'ivory'
  pale: 'pale'
  light: 'fair'
  tanned: 'tanned'
  golden: 'golden'
  cinnamon: 'cinnamon'
  coffee: 'coffee'
  chocolate: 'chocolate'

Person.HSL =
  hair:
    silver: [0, -100, 20]
    ash: [20, -80, -20]
    raven: [0, -100, -40]
    chestnut: [5, -40, -25]
    fiery: false # default
    copper: [10, -15, 0]
    strawberry: [5, 10, 20]
    amber: [25, -20, 10]
    green: [80, 0, -20]
    'dark green': [80, 0, -50]
    blue: [-160, 0, 10]
    navy: [-140, -10, -20]
    purple: [-100, -40, 0]
  eyes:
    'sky blue': [80, 40, 0]
    green: false
    yellow: [-50, 40, 20]
    brown: [-80, -20, -20]
    red: [-100, 20, 0]
  skin:
    ivory: [0, -40, 20]
    pale: [0, -10, 20]
    light: false
    tanned: [-10, 20, -15]
    golden: [0, 30, -15]
    cinnamon: [-20, 10, -25]
    coffee: [-30, -10, -40]
    chocolate: [-30, 20, -60]

Game.setHSL = (element, person)->
  checked = $ 'input:checked', element
  for i, layer of ['hair', 'eyes', 'skin']
    color = checked.eq(i).val()
    if Person.HSL[layer][color]
      person.color[layer] = Person.HSL[layer][color]
    else
      # If there's no value, then it's the default color and we don't need to recolor that layer
      delete person.color[layer]

Page.GuildIntro2::next = Page.GuildIntro3 = class GuildIntro3 extends gi
  text: ->"""<img src="game/content/scenes/cabin.jpg">
  #{@player.image 'normal', 'med'}
  <div class="well">
    <p>Stumbling over to a mirror, #{@player} runs a hand through #{@her @player} hair, trying to bring some semblance of order to the #{@dropdown hairColor, 'fiery'} mess. #{@dropdown eyeColor, 'green'} eyes stare back. #{@She} slaps #{@her} cheeks, makes a face and turns away. Lots to do today. #{@Her} #{@dropdown skinColor, 'light'} hands are soft for now, but not for long. A life at sea and the hard physical labor of managing a ship will callus them soon enough.</p>
  </div>"""
  apply: (element)->
    element.find('input').change =>
      # Update each layer with a new HSL value
      Game.setHSL element, g.player

      # Now update the image (including invalidating the cache)
      $('.person', element).replaceWith @player.image 'normal', 'med', false

    element.on 'leave-page', ->
      if $('input:checked', element).eq(0).val() is 'fiery'
        g.crew.GuildFriend.color.hair = Person.HSL.hair.amber
      if $('input:checked', element).eq(2).val() is 'light'
        g.crew.GuildFriend.color.skin = Person.HSL.skin.tanned

Page.GuildIntro3::next = Page.GuildIntro4 = class GuildIntro4 extends gi
  text: -> """<img src="game/content/scenes/Vailia/Port.jpg">
  #{@friend.image 'normal'}
  <div class="well">
    <p>#{@friend} is waiting for #{@her @player} when #{@she} finally emerges, tapping #{@her @friend} foot impatiently.</p>
    #{@bq @friend}It's about time! Were you planning on sleeping all day? You have an appointment with Guildmaster Janos any minute now!</blockquote>
    <p>#{@friend} has been #{@player}'s friend for six years, and #{@she @player}'d be lost without #{@him @friend}. #{@player} has, however, learned that "right now," "immediately" and "this very second!" generally translate into "plenty of time." They're not running late until #{@she}'s actually vibrating with impatience.</p>
  </div>"""

Page.GuildIntro4::next = Page.GuildIntro5 = class GuildIntro5 extends gi
  text: ->"""<img src="game/content/scenes/Vailia/Port.jpg">
  #{@friend.image 'upset'}
  <div class="well">
    <p>#{@player} stops to admire #{@her @player} new ship from the docks. It still smells like fresh pine and pitch, the deck smooth and unworn. The Lapis Azurai, #{@she}'s named it, fresh out of Vailia's famous shipyards. It's the latest in naval technology - two main masts and a smaller forward sail, flat bottomed for exploring unfamiliar seas and rivers, wide enough to carry supplies for two full years for a normal crew - or a pretty penny in trade goods for shorter voyages. Vailia's shipwrights are the best in the world. The Lapis is one of the fastest ships ever built.</p>
    <p>Now #{@friend} is actually vibrating, tugging on #{@player}'s hand and stamping #{@her @friend} feet at every momentary delay. There will be plenty of time to admire the ship later. Time to get going.<p>
  </div>"""
  next: Page.Port

Job[vgm]::next = Page[vgm + 2] = class GuildIntroVisitGuildmaster2 extends gi
  text: ->"""<img src="game/content/locations/Vailia/Market Day.jpg">
  #{@player.image 'normal', 'right'}
  #{@friend.image 'normal', 'right-lead'}
  <div class="well">
    <p>Vailia's streets are a riot of color and excitement. #{@friend} keeps tugging at #{@player}'s hand, urging #{@her @player} to hurry through around crowds of visitors, around a crowd surrounding a pair of dancers, and down an alley to avoid a clump of congested traffic. Normally #{@she}'d drag #{@her} heels and at least stop to look at some of the stalls wafting enticing scents in their diroction, but #{@friend} is right. It wouldn't do to be late to meet with #{@her} investor, mentor and benefactor.</p>
  </div>"""

Page[vgm + 2]::next = Page[vgm + 3] = class GuildIntroVisitGuildmaster3 extends gi
  text: ->"""<img src="content/scenes/Vailia/Guild Hall.jpg">
  <div class="well center">
    <p>The Guild.</p>
  </div>"""

Page[vgm + 3]::next = Page[vgm + 4] = class GuildIntroVisitGuildmaster4 extends gi
  text: ->"""<img src="content/scenes/Vailia/Guild Hall.jpg">
  <div class="well">
    <p>#{@player} owes them everything - as a #{@girl @player} cleaning floors for the Guild was safer and better paid than working on #{@her} father's fishing boat. As a young #{@woman}, working at the front desk of a brothel was <em>much</em> better paid than waiting a bar. Another couple of years and #{@she}'d be expected to start "working" in earnest, but with her quick wit and smarts #{@she} convinced The Guild that #{@she} was too valuable to waste.</p>
    <p>Sidways on the career ladder, and up like a shooting star. Her meager savings combined with an invesment of twenty times that amount purchased the Azurai - #{@her} own ship. What they asked in return wasn't so much, really - honesty, hard work, a large comission on #{@her} profits, and an eternal friendly smile. The Guild is built on friendly smiles.</p>
  </div>"""

Page[vgm + 4]::next = Page[vgm + 5] = class GuildIntroVisitGuildmaster5 extends gi
  text: ->"""<img src="content/scenes/Vailia/Guild Hall.jpg">
  <div class="well">
    <p>#{@q @friend}Woolgather in the coutryside - the price is too high here to make a profit reselling,</q> #{@friend} pokes #{@her @player} in the ribs. #{@q @friend}I know Guildmaster Janos likes you, but let's not test his patience today.</q></p>
    <p>#{@she} leads #{@player} through the halls of the Guild headquarters. Woolgathering indeed - #{@player} doesn't even remembering passing through the font doors. #{@She @player} scratches the back of #{@her} head and follows sheepishly.</p>
  </div>"""

Page[vgm + 5]::next = Page[vgm + 6] = class GuildIntroVisitGuildmaster6 extends gi
  text: ->"""<img src="content/scenes/Vailia/Guild Office">
  <div class="well">
    <p>The Guildmaster is waiting alone in his office on the third floor, watching the city below. It's an impressive view form up here, not just the third floor, but from Uptown in general, perched as the richest part of the city is on a hill overlooking the rest of the city. Far in the distance #{@player} can just see the spires of the palace - the other center of power, sandwiching the populace between them. #{@She @player} has never had much to do with the palace, the king or the nobility - #{@her} focus has always been narrower and more focused.</p>
  </div>"""

gi2 = Page[vgm + 6]::next = Page[vgm + 7] = class GuildIntroVisitGuildmaster7 extends Page
  context:
    guildmaster: 'map|Vailia|people|Guildmaster'
    player: 'player'
    friend: 'crew|GuildFriend'
  text: ->"""<img src="content/scenes/Vailia/Guild Office.jpg">
  #{@guildmaster.image 'smiling', 'mid-left'}
  <div class="well">
    <p>Janos turns and gives a genial smile as #{@friend} quietly closes the door behind #{@her @friend} and #{@player}.</p>
    #{@bq @guildmaster}Thank you for coming. I'm sure you have far too much to do and are eager to get to it, but indulge an old man to share some advice for a few minutes.</blockquote>
    <p>#{@player} snaps to attention, listening attentively. Janos can call it indulgence all he wants, but he's one of the sharpest business minds in the known world, and any advice he cares to give should be well heeded. And the Guild is built on friendly smiles and soft words - there may very well be important orders cloaked in the form of polite suggestions.</p>
  </div>"""

Page[vgm + 7]::next = Page[vgm + 8] = class GuildIntroVisitGuildmaster8 extends gi2
  text: ->"""<img src="content/scenes/Vailia/Guild Office.jpg">
  #{@guildmaster.image 'normal', 'mid-left'}
  <div class="well">
    #{@bq @guildmaster}I will say only three things. Your ship is your life - risk one to save the other, but for no other cause. Use your connection with the Guild sparingly - we are not universally beloved, outside these city walls. And, finally, wash your face before you arrive at an important meeting.</blockquote>
    <p>He licks a finger and reaches out to rub a spot off #{@player}'s chin, as though #{@she @player} were no more than six years old and Janos #{@her} father. #{@friend} snickers in the background as #{@player} tries to melt through the floor in embarrassment.</p>
  </div>"""

Page[vgm + 8]::next = Page[vgm + 9] = class GuildIntroVisitGuildmaster9 extends gi2
  text: ->"""<img src="content/scenes/Vailia/Guild Office.jpg">
  #{@guildmaster.image 'skeptical', 'mid-left'}
  #{@player.image 'blush', 'mid-right mirror'}
  <div class="well">
    <p>#{@q @player}Yes sir, will do.</q> #{@player} wipes #{@her @player} face on #{@her} sleeve. Then, in a moment of abandon, #{@she} leans in and hugs Janos enthusiastically. The normally dignified Guildmaster turns the tables by continuing his appempt to wipe the smudge off #{@player}'s face. Shocked at #{@her} own boldness, #{@player} retreats back and blushes, repeating the act of cleaning #{@her} face on her sleeve. #{@q}Yes sir, will do.</q></p>
  </div>"""

# """<p>The rest of the day is something of a blur, filled with final papers to be filled out, letters to be written and double checking every item on a list of things to do - crew, supplies, tread goods, picking a new destination. Without #{@friend}'s guidance and assistance #{@player} would be completely lost - but the authority and risk both ultimately come back to rest on #{@her @player} shoulders. #{@friend} gets paid regardless of whether they make a profit on each trade run. </p>"""
#
# """#{@bq g.crew.GuildFriend}We have to do two things before we can set sail - hire the rest of the crew at the tavern and stock up on supplies and trade goods at the market. Hiring a crew first will let us shift more goods, so that ight be a good place to start. Or we could split up to cover more ground.</blockquote>"""

