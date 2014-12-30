Page.PortIntro = class PortIntro extends Page.Port
  text: ->
    element = super()
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
    return element

Game::location = Place.VailiaIntro = class VailiaIntro extends Place
  images: Place.Vailia::images
  name: "Vailia"
  description:
    text = Place.Vailia::description
  jobs: new Collection
  destinations: new Collection
  location: Place.Vailia::location


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


Job.IntroHire = class IntroHire extends Job.VailiaHireCrew
  description: ->
    text = super()


Job.IntroSail = class IntroSail extends Job
  conditions:
    '|crew|length': {gte: 2}
    '|map|Ship|cargo|Barley': {gte: 20}
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
      description: "Hire at least two crew members"
      conditions:
        '|crew|length': {gte: 2}
    ,
      description: "Buy provisions at the market (at least 20 barley)"
      conditions:
        '|map|Ship|cargo|Barley': {gte: 20}
  ]
  blockSailing: true


Job.IntroMarket = class IntroMarket extends Job.Market
  description: ->"""<p>Natalie wanders the marketplace, searching for bargains and opportunities. Maiden Tea is a good deal here, but there's not much available - the price will increase if she buys too much. Barley is normally priced, and there's a lot of it for sale. Wood is at a premium on a small island like Vailia, but the city does import a great deal of it to construct ships at a great pace.</p>"""
  buy: new Collection
    Barley: [50, 4]
    MaidenTea: [5, 8]
    Wood: [40, 6]
    NavalSupplies: [20, 6]
  sell: new Collection
    Wood: [15, 4]


Mission.MeetGuildmaster = class MeetGuildmaster extends Mission
  label: "Meet with Guildmaster"
  tasks: [
      description: "Natalie and James need to meet with Guildmaster Janos"
      conditions:
        '|events|IntroVisitGuildmaster|length': {gt: 0}
  ]
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
      NavalSupplies: 10
