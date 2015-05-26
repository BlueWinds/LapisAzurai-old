Place.Ship::jobs.spirit = ShipJob.Spirit = class Spirit extends ShipJob
  label: "Something Strange"
  type: 'plot'
  conditions:
    chance:
      matches: -> return Math.random() <= 0.1
      optional: true
    '|events|FirstStorm': {}
  text: ->"""Something in the air feels different this morning..."""
  next: Page.randomMatch
  @next: []

ShipJob.Spirit.next.push Page.SpiritFog = class SpiritFog extends Page
  conditions:
    Nat: '|officers|Nat'
    James: '|officers|James'
  text: ->"""|| bg="Ship.deckFog"
    -- A grey fog descended over the ship in the night and, by the time anyone thought to wake Natalie, the Lapis was becalmed in dim water. The lightlessness dragged at spirits and numbing thoughts.

  ||
    #{@Nat.image 'serious', 'center'}
    --> Natalie looked around at the crew - lethargic, barely staying awake. It was unnatural the way they dragged at their tasks, when every nerve in her screamed that something was wrong. #{if g.officers.Asara then "Only Asara seemed alert, tense and silent. Nothing unusual there." else ""}

  ||
    #{@Nat.image 'serious', 'center'}
    --> Drooping sails and silent waves suggested that the Lapis wasn't going anywhere soon. Haranging enthusiasm into them seemed useless. There was magic at work.

  ||
    -- #{q}Come out, come out!</q> Her voice echoed, as though the world itself were small.

  ||
    --> No response. Time to do things the hard way then, if whatever was causing this didn't want to talk.

  ||
    --> She dug her mind down, bracing against the ship, and <i>pushed</i>. The mist obeyed only reluctantly, begrudgingly stirring and swirling around them. While holding the ship together in a storm felt like holding a tiger by the tail, this felt like pulling on a stubborn mule. It didn't want to obey.

  ||
    -- The mist slowed in its stirring. She pushed harder, headache growing, but like a mill grinding to a halt, some greater force resisted and canceled her magic, stilling the small wind she'd managed to summon.

  || slow="true"
    --> Silence.

  ||
    --| <q>You are a feisty one.</q> Natalie jumped at the voice hissing from both a thousand miles away and right next to her ear.

  ||
    --> #{q @Nat}You stopped my ship and bewitched my crew. Feisty doesn't even begin to cover it.</q> She poked #{Math.choice g.crew} who was standing motionless, drooling slightly. #{q @Natalie}Please explain.</q>

  ||
    --><q>I explain NOTHING.</q> The hissing voice rose in volume with each word, until the final "nothing" made Natalie clutch at her ears.

  ||
    --> Immediately the sense of presence disappeared, the fog began to dissolve, and the people around her stirred. She sunk to her knees, still clutching her head.

  ||
    --> James staggered woozily to her side. #{q @James}What happened? I heard some wind, and...</q> he raised a hand to touch her shoulder, lowered it again.

  ||
    --> #{q @Nat}I don't know. A spirit. A ghost. A god. I think... I think it was scared of me?</q> She shook her head helplessly. #{q}It's gone.</q>
  """

ShipJob.Spirit.next.push Page.SpiritFish = class SpiritFish extends Page
  conditions:
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.deckDay"
    #{@Nat.image 'excited', 'center'}
    -- #{q}Nets out! Lower the sails. #{Math.choice g.crew}, get everyone on deck. We're going fishing!</q> Sailors scrambled to obey their excited captain as the water around them churned and boiled with fish. For a dozen yards in every direction the water was silver with the glint of scales, a school as large and hungry as Natalie had ever seen. If they'd been properly equipped as a fishing vessel they'd be able to make a month's catch in just a few hours, but even so she couldn't resist the chance to stock up their larder.

  ||
    --> They had only to drop a net overboard before it was full, then pull it aboard to fill a barrel with the flopping, squirming take. They set up a line - catch, behead, scale, gut, drop in a barrel and sprinkle salt over the top.

  ||
    --| They had half a dozen barrels filled when the screaming started. Two massive tentacles, thick as tree trunks, wrapped over the sides of the Lapis, flailing around until they found #{Math.choice g.crew} and James, wrapping around their waists and pulling them off the deck. Dangling a hundred feet over the ocean still surging with fish, their struggles were of no avail against... whatever.

  ||
    --> Before anyone could gather weapons, or even formulate a coherent response to the sudden invasion by the oddly non-destructive tentacles (they hadn't even knocked anything over in their questing), the monster's body rose out of the water. A giant face, a wise old man hoary with age, but green and dripping with sea water stared back at them.

  ||
    --> <q>Why are you hurting my friends?</q> It rumbled in a deep masculine voice, a frown rippling across its giant brow.

  ||
    --> Natalie looked up at James and her sailor, hanging there, unharmed but clearly held hostage. They'd stopped struggling - being dropped would be worse than their current situation. Despite that, she felt no hostility from the creature, merely sadness. Sadness, and an overwhelming ability to destroy her ship and everyone on it. #{q @Nat}Sorry?</q> she ventured.

  ||
    --> <q>Why?</q> The creature almost sounded like it was whining.

  ||
    --| #{q}Um... we didn't know they were your friends. We'll stop? Please set my people down?</q>

  ||
    --> The giant-octopus / old-man / ocean-spirit let out a weary sigh, sufficient even from a hundred yards to briefly puff the Lapis' sails, and lowered the crew back to the deck. <q>You hurt them.</q>

  ||
    --> #{q}I'm very, very sorry. May we please depart? We promise to do no more harm here.</q> At her gesture the rest of the crew quietly cut away the net they'd had raised halfway out of the water when the monster appeared, dropping its still squirming contents back into the ocean.

  ||
    --> <q>Whyyyy...</q> The old man's face slowly slid back into the water almost without a ripple.

  ||
    --> #{q}Let's... let's not stick around waiting for him to change his mind. Everyone, full speed.</q> Suddenly exhausted, Natalie slumped against the ship's wheel. #{q}Fuck.</q>

  ||
    --> <em>+4 barels of fish</em>
  """
  effects:
    cargo:
      Fish: 4
