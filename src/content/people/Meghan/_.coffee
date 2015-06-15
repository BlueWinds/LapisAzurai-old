layers = (p)->[
  "#{p}Skin"
  "#{p}Eyes"
  "Cloth"
  "#{p}Hair"
]

Game::people.Meghan = Person.Meghan = class Meghan extends Person
  name: 'Meghan'
  gender: 'f'
  text: '#FF7555'
  @images:
    path: 'src/content/people/Meghan/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
