layers = (p)->[
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Hair"
  "#{p}Top"
  "Cloth"
]

Game::people.AlkeniaGuard = Person.GuardM = class GuardM extends Person
  name: 'GuardM'
  gender: 'm'
  text: '#999999'
  @images:
    path: 'src/content/people/GuardM/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
