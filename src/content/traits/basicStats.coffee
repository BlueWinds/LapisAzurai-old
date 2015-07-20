Trait.RenewContract = class RenewContract extends Trait
  description: (person)->"#{person} has renegotiated #{his} contract. #{He} is paid 50% more."
  wages: 1.5

Trait.Content = class Content extends Trait
  description: (person)->"#{person} works for reasons other than money. #{He} takes no wage."
  wages: 0

Trait.Stoic = class Stoic extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> changes half as fast."
  happinessSet: 0.5

Trait.Disloyal = class Disloyal extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> decreases twice as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 2
    return delta

Trait.Spendthrift = class Spendthrift extends Trait
  description: (person)->"#{person}'s <span class='business'>business</span> increases only half as fast."
  businessSet: 0.5

Trait.Queasy = class Queasy extends Trait
  description: (person)->"#{person}'s <span class='sailing'>sailing</span> increases only half as fast."
  sailingSet: 0.5

Trait.Weak = class Weak extends Trait
  description: (person)->"#{person}'s <span class='combat'>combat</span> increases only half as fast."
  combatSet: 0.5

# Random for sailors =======================

Trait.Loyal = class Loyal extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> decreases only half as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 0.5
    return delta
  @randomPoints: 5
  @opposed: ['Excitable']

Trait.Excitable = class Excitable extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> changes twice as fast."
  happinessSet: 2
  @randomPoints: 0
  @opposed: ['Loyal']

Trait.Friendly = class Friendly extends Trait
  description: (person)->"#{person} adds <span class='happiness'>0.2 happiness</span> daily to any sailor (other than #{him}self) below <span class='happiness'>25</span>."
  daily: (person)->
    for i, sailor of g.crew when sailor.happiness < 25 and sailor isnt person
      sailor.add 'happiness', 0.2
  @randomPoints: 5

Trait.Slut = class Slut extends Trait
  label: 'Slut'
  description: ({gender})->"+2 to each stat for every #{if gender is 'f' then 'man' else 'woman'} onboard."
  @randomPoints: 5
  bonus: 2

Trait.GaySlut = class GaySlut extends Trait
  label: ({gender})-> if gender is 'm' then 'Gay Slut' else 'Lesbian Slut'
  description: (person)->"+2 to all stats for every other #{man(person)} onboard."
  @randomPoints: 5
  bonus: 2

Trait.SeaLegs = class SeaLegs extends Trait
  label: 'Sea Legs'
  description: (person)->"#{person}'s <span class='sailing'>sailing</span> increases twice as fast."
  sailingSet: 2
  @randomPoints: 5

Trait.Acute = class Acute extends Trait
  description: (person)->"#{person}'s <span class='business'>business</span> increases twice as fast."
  businessSet: 2
  @randomPoints: 5

Trait.Strong = class Strong extends Trait
  description: (person)->"#{person}'s <span class='combat'>combat</span> increases twice as fast."
  combatSet: 2
  @randomPoints: 5

Trait.Disciplined = class Disciplined extends Trait
  description: (person)->"#{person} slowly improves #{his} own highest stat (averaging +1 every 5 days)."
  @randomPoints: 5
  daily: (p)->
    if Math.random() > 0.2 then return
    stat = if p.combat > p.business and p.combat > p.sailing then 'combat' else if p.business > p.sailing then 'business' else 'sailing'
    p.add stat, 1
