layers = (p)->[
  "BaseHair"
  "#{p}Skin"
  "#{p}Eyes"
  "#{p}Top"
  "Cloth"
  "#{p}Hair"
  "Hat"
]

Person.MerchantRich = class MerchantRich extends Person
  name: 'MerchantRich'
  gender: 'm'
  text: '#999999'
  @images:
    path: 'src/content/people/MerchantRich/'

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
