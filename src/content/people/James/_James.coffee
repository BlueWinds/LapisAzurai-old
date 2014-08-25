Game::crew.James = Person.James = class James extends Person
  name: 'James'
  gender: 'm'
  business: 0
  businessGrowth: 0.5
  diplomacy: 5
  diplomacyGrowth: 0.75
  stealth: 0
  combat: 20
  combatGrowth: 1
  happiness: 70
  endurance: 10
  level: 1
  text: '#DA9FAF'
  traits: new Collection
    loyal: new Trait.Loyal
      description: "James is a longtime friend, willing to stick with Natalie through thick and thin. His happiness decreases only half as quickly."
  description: ->"Born to a Vailian blacksmith and his wife, James has been Natalie's friend ever since they were children. He gave up his inheritance and disobeyed his father's wishes to follow on her great adventure."
  @images:
    path: 'src/content/people/James/'
    normal: [
      'Base.png'
      'NormalSkin.png'
      'NormalEyes.png'
      'NormalHair.png'
      'NormalTop.png'
    ]
    excited: [
      'Base.png'
      'ExcitedSkin.png'
      'ExcitedEyes.png'
      'ExcitedHair.png'
      'ExcitedTop.png'
    ]
    blush: [
      'Base.png'
      'BlushSkin.png'
      'BlushEyes.png'
      'BlushHair.png'
      'BlushTop.png'
    ]
    upset: [
      'Base.png'
      'UpsetSkin.png'
      'UpsetEyes.png'
      'UpsetHair.png'
      'UpsetTop.png'
    ]
    angry: [
      'Base.png'
      'AngrySkin.png'
      'AngryEyes.png'
      'AngryHair.png'
      'AngryTop.png'
    ]
