layers = (p)->[
  "Skin"
  "#{p}"
  "#{p}Eyes"
  "Hair"
  "Clothes"
]

layersNude = (p)->[
  "Skin"
  "#{p}"
  "#{p}Eyes"
  "Hair"
]

Game::officers.Nat = Officer.Natalie = class Natalie extends Officer
  name: 'Natalie'
  gender: 'f'
  business: 35
  sailing: 10
  combat: 0
  happiness: 70
  endurance: 8
  energy: 8
  text: '#8CDAFF'
  description: ->"""Natalie was barely five when her parents disappeared. She doesn't remember much of them. She's worked for The Guild her whole life, and is optimistic, hardworking, and quick witted - a rising star if the Guildmaster has ever seen one. If only she could control her tongue..."""
  traits: new Collection
    content: new Trait.Content
  color: ['tanned', 'none', 'green', 'ash', 'none', 'none']

  @images:
    path: 'src/content/people/Natalie/'
    scale: 0.45

    normal: layers 'Neutral'
    happy: layers 'Happy'
    grinning: layers 'Grinning'
    embarrassed: layers 'Embarrassed'
    uncertain: layers 'Uncertain'
    shouting: layers 'Shout'
    sad: layers 'Sad'
    crying: layers('Sad').concat(['SadTears'])
    normalNude: layersNude 'Neutral'
    happyNude: layersNude 'Happy'
    grinningNude: layersNude 'Grinning'
    embarrassedNude: layersNude 'Embarrassed'
    uncertainNude: layersNude 'Uncertain'
    shoutingNude: layersNude 'Shout'
    sadNude: layersNude 'Sad'
    cryingNude: layersNude('Sad').concat(['SadTears'])
  @colors: [
    { # Skin
      light: false
      ivory: [19, 67, 41]
      tanned: [28, 52, -12]
      golden: [37, 48, -30]
      cinnamon: [30, 50, -52]
      mocha: [27, 43, -58]
      ebony: [23, 44, -70]
    }
    { none: false } # Expression
    { # Eyes
      green: false
      blue: [198, 71, 0]
      hazel: [21, 29, 8]
      steel: [0, 0, -2]
      red: [0, 50, 0]
    }
    { # Hair
      fiery: [4, 44, 1]
      raven: [0, 0, -45]
      ash: false
      chestnut: [32, 40, -23]
      copper: [19, 53, -29]
      strawberry: [16, 47, 34]
      blonde: [41, 51, 38]
      green: [114, 49, 9]
      blue: [202, 65, 22]
      purple: [280, 44, 22]
      pink: [339, 50, 57]
      silver: [339, 0, 50]
    }
    { none: false } # Cloth
    { none: false } # Tears
  ]
