layers = (p)->[
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Top.png"
  "Cloth.png"
  "#{p}Hair.png"
]

Person.Meghan = class Meghan extends Person
  name: 'Meghan'
  gender: 'f'
  text: '#999999'
  @images:
    path: 'src/content/people/Meghan/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
