Place.MountJulia = Game::map.MountJulia = class MountJulia extends Place
  name: 'Mount Julia'
  description: "First stop on the trade routes that flow around the continent northward from Vailia, Mount Julia is an excellent natural harbor to shelter from storms, overlooked by an imposing mountain and ancient forest."
  images:
    day: 'game/content/locations/Wilds/Beach Day.jpg'
    night: 'game/content/locations/Wilds/Beach Night.jpg'
    storm: 'game/content/locations/Wilds/Beach Storm.jpg'
    marketDay: 'game/content/locations/Wilds/Beach Day.jpg'
    marketStorm: 'game/content/locations/Wilds/Beach Storm.jpg'
    tavern: Place.Vailia::images.tavern
  jobs: new Collection
  location: [3486, 1819]
  destinations: new Collection
    Vailia: 9

Job.MtJuliaCheckShip = class MtJuliaCheckShip extends Job
  type: 'plot'
  officers:
    'James': '|officers|James'
  crew: 2
  label: 'Check Ship'
  text: ->"""The Azurai shouldn't have taken any damage from such a minor voyage in calm weather, but it didn't hurt to check."""
  energy: -2

Mission.MtJuliaCheckShip = class MtJuliaCheckShip extends Mission
  label: "Check the Ship"
  tasks: [
      description: "James wants to check the ship for damage"
      conditions:
        '|events|MtJuliaCheckShip|length': {gt: 0}
  ]
  blockSailing: true
  removeWhenDone: true
  effects:
    remove:
      '|location|jobs|check': Job.MtJuliaCheckShip

Place.MountJulia::firstVisit = Page.VisitJulia = class VisitJulia extends Page
  conditions:
    'Nat': '|officers|Nat'
    'James': '|officers|James'
  text: ->
    sailor = Math.choice g.crew
    return """|| bg="MountJulia.day"
      -- Mount Julia loomed up out of the ocean, a jagged peak that had been growing on the horizon all day. If the current wind held steady, the Lapis would arrive just after midnight – enough time for everyone to rest and catch their breath before exploring the city in the morning. A week of sailing had settled the crew into a comfortable routine. #{g.crew[0]} preferred the night shift, watching the helm while the captain slept, and #{g.crew[1]} was a natural in the rigging, scurrying up and down the masts to adjust the lines.

    ||
      --> Though she could perhaps stand to hire a few more crew members to help get them through rough weather, the crew of #{g.crew.length.toWord()} was enough for now. The Azurai had been lucky so far, sailing in clear weather and steady wind - an auspicious beginning for a first voyage. Hopefully the trip home would be as smooth.

    || bg="Ship.deckDay"
      #{g.officers.Nat.image 'excited', 'left'}
      -- #{q}Tell James what you were telling me last night,</q> Natalie waved over #{sailor.name} and her Quartermaster. #{sailor.name} saluted the officers, bringing a smile to Natalie's face – she loved that feeling – and began again.

    ||
      #{sailor.image 'normal', 'right'}
      --> #{q}Mount Julia's not much more than a couple of warehouses, some wharves, and an inn. At least it was last time I sailed here, about two years ago. The area's too rugged to support any farming, but the natural harbor is such a good layover on the way out from Vailia that only idiots don't take the chance to top off supplies and rest a night on shore. Begging your pardon, ma'am,</q> #{sailor.name} repeated the salute.

    ||
      #{g.officers.Nat.image 'normal', 'left'}
      -- #{q}Don't worry, we'll be staying at least a day. Thank you,</q> Natalie waved #{him sailor} away. To James, #{q g.officers.Nat}I'm intending to sell our cargo here, rather than haul it further. Slim profit, but I want to take this first trip easy. We've been lucky with the weather. Let's not push it before we have a chance to debrief and hire more crew.</q>

    ||
      #{g.officers.James.image 'normal', 'right'}
      --> #{q}I'll get everything cleaned up and check over the ship while you find a buyer.</q> He nodded, glancing behind them at the cargo hold. Several items hadn't been secured properly in the haste to depart, and one cask of fresh water had sprung a leak from the banging around.

    ||
      #{g.officers.Nat.image 'normal', 'left'}
      -- #{q}Good. I hardly expect to make more on this trip than I've spent in supplies and wages, but it'll be worth it for a shakedown cruise. Let's not waste time.</q>
    """
  effects:
    add:
      '|missions|check': Mission.MtJuliaCheckShip
      '|location|jobs|check': Job.MtJuliaCheckShip

Place.MountJulia::jobs.market = Job.MtJuliaMarket = class MtJuliaMarket extends Job.Market
  buy: new Collection
    Barley: [10, 2]
    "Maiden's Tea": [15, 8]
    "Naval Supplies": [20, 0]
    Wood: [40, 5]
  sell: new Collection
    "Maiden's Tea": [15, 7]
    Barley: [5, 1]
    "Naval Supplies": [20, 0]
  description: ->"""As usual, the same little girl cheerfully greeted Natalie. She was happy to leave off sweeping her bar - "her parents' bar," she still insisted - and haggle over the value of the Lapis' goods. She had some items in stock, but was mostly interested in purchasing supplies for maintaining the trading post."""
  next: Page.firstMatch
  @next = [Page.Market]

Page.MtJuliaMarketIntro2 = class MtJuliaMarketIntro2 extends Page.Market
  show: ->
    element = super()
    element.help(
      target: '.sell .low'
      placement: 'bottom'
      title: "Items that are a better deal than Vailian prices - you can buy them cheaper or sell them for more - are marked green."
    ).help(
      target: '.buy .high'
      placement: 'bottom'
      title: "Items that are a worse deal - more expenisve to buy or sell for less than they would at home - are in red."
    )

    return element

Job.MtJuliaMarket.next.unshift Page.MtJuliaMarketIntro = class MtJuliaMarketIntro extends Page
  conditions:
    '|events|MtJuliaMarketIntro': false # Only show this the first time
    worker: {}
  text: ->"""|| bg="tavern"
    -- #{@worker} was surprised, walking in, to see a little girl tending the bar. Perhaps twelve, she smiled and greeted #{@worker} with a cheerful wave, not pausing in her current attempt to mop the floor into some state of cleanliness. Rather than spilled beer, though, her main enemy at the moment seemed to be leaves, seeds, and other detritus from the forest. It wasn't hard to understand why – other than the Azurai, there are no other ships docked in the bay.

  ||
    -- <q>What can I gettcha?</q>

  ||
    #{@worker.image 'normal', 'left'}
    --> #{q}Nothing right now, thank you. Where are your parents?</q>

  ||
    --> <q>Out back. But I can do anything ya'need. Don't be bothering 'em.</q>

  ||
    #{g.officers.Nat.image 'normal', 'left'}
    --> #{q}Well, I suppose. I have some #{Object.keys(g.cargo).sort((a, b)->Item[b].price - Item[a].price)[0]} I'd like to unload.</q>

  ||
    -- <q>Ooh, that's nice. Much more interesting'an watching you an' a buncha rowdy sailors get shitfaced.</q> She lay her broom aside with a grin, rubbing her hands together gleefully.

  ||
    --> <q>Easier to clean up after too. So, what'cha got?</q>
  """
  next: Page.MtJuliaMarketIntro2

Place.MountJulia::jobs.rest = Job.MtJuliaRest = class MtJuliaRest extends Job
  officers:
    worker: {}
    worker2: {optional: true}
    worker3: {optional: true}
  label: 'Rest'
  text: ->"""Visit the inn, Mt. Julia's one and only inhabited building."""
  energy: 3

Job.MtJuliaRest::next = Page.MtJuliaRest = class MtJuliaRest extends Page
  conditions:
    worker: {}
  text: ->"""|| bg="tavern"
    #{@worker.image 'normal', 'left'}
    -- #{q}So, what's your name?</q> #{@worker} asked the bartender – a cute little girl, perhaps twelve. She claimed to have parents around here somewhere, but #{@worker} hadn't seen or heard them yet.

  ||
    --> <q>Tasha. Tasha Julia, pleased ta'make yer acquaintance.</q> She stuck one hand out, and #{@worker} shook it. She had a strong grip for her size. Other than those from the Azurai, the inn was completely empty. It was of decent size, capable of seating several dozen patrons, and the second floor promised plenty of private rooms for those looking for time away from their ships.
  """

scavenge = (rate)->
  return {
    fill: -> Math.floor(Math.random() * g.last.context.length * rate) + 1
  }

Place.MountJulia::jobs.scavenge = Job.Scavenge = class Scavenge extends Job
  officers:
    worker: {}
  crew: 2
  label: 'Scavenge'
  text: ->"""Gather and prepare wood from Mt. Julia's abundant forests for use repairing the ship or sale. More sailors makes the work go faster."""
  energy: -3
  next: Page.firstMatch
  @next = []

Job.Scavenge.next.push Page.ScavengeStorm = class ScavengeStorm extends Page
  conditions:
    '|weather': {eq: 'storm'}
    worker: {}
    woodFound: scavenge(0.5)
  text: ->"""|| bg="day"
    -- Though venturing out into the storm was not a pleasant task, #{@worker} found that, once away from the shore, the forest at least did a tolerable job of cutting the wind. Less so the rain or the noise - by the time the crew was halfway done working on their first tree, they were soaked and shivering. #{@worker} called the expedition off short.

      <em>+#{@woodFound} wood</em>
  """
  effects:
    cargo:
      Wood: 'woodFound'

Job.Scavenge.next.push Page.ScavengeWood = class ScavengeWood extends ScavengeStorm
  conditions:
    '|season': {eq: 'Wood'}
    worker: {}
    woodFound: scavenge(2)
  text: ->"""|| bg="day"
    -- The woods around Mt. Julia were pleasant enough to wander around in the mild #{g.month} Wood weather. #{@worker} marked several of the straightest trees to donate their lives to the cause, and the crew quickly set to work chopping them down and stripping bark and branches. Heavy work, but the Azurai carried tools for exactly this task, and progress was quick.

      <em>+#{@woodFound} wood</em>
  """

Job.Scavenge.next.push Page.ScavengeFire = class ScavengeFire extends ScavengeStorm
  conditions:
    '|season': {eq: 'Fire'}
    worker: {}
    woodFound: scavenge(1.5)
  text: ->"""|| bg="day"
    -- Walking through the woods around Mt. Julia was a welcome respite from the heat of the #{g.month} Fire, cooled by a pleasant breeze blowing in from the ocean. #{@worker} found several trees knocked down by a recent storm, and the crew set to stripping them of bark and branches, and hauling them back to the beach for final work.

      <em>+#{@woodFound} wood</em>
  """

Job.Scavenge.next.push Page.ScavengeEarth = class ScavengeEarth extends ScavengeStorm
  conditions:
    '|season': {eq: 'Earth'}
    worker: {}
    woodFound: scavenge(2)
  text: ->"""|| bg="day"
    -- Mt. Julia's forested surroundings were an excellent source of timber, untamed and mostly unexploited by human hands. #{@worker} pointed out several trees to the crew, marking them for felling and cutting into the planks and boards needed to keep the ship in good repair.

      <em>+#{@woodFound} wood</em>
  """

Job.Scavenge.next.push Page.ScavengeWater = class ScavengeWater extends ScavengeStorm
  conditions:
    '|season': {eq: 'Water'}
    worker: {}
    woodFound: scavenge(1)
  text: ->"""|| bg="day"
    -- Pulling #{his @worker} cloak tighter around #{his} neck, #{@worker} explored the woods around Mt. Julia, leading a gaggle of the Azurai's crew. #{He} didn't wander far, choosing trees more on the basis of their proximity to the beach than pure quality. Once they set to work cutting down and cleaning the trees, the temperature was more bearable. Heavy labor made warm bodies.

      <em>+#{@woodFound} wood</em>
  """

Job.MtJuliaCheckShip::next = Page.MtJuliaCheckShip = class MtJuliaCheckShip extends Page
  conditions:
    James: {}
  text: ->"""|| bg="day"
    -- The Azurai shouldn't have taken any damage from such a minor voyage in calm weather, but it didn't hurt to check. James stripped down to his trunks – any issues would begin below the waterline on the outside of the hull long before they became visible to the occupants.

  ||
    #{@James.image 'blush', 'left'}
    --> The back of his neck burned as someone whistled behind him, but he refused to dignify the catcall with a glance. Let Natalie have her fun. Or one of the sailors, if they were so bold. He didn't really want to know who it was. Yes he did, actually, but he still wasn't going to turn his head to look.

  || bg="Ship.day"
    -- He dove over the rail, hitting the icy water with nary a splash. The ocean water stung his open eyes for a moment, but he spun around and began inspecting the hull for damage without surfacing. No child in Vailia avoided learning to swim – if not intentionally, then at least when older children threw you over a cliff into the ocean.

  || bg="Ship.deckDay"
    -- #{q}Nothing. We're clean.</q> James accepted the towel from #{Math.choice g.crew}, tussling it through his hair and rubbing the water off his back. No scrapes, no barnacles yet, no leaks.  The Guild hadn't skimped in giving Natalie a good vessel. The Lapis Azurai was a solid ship, straight out of the Vailian shipyards, not some rickety junk from Kantis. If there were ships anywhere in the world to match Vailian ones, even rumor hadn't reached James' ears.
  """
