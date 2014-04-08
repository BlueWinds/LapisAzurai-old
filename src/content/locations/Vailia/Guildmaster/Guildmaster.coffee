Place.Vailia::people.Guildmaster = Person.Guildmaster = class Guildmaster extends Person
  name: 'Janos'
  gender: 'm'
  business: 80
  diplomacy: 70
  stealth: -15
  combat: 10
  happiness: 80
  endurance: 7
  level: 50
  growth: {}
  color:
    text: '#9FDAAF'
  images: Person.imageLocations('game/content/locations/Vailia/Guildmaster/', 891, 987, [
    'normal'
    'serious'
    'thinking'
    'skeptical'
    'smiling'
  ])


thinking = Person.Guildmaster::images.thinking.base
thinking[1] = 891
