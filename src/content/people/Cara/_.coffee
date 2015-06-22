layers = (p)->[
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Top"
  "#{p}Hair"
  "Cloth"
]

Game::people.Cara = Person.Cara = class Cara extends Person
  name: 'Cara'
  gender: 'f'
  text: '#3fba6f'
  @images:
    path: 'src/content/people/Cara/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
