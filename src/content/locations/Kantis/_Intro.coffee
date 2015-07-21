Place.Vailia::jobs.visitKantis = Job.VisitKantis = class VisitKantis extends Job
  label: "Meet with Guildmaster"
  type: 'plot'
  text: ->"<q>Guildmaster Janos requests that you visit him this afternoon at 14:00,</q> the courier announces to Natalie as she steps off the ship. He's been waiting for her, apparently all morning."
  energy: -2
  officers:
    Natalie: '|officers|Nat'
  conditions:
    '|events|NonkeniaDiplomats2': {}
    '|events|VisitTomenoi': {}
    '|officers|Kat': {}

Job.VisitKantis::next = Page.VisitKantis = class VisitKantis extends Page
  conditions:
    Nat: '|officers|Nat'
    Guildmaster: '|people|Guildmaster'
  text: ->"""|| bg="marketDay|marketStorm"
    -- Natalie grinned and waved at the young man at the front desk, but didn't stop – no time to chat. Without James here to tug at her wrist she was running rather late, despite having given herself plenty of time to arrive. She hurried along the familiar corridors towards Janos' office.

  || bg="guildOffice"
    -- She hesitated at his door - voices inside. She knocked smartly. The voices paused a moment, then resumed. Apparently he meant to finish whatever business he was attending before inviting her in. Natalie sighed and went over to a window. The view was impressive, looking down over the city. The Lapis was just barely visible from here. She tapped her foot on the polished wood floor, ran her finger along the windowsill (not as spotless as she'd kept it, when cleaning this hall had been her job), and waited.

  ||
    -- Ten minutes later the door opened, and a weary looking Guildmaster held it for his guests. A stern looking older woman nodded as Natalie as she brushed past, decked in a foreign and formal dress. Janos' knuckles whitened on the doorframe, and he didn't so much as glance at Natalie as he watched the woman move sedately down the long hallway.

  ||
    #{@Guildmaster.skeptical 'right'}
    -- Finally, once she had turned out of sight he nodded to Natalie, and gestured with one hand for her to enter. While she made herself comfortable in her usual chair, he sat down behind the desk with a sigh.

  ||
    #{@Guildmaster.serious 'right'}
    --> #{q}Don't get old, Natalie. Or at least retire when you do.</q> He massaged his temples with one hand.

  ||
    #{@Nat.happy 'left'}
    --> #{q}Any time you want to feel young again, there's dozens of women just downstairs who'd be happy to help. Not me though, I don't like geezers,</q> she stuck out her tongue.

  ||
    #{@Guildmaster.normal 'right'}
    -- He laughed and leaned across to ruffle her hair.

  ||
    #{@Guildmaster.normal 'right'}
    --> #{q}You always know the right thing to say. I miss Wend sometimes, and now with you gone... none of the other Children have quite the same spark. I'm going to become boring.</q> He slapped his hands on the desk, wiping the happy expression off his face, business-like demeanor returning. #{q}I hear you have returned from Tomenoi.</q>
"""

Mission.VisitKantis = class VisitKantis extends Mission
  label: "Visit Kantis"
  tasks: [
      description: "Note: This mission isn't implemented yet, don't spend too much time looking. :)"
    ,
      description: "Find a route to Kantis"
      conditions:
        '|events|KantisRoute': {}
    ,
      description: "Visit Saottica"
      conditions:
        '|events|SaotticaArrive': {}
    ,
      description: "Deliver the Guildmaster's letter"
      conditions:
        '|events|KantisGuildmasterDelivery': {}
  ]
  removeWhenDone: true

Page.VisitKantis::next = Page.VisitKantis2 = class VisitKantis2 extends Page
  conditions:
    Nat: {}
    Guildmaster: {}
  text: ->"""|| bg="guildOffice"
    #{@Nat.normal 'left'}
    -- Though she wanted more than anything to ask who the woman was – she had looked more Kantian than anything – Natalie restrained her curiosity and nodded, leaning back in her seat on crossing her knees. #{q}Tomenoi, yes sir. Would you like me to tell you about it?</q> She had guessed his intentions correctly, and he nodded. #{q}It was dirty, dusty, small, closely packed. Huddled, you might say. But well-made – no signs of neglect, and the woodworking was all first-rate. Odd that they made everything out of wood, when the island was so barren.</q>

  ||
    #{@Guildmaster.thinking 'right'}
    -- #{q}Kantis is not heavily forested, so wood is a luxury. Tomenoi is a statement of wealth, placed on our doorstep. The wood also symbolizes impermanence, openness to change.</q>

  ||
    #{@Nat.uncertain 'left'}
    --> Natalie pondered his words, nodded. It fit with what she'd felt from the people there. Everyone seemed worried that the floor was going to drop out from under them. It hadn't been an entirely pleasant. #{q}Is there anything in specific you'd like to know?</q>

  ||
    #{@Guildmaster.thinking 'right'}
    -- He grilled her briefly on the prices of various goods, quantities and qualities that she'd seen for sale. It was amazing the way he seemed to soak up information, fitting new facts into some sort of masterful puzzle only he could see. Finally, he gestured her to silence while he pondered the way the pieces fell together.

  ||
    #{@Guildmaster.serious 'right'}
    --> #{q}I will prepare a letter tonight, and have it sent to your ship. Please deliver it to Saottica. One of Kantis' outlying ports.</q>

  ||
    #{@Nat.happy 'left'}
    --> She sat up straight, grinned, uncrossed her legs. #{q}Aye aye sir!</q>

  ||
    #{@Guildmaster.normal 'right'}
    --> #{q}Stop it, you're making me feel old again,</q> he grumbled, but his smile said the opposite of his words.

  ||
    #{@Nat.normal 'left'}
    -- Natalie stood and saluted, garnering another grumble, and turned to leave.

  ||
    #{@Guildmaster.normal 'right'}
    --> #{q}Take some of our steel with you. The price in Kantis won't disappoint.</q> Though it seemed an afterthought, the delivery was too timely and smooth. The advice was, she could guess, to be her means of payment for the mission.

  ||
    #{@Nat.happy 'left'}
    --> #{q}Aye aye sir!</q> She saluted again, and danced out before he could object.

  ||
    #{@Nat.happy 'left'}
    --> <em>New mission: <strong>Visit Kantis</strong></em>
  """
  effects:
    remove:
      '|location|jobs|visitKantis': Job.VisitKantis
    add:
      '|missions|kantisRoute': Mission.VisitKantis

# Job.KantisRoute = class KantisRoute extends Job
#   label: "Meet with Guildmaster"
#   text: ->"#{q}Guildmaster Janos requests that you visit him this afternoon at 14:00,</q> the courier announces to Natalie as she steps off the ship. He's been waiting for her, apparently all morning."
#   energy: -2
#   officers:
#     Natalie: '|officers|Nat'
#   conditions:
#     '|events|NonkeniaDiplomats2': {}
#     '|events|VisitTomenoi': {}
#     '|officers|Kat': {}

Page.Library.next.push Page.VisitKantisLibrary = class VisitKantisLibrary extends Page
  conditions:
    worker: {}
    '|events|VisitKantis': {}
    '|events|VisitKantisLibrary': false
  text: ->"""|| bg="marketDay|marketStorm"
    -- After a whole day of frustrating searching, #{@worker} finally had to face the facts: there simply wasn't a chart of Kantis to be found in the university library. Tomenoi, yes, but an arrow pointing to the north west labeled "Kantis" at the edge of the map simply wasn't enough to find something their way to anything other than a messy end.

  ||
    --> The best bet is probably going to Tomenoi and learning the route from someone there. Plenty of Kantian ships there, and Vailian captains who know the route as well.
  """
  next: Page.firstNew
  @next = []
