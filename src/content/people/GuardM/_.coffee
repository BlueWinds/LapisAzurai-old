layers = (p)->[
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Hair.png"
  "#{p}Top.png"
  "Cloth.png"
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
