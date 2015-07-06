Trait.Fisher = class Fisher extends Trait
  description: (person)->"#{person} feeds two people while at sea with #{his} efforts."
  eats: -1
  @randomPoints: 5

Trait.Cook = class Cook extends Trait
  description: (person)->"<span class='happiness'>+0.1 happiness</span> each day at sea for sailors."
  @randomPoints: 10
  daily: ->
    if g.atSea()
      for i, sailor of g.crew then sailor.add('happiness', 0.1)

Trait.Musician = class Musician extends Trait
  description: (person)->"#{person} adds +1 happiness to effect of distributing luxuries while at sea."
  @randomPoints: 5
  luxuryHappiness: 1

Trait.Shipwright = class Shipwright extends Trait
  description: (person)->"#{person} adds +25% to repair rate, and gets paid +2β at the shipyard."
  @randomPoints: 10
  repairRate: 0.25
  shipyardPay: 2

Trait.Brewer = class Brewer extends Trait
  description: (person)->"#{person} slowly changes Wheat into Beer when you have it in your cargo hold."
  @randomPoints: 5
  daily: ->
    if g.cargo.Wheat and Math.random() < 0.25
      g.applyEffects {cargo: {Wheat: -1, Beer: 1}}

Trait.Blacksmith = class Blacksmith extends Trait
  description: (person)->"#{person} slowly changes Vailian Steel into Trade Tools while in port."
  @randomPoints: 5
  daily: ->
    if g.cargo['Vailian Steel'] and Math.random() < 0.1 and not g.atSea()
      g.applyEffects {carge: {'Vailian Steel': -1, 'Trade Tools': 1}}

Trait.Apothecary = class Apothecary extends Trait
  description: (person)->"Resting grants officers +1 energy with #{person} in the crew."
  @randomPoints: 5
  rest: 1

Trait.Navigator = class Navigator extends Trait
  description: (person)->"The Lapis travels 10% faster with #{person} onboard. Doesn't stack."
  @randomPoints: 10
  navigator: 1

Trait.Longshoreman = class Longshoreman extends Trait
  description: (person)->"The Lapis can carry +5 cargo while #{person} is aboard."
  @randomPoints: 10
  cargo: 5

Trait.Steward = class Steward extends Trait
  description: (person)->"50% chance of +1 energy for tiredest officer daily."
  @randomPoints: 5
  daily: ->
    if Math.random() < 0.5
      low = g.officers.Nat
      for name, officer of g.officers
        if officer.endurance - officer.energy > low.endurance - low.energy
          low = officer
      if low.endurance > low.energy
        low.add 'energy', 1
