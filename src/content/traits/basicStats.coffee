Trait.Content = class Content extends Trait
  description: (person)->"#{person} works for reasons other than money. #{He person} takes no wage."
  wages: (person, wage)-> return 0

Trait.Loyal = class Loyal extends Trait
  description: (person)->"#{person}'s happiness decreases only half as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 0.5
    return delta

Trait.Disloyal = class Disloyal extends Trait
  description: (person)->"#{person}'s happiness decreases twice as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 2
    return delta

Trait.Stoic = class Stoic extends Trait
  description: (person)->"#{person}'s happiness changes half as fast."
  happinessSet: 0.5
