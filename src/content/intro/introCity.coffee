Page.PortIntro = class PortIntro extends Page.Port
  text: ->
    element = super()

    # First visit
    unless g.events.IntroVisitGuildmaster
      element.help(
        target: '.crew'
        placement: 'bottom'
        title: "Your officers are listed in the right column."
      ).help(
        target: '.jobs'
        placement: 'bottom'
        title: "And any jobs they can do on the left. Click a person to select them, then inside a job to assign them to it."
      ).help(
        target: '.job-officers li'
        placement: 'right'
        title: "Each job has a cost in energy. If a character is too tired for that task, you can't assign them to it."
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
          title: "You were just given a mission. You can review your current status and goals any time by hovering over or double-clicking here."
        )
        element.help(
          target: '.list-group-item:eq(1)'
          placement: 'bottom'
          title: "You'll need to hire a crew first, at least three additional people before you can set sail."
        )
      else unless g.cargo.Fish >= 25
        element.help(
          target: '.list-group-item:eq(2)'
          placement: 'bottom'
          title: "Once you have a crew, head over to the market. The more people you bring with you the more goods you can load onto the ship. For now, just bring everyone."
        )
        $('.list-group-item:eq(2)', element).click ->
          element.help(
            target: '.active .job-crew'
            placement: 'bottom'
            title: "Some jobs allow you to send any number of workers along with the necessary officers. Both sailors and officers can fill these slots, and they don't require any energy."
          )
          element.help(
            target: '.active .job-crew'
            placement: 'bottom'
            title: "You can double-click on a job to assign everyone (without another job already chosen) to it and save some clicking."
          )

    return element

Game::location = Place.VailiaIntro = class VailiaIntro extends Place
  images: Place.Vailia::images
  name: "Vailia"
  description:
    text = Place.Vailia::description
  jobs: new Collection
    beach: Place.Vailia::jobs.beach
  destinations: Place.Vailia::destinations
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
        title: "To hire a sailor, click on them once to select and then click again in the \"crew\" area on the right."
      ).help(
        target: '.person-info'
        placement: 'bottom'
        title: "Your crew's abilities are useful in various events, especially sailing (if you get caught in a storm) and combat (if you end up in a fight). Any event where a skill is used will mention it in the description."
      ).help(
        target: '.person-info'
        placement: 'bottom'
        title: "Different sailors are looking for different length contracts. When a person's contract expires, they'll leave your crew next time you visit Vailia - and give you a permanent bonus. The higher their stats, the better the bonus."
      ).help(
        target: '.hires'
        placement: 'bottom'
        title: "Each day new people will arrive and others leave. Come back again later if you need to hire more sailors or don't like the look of some of them."
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
  description: ->"""Natalie wanders the marketplace, searching for bargains and opportunities. Maiden Tea is a good deal here, but there's not much available. The price will increase if she buys too much. Wood is at a premium on a small island like Vailia, even though the city imports a great deal of it to construct ships."""
  buy: new Collection
    Fish: [50, 0]
    Barley: [50, 0]
    "Maiden's Tea": [12, 0]
    Wood: [40, 0]
    "Naval Supplies": [20, 0]
    "Beer": [15, 0]
  sell: new Collection
    Wood: [15, 0]

Job.IntroMarket::next = Page.IntroMarket = class IntroMarket extends Page.Market
  text: ->
    element = super()

    unless g.cargo.Fish?
      title = $('[item="Maiden\'s Tea"] td', element).eq(1).attr('title')
      title = title.match(/([0-9]+).+?([0-9]+)/)
      amount = parseInt(title[1], 10)
      cost = Item["Maiden's Tea"].price
      element.help(
        target: '.carry'
        placement: 'bottom'
        title: "The amount you can load or unload from the ship depends on how many workers you bring, and on the weather. Outdoor work slows to a crawl during storms."
      ).help(
        target: '.progress'
        placement: 'bottom'
        title: "The Lapis Azurai can hold #{Game.cargo} crates. Balancing provisions and supplies vs. trade goods to make a profit is an important judgement."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "The price of each item will increase as you buy more of it. For example, you can buy #{amount} baskets of tea here at #{cost}β, then #{amount} more at +10%, etc."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "The price resets each day, so you can get a better deal by splitting a major purchase across multiple days."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "Goods come in three varieties - <span class='food'>Food</span>, <span class='trade'>Trade Goods</span>, and <span class='luxury'>Luxuries</span>."
      ).help(
        target: '[item="Maiden\'s Tea"]'
        placement: 'bottom'
        title: "<span class='trade'>Trade goods</span> are valuable (to you) only for how much money you can sell them for elsewhere."
      ).help(
        target: '[item="Beer"]'
        placement: 'bottom'
        title: "Your crew's happiness will drop slowly over time unless you carry a supply of <span class='luxury'>luxuries</span> for them."
      ).help(
        target: '[item="Fish"]'
        placement: 'bottom'
        title: "You'll need <span class='food'>food</span> before you set sail for obvious reasons."
      ).help(
        target: '[item="Fish"]'
        placement: 'bottom'
        title: "For now just get at least 25 barrels of fish and 30 baskets of Maiden's Tea."
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

oldShow = Page.SetSail::text
Page.SetSail::text = ->
  element = oldShow.call @
  if g.map.MountJulia.arrive
    return element

  element.help(
    target: '.location[data-key=""]'
    placement: 'bottom'
    title: "You're currently in Vailia. You can hover over it (or double click) and click the image to return to the port."
  ).help(
    target: '.location[data-key="MountJulia"]'
    placement: 'bottom'
    title: "When you're ready to set sail, hover over Mount Julia and click the image."
  )
  return element
