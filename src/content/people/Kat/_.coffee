layers = (p)->[
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Hair.png"
  "#{p}Top.png"
  "Base.png"
]

layersNude = (p)->[
  "#{p}SkinNude.png"
  "#{p}Eyes.png"
  "#{p}HairNude.png"
  "#{p}Top.png"
]

Game::people.Kat = Officer.Kat = class Kat extends Officer
  name: 'Kat'
  gender: 'f'
  business: 5
  diplomacy: 15
  sailing: 0
  combat: 10
  happiness: 30
  endurance: 7
  energy: 7
  text: '#9ADFAF'
  description: ->"Growing up on the streets, Kat has somehow managed to come through it all with a grin and a sparkle in her eye."
  @images:
    path: 'src/content/people/Kat/'

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
