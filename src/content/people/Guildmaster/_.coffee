layers = (p)->[
  "Base.png"
  "#{p}Skin.png"
  "#{p}Eyes.png"
  "#{p}Hair.png"
  "#{p}Top.png"
]

Person.Guildmaster = Game::people.Guildmaster = class Guildmaster extends Person
  name: 'Guildmaster'
  gender: 'm'
  text: '#9FDAAF'
  @images:
    path: 'src/content/people/Guildmaster/'
    scale: 1.36

    normal: layers 'Normal'
    happy: layers 'Happy'
    sad: layers 'Sad'
    serious: layers 'Serious'
    angry: layers 'Angry'
