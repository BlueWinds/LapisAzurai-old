Game::location = Place.VailiaIntro = class VailiaIntro extends Place
  images: Place.Vailia::images
  name: "Vailia"
  description: ->
    """<p class="intro-help">Your officers and crew are listed on the right of the page, and all the jobs they can perform are on the left. You can begin a day once all the officers have an assignment.</p>
    <p class="intro-help">Any time you see a colored number or word, you can hover over it (or tap on a touchscreen) for information. Hover over or double-tap on a person for more details about them. You can also hover over (double-tap) the Lapis Azurai logo for an overview of your current status and missions.</p>
    <div class="intro-main">#{Place.Vailia::description}</div>"""
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
  description: ->"""<p>Natalie talked to the bartender, passed over a coin for the trouble and set herself up at a table. It wasn't long before she had some interested recruits.</p>
  <p><em>Click on any of the recruits in the bar (the left column) you want to hire and then in the box holding your crew (on the right). You'll need at least two more crew to set sail, though more sailors make trips faster and can help with various events.</em></p>"""


Job.IntroSail = class IntroSail extends Job
  conditions:
    '|crew|length': {gte: 2}
    '|map|Ship|cargo|Barley': {gte: 10}
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
      description: "Buy provisions at the market (at least 10 barley)"
      conditions:
        '|map|Ship|cargo|Barley': {gte: 10}
  ]
  blockSailing: true


Job.IntroMarket = class IntroMarket extends Job.Market
  description: ->"""<p>Natalie wanders the marketplace, searching for bargains and opportunities. Maiden Tea is a good deal here, but there's not much available - the price will increase if she buys too much. Barley is normally priced, and there's a lot of it for sale. Wood is at a premium on a small island like Vailia, but the city does import a great deal of it to construct ships at a great pace.</p>
  <p><em>On the left is a list of goods you can buy at the market, and on the right a list of items in your ship's cargo hold. You already have the materials necessary to keep your ship in repair (Wood and Naval Supplies). You'll want to lay in a stock of provisions and some trade goods - try spending about 75β each on Barley and Maiden's Tea. It's better to have goods than money.</em></p>"""
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
