layers = (p)->[
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Top.png"
  "#{p}Hair.png"
  "Cloth.png"
]

Person.MerchantM = class MerchantM extends Person
  name: 'MerchantM'
  gender: 'f'
  text: '#999999'
  @images:
    path: 'src/content/people/MerchantM/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
