layers = (p)->[
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Top.png"
  "Cloth.png"
  "#{p}Hair.png"
]

Person.Judge = class Judge extends Person
  name: 'Judge'
  gender: 'f'
  text: '#999999'
  @images:
    path: 'src/content/people/Judge/'

    normal: layers 'Normal'
    happy: [
      'HappySkin.png'
      null
      'HappyTop.png'
      'Cloth.png'
      'HappyHair.png']
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
