Page.PortIntro = class PortIntro extends Page.Port
  text: ->
    element = super()

    # First visit
    unless g.events.IntroVisitGuildmaster
      element.help(
        target: '.crew'
        placement: 'bottom'
        title: "Your officers are listed in the left column."
      ).help(
        target: '.jobs'
        placement: 'bottom'
        title: "And any jobs they can do on the right."
      ).help(
        target: '.worker-requirements'
        placement: 'bottom'
        title: "Each job requires a minimum amount of energy - if a character is too tired for that task, you can't assign them to it."
      ).help(
        target: 'options'
        title: "You can start the day once each officer has a task."
      )

      $('.job', element).click ->
        if $('.ready', element).length
          $('page.active').help(
            target: '.ready'
            placement: 'bottom'
            title: "Notice how the job has turned green since all its requirements are met."
          )

    # Second+ Visits
    if g.events.IntroVisitGuildmaster
      if g.crew.length < 3
        element.help(
          target: $('.navbar-brand')
          placement: 'bottom'
          title: "You were just given a mission - you can review your current status and goals, any time by hovering over or double-clicking here."
        )
        element.help(
          target: '.list-group-item.active'
          placement: 'bottom'
          title: "You'll need to hire a crew first, at least three additional people before you can set sail."
        )
      else unless g.cargo.Fish >= 25
        element.help(
          target: '.list-group-item:not(.active)'
          placement: 'bottom'
          title: "Once you have a crew, head over to the market. The more people you bring with you the more goods you can load onto the ship. For now, just bring everyone."
        )
        $('.list-group-item:not(.active)', element).click ->
          element.help(
            target: '.active .job-crew'
            placement: 'bottom'
            title: "Some jobs allow you to send any number of workers along with the necessary officers. Both sailors and officers can fill these slots, and they don't require any energy (since the crew doesn't have energy anyway)."
          )

    return element

Game::location = Place.VailiaIntro = class VailiaIntro extends Place
  images: Place.Vailia::images
  name: "Vailia"
  description:
    text = Place.Vailia::description
  jobs: new Collection
  destinations: new Collection
  location: Place.Vailia::location
  @port: Page.PortIntro


Job.IntroVisitGuildmaster = class IntroVisitGuildmaster extends Job
  label: "Visit Guildmaster"
  type: 'plot'
  text: ->"Guildmaster Janos would like to speak with Natalie before she leaves."
  conditions:
    Guildmaster: '|people|Guildmaster'
  officers:
    Nat: '|officers|Nat'
    James: '|officers|James'
  energy: -1

Page.IntroHire = class IntroHire extends Page.HireCrew
  text: ->
    element = super()

    if g.crew.length < 3
      element.help(
        target: '.hires .person-info'
        placement: 'bottom'
        title: "To hire a sailor, click on them and then again in the \"crew\" area."
      ).help(
        target: '.hires'
        placement: 'bottom'
        title: "Each day new people will arrive and others leave - come back again later if you need to hire more sailors or don't like the look of some of them."
      )
    return element

Job.IntroHire = class IntroHire extends Job.VailiaHireCrew
  next: Page.IntroHire

Job.IntroSail = class IntroSail extends Job
  conditions:
    '|crew|length': {gte: 3}
    '|cargo|Fish': {gte: 25}
  label: "Ready to Sail"
  type: 'plot'
  text: ->"With cargo and crew, the Lapis Azurai is ready to set forth on its maiden voyage. But first, James wants to discuss something."
  officers:
    Nat: '|officers|Nat'
    James: '|officers|James'
  energy: 0


Mission.CrewCargo = class CrewCargo extends Mission
  label: "Prepare to set sail"
  tasks: [
      description: "Hire at least three crew members"
      conditions:
        '|crew|length': {gte: 3}
    ,
      description: "Buy provisions at the market (at least 25 barrels of fish)"
      conditions:
        '|cargo|Fish': {gte: 25}
  ]
  blockSailing: true


Job.IntroMarket = class IntroMarket extends Job.Market
  description: ->"""<p>Natalie wanders the marketplace, searching for bargains and opportunities. Maiden Tea is a good deal here, but there's not much available - the price will increase if she buys too much. Wood is at a premium on a small island like Vailia, but the city does import a great deal of it to construct ships.</p>"""
  buy: new Collection
    Fish: [50, 3]
    Barley: [50, 4]
    "Maiden's Tea": [12, 8]
    Wood: [40, 6]
    "Naval Supplies": [20, 6]
  sell: new Collection
    Wood: [15, 4]

Job.IntroMarket::next = Page.IntroMarket = class IntroMarket extends Page.Market
  text: ->
    element = super()

    unless g.cargo.Fish?
      title = $('[item="Maiden\'s Tea"] td', element).eq(1).attr('title')
      title = title.match(/([0-9]+).+?([0-9]+)/)
      amount = parseInt(title[1], 10)
      cost = parseInt(title[2], 10)
      element.help(
        target: '.carry'
        placement: 'bottom'
        title: "The amount you can load or unload from the ship depends on how many workers you bring - and on the weather. Most outdoor work slows to a crawl during storms."
      ).help(
        target: '.progress-label'
        placement: 'bottom'
        title: "The Lapis Azurai can hold #{Game.cargo} crates - you won't have enough money to fill it right now, but balancing provisions and supplies to vs. trade goods to make a profit is an important judgement."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "The price of each item will increase as you buy more of it. For example, you can buy #{amount} baskets of tea here at #{cost}β, then #{amount} more at #{cost + 1}β, etc."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "The price resets each day, so you can get a better deal by splitting a major purchase across multiple days."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "For now, be sure to get at least 25 barrels of fish, and enough baskets of Maiden's Tea that the price turns white."
      )

    return element

Mission.MeetGuildmaster = class MeetGuildmaster extends Mission
  label: "Meet with Guildmaster"
  tasks: [
      description: "Natalie and James need to meet with Guildmaster Janos"
      conditions:
        '|events|IntroVisitGuildmaster|length': {gt: 0}
  ]
  removeWhenDone: true
  blockSailing: true
  effects:
    add:
      '|location|jobs|hire': Job.IntroHire
      '|location|jobs|market': Job.IntroMarket
      '|missions|crewCargo': Mission.CrewCargo
      '|location|jobs|sail': Job.IntroSail
    remove:
      '|location|jobs|visit': Job.IntroVisitGuildmaster
    cargo:
      Wood: 20
      'Naval Supplies': 10
