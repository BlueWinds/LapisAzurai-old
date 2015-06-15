layers = (p)->[
  "#{p}Skin"
  "Base"
  "#{p}Eyes"
  "#{p}Hair"
  "#{p}Top"
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
      "ThinkingSkin"
      "ThinkingBase"
      "ThinkingEyes"
      "ThinkingHair"
      "ThinkingTop"
    ]
