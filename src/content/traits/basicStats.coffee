Trait.Loyal = class Loyal extends Trait
  text: (person)->"#{person}'s happiness decreases only half as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 0.5
    return delta

Trait.Disloyal = class Disloyal extends Trait
  text: (person)->"#{person}'s happiness decreases twice as fast."
  happinessSet: (person, delta)->
    if delta < 0 then delta *= 2
    return delta

Trait.Stoic = class Stoic extends Trait
  text: (person)->"#{person}'s happiness changes half as fast."
  happinessSet: 0.5
