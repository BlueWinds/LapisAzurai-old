layers = (p)->[
  "#{p}Skin.png"
  "Base.png"
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
    smiling: layers 'Smiling'
    skeptical: layers 'Skeptical'
    serious: layers 'Serious'
    thinking: [
      "ThinkingSkin.png"
      "ThinkingBase.png"
      "ThinkingEyes.png"
      "ThinkingHair.png"
      "ThinkingTop.png"
    ]
