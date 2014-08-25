Game::crew.Nat = Person.Natalie = class Natalie extends Person
  name: 'Natalie'
  gender: 'f'
  business: 35
  businessGrowth: 1
  diplomacy: 15
  diplomacyGrowth: 0.75
  stealth: 10
  stealthGrowth: 0.5
  combat: 0
  combatGrowth: 0.25
  happiness: 70
  endurance: 10
  level: 1
  money: 200
  text: '#DA9FAF'
  description: ->"""Natalie was barely five when her parents disappeared - she doesn't remember much of them. She's worked for The Guild her whole life, and is optimistic, hardworking, and quick witted - a rising star if the Guilmaster has ever seen one. If only she could control her tongue..."""
  @images:
    path: 'src/content/people/Natalie/'
    normal: [
      'Base.png'
      'NormalSkin.png'
      'NormalEyes.png'
      'NormalHair.png'
      'NormalTop.png'
    ]
    excited: [
      'Base.png'
      'ExcitedSkin.png'
      'ExcitedEyes.png'
      'ExcitedHair.png'
      'ExcitedTop.png'
    ]
    blush: [
      'Base.png'
      'BlushSkin.png'
      'BlushEyes.png'
      'BlushHair.png'
      'BlushTop.png'
    ]
    upset: [
      'Base.png'
      'UpsetSkin.png'
      'UpsetEyes.png'
      'UpsetHair.png'
      'UpsetTop.png'
    ]
    angry: [
      'Base.png'
      'AngrySkin.png'
      'AngryEyes.png'
      'AngryHair.png'
      'AngryTop.png'
    ]
  @colors: [
    false # Base
    [# Skin
      ['light']
      ['ivory', 32, 67, 41]
      ['tanned', 34, 52, -16]
      ['golden', 40, 53, -30]
      ['cinnamon', 30, 50, -63]
      ['coffee', 27, 43, -61]
      ['chocolate', 23, 44, -77]
    ]
    [ # Eyes
      ['green']
      ['blue', 198, 71, 0]
      ['hazel', 21, 29, 8]
      ['steel', 0, 0, -2]
      ['red', 0, 50, 0]
    ]
    [ # Hair
      ['fiery']
      ['raven', 0, 0, -10]
      ['ash', 34, 23, -42]
      ['chestnut', 32, 40, -23]
      ['copper', 19, 53, -29]
      ['strawberry', 30, 53, 9]
      ['blonde', 43, 48, 16]
      ['green', 114, 37, -32]
      ['blue', 202, 65, 1]
      ['purple', 280, 44, -8]
    ]
    false # Top
  ]
