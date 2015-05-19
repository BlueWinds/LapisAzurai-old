layer = (g, p)->[
  "#{g + p}Skin.png"
  "#{g + p}Hair.png"
  "#{g + p}Eyes.png"
  "#{g + p}Expression.png"
  "#{g}Top.png"
]

Person.VailianCrewM2 = class VailianCrewM2 extends Person.VailianCrewM
  name: 'VailianCrewM2'
  @descriptions: Person.VailianCrewM.descriptions
  @images:
    path: 'src/content/people/Crew2/'

    normal: layer 'M', 'Normal'
    happy: layer 'M', 'Happy'
    sad: layer 'M', 'Sad'
    serious: layer 'M', 'Serious'
    angry: layer 'M', 'Angry'
  c = Person.VailianCrewM.colors

Person.VailianCrewF2 = class VailianCrewF2 extends Person.VailianCrewF
  name: 'VailianCrewF2'
  @descriptions: Person.VailianCrewF.descriptions
  @images:
    path: 'src/content/people/Crew2/'

    normal: layer 'F', 'Normal'
    happy: layer 'F', 'Happy'
    sad: layer 'F', 'Sad'
    serious: layer 'F', 'Serious'
    angry: layer 'F', 'Angry'
  @colors: Person.VailianCrewM2.colors
