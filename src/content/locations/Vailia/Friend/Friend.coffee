Person.GuildFriend = class GuildFriend extends Person
  business: -20
  diplomacy: 5
  stealth: 0
  combat: 20
  happiness: 70
  endurance: 10
  level: 1
  growth:
    business: 0.5
    diplomacy: 0.75
    combat: 1
  color:
    text: '#DA9FAF'
  traits:
    loyal: new Trait.Loyal
      text: (person)->"#{person} is a longtime friend, willing to stick with #{g.player} through thick and thin. #{Page::Her person} happiness decreases only half as quickly."


Person.James = class James extends GuildFriend
  name: 'James'
  gender: 'm'
  images: Person.imageLocations 'game/content/locations/Vailia/Friend/James', 968, 1343, [
    'normal'
    'blush'
    'excited'
    'upset'
    'angry'
  ]


Person.Tina = class Tina extends GuildFriend
  name: 'Tina'
  gender: 'f'
  images: Person.imageLocations 'game/content/locations/Vailia/Friend/Tina', 788, 1196, [
    'normal'
    'blush'
    'excited'
    'upset'
    'angry'
  ]
