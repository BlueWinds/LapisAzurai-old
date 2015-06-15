layers = (p)->[
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Top"
  "#{p}Hair"
  "Cloth"
]

Person.MerchantF = class MerchantF extends Person
  name: 'MerchantF'
  gender: 'f'
  text: '#999999'
  @images:
    path: 'src/content/people/MerchantF/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
