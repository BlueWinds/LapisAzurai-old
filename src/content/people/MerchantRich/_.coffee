layers = (p)->[
  "BaseHair.png"
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Top.png"
  "Cloth.png"
  "#{p}Hair.png"
  "Hat.png"
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
