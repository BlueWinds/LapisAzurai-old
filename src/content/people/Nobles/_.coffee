layer = (g, p)->[
  "#{g + p}Skin.png"
  "#{g + p}Hair.png"
  "#{g + p}Eyes.png"
  "#{g + p}Top.png"
]

Person.NobleF = class NobleF extends Person
  name: 'Tandia'
  gender: 'f'
  @images:
    path: 'src/content/people/Nobles/'

    normal: layer 'F', 'Normal'
    happy: layer 'F', 'Happy'
    sad: layer 'F', 'Sad'
    serious: layer 'F', 'Serious'
    angry: layer 'F', 'Angry'

Person.NobleM = class NobleM extends Person
  name: 'Richard'
  gender: 'm'
  @images:
    path: 'src/content/people/Nobles/'

    normal: layer 'M', 'Normal'
    happy: layer 'M', 'Happy'
    sad: layer 'M', 'Sad'
    serious: layer 'M', 'Serious'
    angry: layer 'M', 'Angry'
