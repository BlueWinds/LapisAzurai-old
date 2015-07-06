layers = (p)->[
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Hair"
  "Cloth"
]

Person.MerchantM = class MerchantM extends Person
  name: 'MerchantM'
  gender: 'm'
  text: '#999999'
  @images:
    path: 'src/content/people/MerchantM/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
