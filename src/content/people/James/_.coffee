layers = (p)-> [
  "Base"
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Hair"
  "#{p}Top"
]

layersNude = (p)-> [
  "Empty"
  "#{p}SkinNude"
  "#{p}Eyes"
  "#{p}Hair"
  "#{p}Top"
]

Game::officers.James = Officer.James = class James extends Officer
  name: 'James'
  gender: 'm'
  business: 5
  sailing: 5
  combat: 20
  happiness: 50
  endurance: 10
  energy: 10
  text: '#DA9FAF'
  color: ['none', 'tanned', 'green', 'ash', 'none']

  traits: new Collection
    loyal: new Trait.Loyal
      description: "James is a longtime friend, willing to stick with Natalie through thick and thin. His happiness decreases only half as quickly."
    content: new Trait.Content
      description: "James travels with Natalie for reasons other than money. He takes no wage."

  description: ->"Born to a Vailian blacksmith, James has been Natalie's friend ever since they were children. He gave up his inheritance and disobeyed his father's wishes to follow on her great adventure."
  @images:
    path: 'src/content/people/James/'

    normal: layers 'Normal'
    excited: layers 'Excited'
    blush: layers 'Blush'
    upset: layers 'Upset'
    angry: layers 'Angry'
    serious: layers 'Serious'
    sad: layers 'Sad'
    normalNude: layersNude 'Normal'
    excitedNude: layersNude 'Excited'
    blushNude: layersNude 'Blush'
    upsetNude: layersNude 'Upset'
    angryNude: layersNude 'Angry'
    seriousNude: layersNude 'Serious'
    sadNude: layersNude 'Sad'

  @colors: [
    { none: false } # Cloth
    { # Skin
      light: false
      ivory: [32, 67, 41]
      tanned: [34, 52, -16]
      golden: [40, 53, -30]
      cinnamon: [30, 50, -63]
      mocha: [27, 43, -61]
      ebony: [23, 44, -77]
    }
    { # Eyes
      green: false
      blue: [198, 71, 0]
      hazel: [21, 29, 8]
      steel: [0, 0, -2]
      red: [0, 50, 0]
    }
    { # Hair
      fiery: false
      raven: [0, 0, -60]
      ash: [34, 23, -42]
      chestnut: [32, 40, -23]
      copper: [19, 53, -29]
      strawberry: [22, 52, 21]
      blonde: [43, 48, 16]
      green: [114, 37, -32]
      blue: [202, 65, 1]
      purple: [280, 44, -8]
    }
    { none: false } # Top
  ]
