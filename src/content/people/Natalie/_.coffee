Game::officers.Nat = Officer.Natalie = class Natalie extends Officer
  name: 'Natalie'
  gender: 'f'
  business: 35
  diplomacy: 15
  sailing: 10
  combat: 0
  happiness: 70
  endurance: 8
  energy: 8
  money: 1000
  text: '#8CDAFF'
  description: ->"""Natalie was barely five when her parents disappeared - she doesn't remember much of them. She's worked for The Guild her whole life, and is optimistic, hardworking, and quick witted - a rising star if the Guilmaster has ever seen one. If only she could control her tongue..."""
  traits: new Collection
    content: new Trait.Content
  color: ['tanned', 'green', 'ash', 'none']

  @images:
    path: 'src/content/people/Natalie/'
    normal: [
      'NormalSkin.png'
      'NormalEyes.png'
      'NormalHair.png'
      'NormalTop.png'
    ]
    excited: [
      'ExcitedSkin.png'
      'ExcitedEyes.png'
      'ExcitedHair.png'
      'ExcitedTop.png'
    ]
    blush: [
      'BlushSkin.png'
      'BlushEyes.png'
      'BlushHair.png'
      'BlushTop.png'
    ]
    upset: [
      'UpsetSkin.png'
      'UpsetEyes.png'
      'UpsetHair.png'
      'UpsetTop.png'
    ]
    angry: [
      'AngrySkin.png'
      'AngryEyes.png'
      'AngryHair.png'
      'AngryTop.png'
    ]
    serious: [
      'SeriousSkin.png'
      'SeriousEyes.png'
      'SeriousHair.png'
      'SeriousTop.png'
    ]
    sad: [
      'SadSkin.png'
      'SadEyes.png'
      'SadHair.png'
      'SadTop.png'
    ]
  @colors: [
    { # Skin
      light: false
      ivory: [32, 67, 41]
      tanned: [34, 52, -16]
      golden: [40, 53, -30]
      cinnamon: [30, 50, -63]
      coffee: [27, 43, -61]
      chocolate: [23, 44, -77]
    }
    { # Eyes
      green: [110, 56, 0]
      blue: [198, 71, 0]
      hazel: [21, 29, 8]
      steel: [0, 0, -2]
      red: [0, 50, 0]
    }
    { # Hair
      fiery: false
      raven: [0, 0, -10]
      ash: [34, 23, -42]
      chestnut: [32, 40, -23]
      copper: [19, 53, -29]
      strawberry: [22, 52, 21]
      blonde: [43, 48, 16]
      green: [114, 37, -32]
      blue: [202, 65, 1]
      purple: [280, 44, -8]
    }
    { # Top
      none: false
    }
  ]
