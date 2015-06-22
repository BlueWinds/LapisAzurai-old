Trait.RenewContract = class RenewContract extends Trait
  description: (person)->"#{person} has renegotiated #{his} contract. #{He} is paid 50% more."
  wages: 1.5

Trait.Content = class Content extends Trait
  description: (person)->"#{person} works for reasons other than money. #{He} takes no wage."
  wages: 0

Trait.Loyal = class Loyal extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> decreases only half as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 0.5
    return delta
  @randomPoints: 5
  @opposed: ['Disloyal', 'Stoic', 'Excitable']

Trait.Disloyal = class Disloyal extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> decreases twice as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 2
    return delta
  @randomPoints: -3
  @opposed: ['Loyal', 'Stoic', 'Excitable']

Trait.Stoic = class Stoic extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> changes half as fast."
  happinessSet: 0.5
  @randomPoints: 5
  @opposed: ['Loyal', 'Disloyal', 'Excitable']

Trait.Excitable = class Excitable extends Trait
  description: (person)->"#{person}'s <span class='happiness'>happiness</span> changes twice as fast."
  happinessSet: 2
  @randomPoints: 0
  @opposed: ['Loyal', 'Disloyal', 'Stoic']

Trait.Acute = class Acute extends Trait
  description: (person)->"#{person}'s <span class='business'>business</span> increases twice as fast."
  businessSet: 2
  @randomPoints: 5
  @opposed: ['Spendthrift']

Trait.Spendthrift = class Spendthrift extends Trait
  description: (person)->"#{person}'s <span class='business'>business</span> increases only half as fast."
  businessSet: 0.5
  @randomPoints: -5
  @opposed: ['Acute']

Trait.SeaLegs = class SeaLegs extends Trait
  label: 'Sea Legs'
  description: (person)->"#{person}'s <span class='sailing'>sailing</span> increases twice as fast."
  sailingSet: 2
  @randomPoints: 5
  @opposed: ['Queasy']

Trait.Queasy = class Queasy extends Trait
  description: (person)->"#{person}'s <span class='sailing'>sailing</span> increases only half as fast."
  sailingSet: 0.5
  @randomPoints: -5
  @opposed: ['SeaLegs']

Trait.Strong = class Strong extends Trait
  description: (person)->"#{person}'s <span class='combat'>combat</span> increases twice as fast."
  combatSet: 2
  @randomPoints: 5
  @opposed: ['Weak']

Trait.Weak = class Weak extends Trait
  description: (person)->"#{person}'s <span class='combat'>combat</span> increases only half as fast."
  combatSet: 0.5
  @randomPoints: -5
  @opposed: ['Strong']
