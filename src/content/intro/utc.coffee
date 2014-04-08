Person.PlayerUTCf = class PlayerUTCf extends Person.PlayerGuildF
  business: 20
  diplomacy: 10
  stealth: 10
  combat: 0
  happiness: 100
  endurance: 6
  level: 1


Person.PlayerUTCm = class PlayerUTCm extends Person.PlayerGuildM
  business: 20
  diplomacy: 10
  stealth: 10
  combat: 0
  happiness: 100
  endurance: 6
  level: 1


utcGame = ->
  window.g = new Game
    day: 0
    player: new Person.PlayerUTCf
    location: new Place.Kantis
    queue: []

Page.UTCintro = class UTCintro extends Page
  transition: 'wink'
  text: ->"""<img src="game/content/scenes/cabin.jpg">
  <div class="well">
    <p>It is finally time. The Lapis Azulai is ready to set sail.</p>
    <p><input type="text" class="inline" value="#{g.player or 'Natalie'}" style="width: 6em; text-align: center;" title="Your Character's Name"> bought the battered hull at auction for a tenth the price of a full ship, and it still nearly bankrupted #{@dropdown {f: 'her', m: 'him'}, (g.player?.gender or 'f')}.</p>
    <p>Then a month of fighting off competitors offering - and refusing to take no for an answer - six months of back-breaking labor restoring the vessel to seaworthiness, and another month of working like a slave to raise money for a crew, provisions and a modest stock of goods.</p>
    <p>It was worth it. The Lapis is a Vailian hull - sunk, dragged up from the depths by a storm, set on fire and then refitted, it's <em>still</em> the fastest ship in the sea. People swear Vailian ships are magic when they see them racing the wind itself, but they're not. Caravels like these are simply the finest ships in the world. Even the Universal Trading Concern's wealth can buy only a handful of ships like this from Vailia, three thousand miles to the south and west.</p>
  </div>"""
  apply: (element)->
    utcGame()
    g.last = @

    element.on 'leave-page', ->
      gender = element.find('input:checked').val()
      if gender is 'm'
        g.player = new Person.PlayerUTCm
      g.player.name = element.find('input[type="text"]').val()

Page.UTCintro::next = Page.UTCintro2 = class UTCintro2 extends Page
  context:
    player: 'player'
  text: ->"""<img src="game/content/scenes/Kantis/Port.jpg">
  #{@player.image 'normal', 'med'}
  <div class="well">
    <p>Stepping out onto the deck, #{@player} grins and slaps #{@her @player} thighs. #{@She}'s lucky. Happy, healthy, young, free of debt and captain of #{@her} own ship. It's a good day to be alive. Running a #{@dropdown Person.skinColor, 'tanned'} hand through #{@her} #{@dropdown Person.hairColor, 'fiery'} hair, #{@she} scans the horizon - some clouds to the south, but nothing serious brewing. #{@Her} sharp #{@dropdown Person.eyeColor, 'green'} eyes light on the helm - the wheel #{@she} polished with loving care, but hasn't had a chance to use yet. Soon.</p>
    <p>First #{@she} needs a crew and a cargo - Kantis, city of #{@her} birth, is a fine place to find both.</p>
  </div>"""
  apply: (element)->

    element.find('input').change =>
      # Update each layer with a new HSL value
      Game.setHSL element, @player
      # Now update the image (including invalidating the cache)
      $('.person', element).replaceWith @player.image 'normal', 'med', false
      return

  next: Page.Port
