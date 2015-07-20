layer = (g, p)->[
  "#{g + p}Skin"
  "#{g + p}Hair"
  "#{g + p}Eyes"
  "#{g + p}Top"
]

Game::people.Ameliss = Person.Ameliss = class Ameliss extends Person
  name: 'Ameliss'
  gender: 'f'
  text: '#bfba6f'
  @images:
    path: 'src/content/people/Nobles/'

    normal: layer 'F', 'Normal'
    happy: layer 'F', 'Happy'
    sad: layer 'F', 'Sad'
    serious: layer 'F', 'Serious'
    angry: layer 'F', 'Angry'

###Person.NobleM = class NobleM extends Person
  name: 'Richard'
  gender: 'm'
  @images:
    path: 'src/content/people/Nobles/'

    normal: layer 'M', 'Normal'
    happy: layer 'M', 'Happy'
    sad: layer 'M', 'Sad'
    serious: layer 'M', 'Serious'
    angry: layer 'M', 'Angry'###
