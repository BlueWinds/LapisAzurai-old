layers = (p)->[
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Top"
  "Cloth"
  "#{p}Hair"
]

Person.Judge = class Judge extends Person
  name: 'Judge'
  gender: 'f'
  text: '#999999'
  @images:
    path: 'src/content/people/Judge/'

    normal: layers 'Normal'
    happy: [
      'HappySkin'
      null
      'HappyTop'
      'Cloth'
      'HappyHair']
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
