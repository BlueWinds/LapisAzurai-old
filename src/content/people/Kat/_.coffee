layers = (p)->[
  "Skin"
  "Clothes"
  "Hair"
  "#{p}Expression"
  "#{p}Eyes"
]

layersNude = (p)->[
  "Skin"
  "Hair"
  "#{p}Expression"
  "#{p}Eyes"
]

Game::people.Kat = Officer.Kat = class Kat extends Officer
  name: 'Kat'
  gender: 'f'
  business: 5
  sailing: 0
  combat: 10
  happiness: 30
  endurance: 7
  energy: 7
  text: '#9ADFAF'
  description: ->"Growing up on the streets, Kat has somehow managed to come through it all with a grin and a sparkle in her eye."
  traits: new Collection
    spendthrift: new Trait.Spendthrift

  @images:
    path: 'src/content/people/Kat/'
    scale: 0.45

    normal: layers 'Excited'
    embarrassed: layers 'Embarrassed'
    sad: layers 'Sad'
    uncertain: layers 'Uncertain'
    unimpressed: layers 'Unimpressed'
    upset: layers 'Upset'
    embarrassedNude: layersNude 'Embarrassed'
    normalNude: layersNude 'Excited'
    sadNude: layersNude 'Sad'
    uncertainNude: layersNude 'Uncertain'
    unimpressedNude: layersNude 'Unimpressed'
    upsetNude: layersNude 'Upset'
