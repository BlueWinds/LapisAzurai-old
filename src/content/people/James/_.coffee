Game::officers.James = Officer.James = class James extends Officer
  name: 'James'
  gender: 'm'
  business: 0
  diplomacy: 5
  sailing: 5
  combat: 20
  happiness: 70
  endurance: 10
  energy: 10
  text: '#DA9FAF'

  traits: new Collection
    loyal: new Trait.Loyal
      description: "James is a longtime friend, willing to stick with Natalie through thick and thin. His happiness decreases only half as quickly."
    content: new Trait.Content
      description: "James travels with Natalie for reasons other than money. He takes no wage."

  description: ->"Born to a Vailian blacksmith, James has been Natalie's friend ever since they were children. He gave up his inheritance and disobeyed his father's wishes to follow on her great adventure."
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
    serious: [
      'Base.png'
      'SeriousSkin.png'
      'SeriousEyes.png'
      'SeriousHair.png'
      'SeriousTop.png'
    ]
    sad: [
      'Base.png'
      'SadSkin.png'
      'SadEyes.png'
      'SadHair.png'
      'SadTop.png'
    ]
