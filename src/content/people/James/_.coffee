layers = (p)->[
  "Base.png"
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Hair.png"
  "#{p}Top.png"
]

layersNude = (p)->[
  "#{p}SkinNude.png"
  "#{p}Eyes.png"
  "#{p}Hair.png"
  "#{p}Top.png"
]

Game::officers.James = Officer.James = class James extends Officer
  name: 'James'
  gender: 'm'
  business: 0
  diplomacy: 5
  sailing: 5
  combat: 20
  happiness: 50
  endurance: 10
  energy: 10
  text: '#DA9FAF'

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
    'normal-nude': layersNude 'Normal'
    'excited-nude': layersNude 'Excited'
    'blush-nude': layersNude 'Blush'
    'upset-nude': layersNude 'Upset'
    'angry-nude': layersNude 'Angry'
    'serious-nude': layersNude 'Serious'
    'sad-nude': layersNude 'Sad'
