Job.VailiaHireCrew = class VailiaHireCrew extends Job.HireCrew
  @hireClasses: [Person.VailianCrewM, Person.VailianCrewF]


Place.Vailia = Game::map.Vailia = class Vailia extends Place
  name: 'Vailia'
  description: ->"<p>Vailia is a bustling port city, famous for its political neutrality, its freedom from the disasters that plague lesser cities, and its brothels. Lots and lots of brothels.</p>"
  images:
    day: 'game/content/locations/Vailia/Port Day.jpg'
    night: 'game/content/locations/Vailia/Port Night.jpg'
    storm: 'game/content/locations/Vailia/Port Storm.jpg'
    marketDay: 'game/content/locations/Vailia/Market Day.jpg'
    marketNight: 'game/content/locations/Vailia/Market Night.jpg'
  jobs: new Collection
    hireCrew: Job.VailiaHireCrew
