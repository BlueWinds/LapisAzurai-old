module.exports = [
# First the game engine
  'engine/feature-detect.coffee'
  'engine/util.coffee'
  'engine/classes/base.coffee'
  'engine/classes/game.coffee'
  'engine/classes/page.coffee'
  'engine/classes/person.coffee'
  'engine/classes/officer.coffee'
  'engine/classes/trait.coffee'
  'engine/classes/job.coffee'
  'engine/classes/mission.coffee'
  'engine/classes/place.coffee'
  'engine/classes/item.coffee'
  'engine/gui.coffee'

# Now the game screens
  'engine/screens/load.coffee'
  'engine/screens/nextDay.coffee'
  'engine/screens/port.coffee'
  'engine/screens/crewLeaving.coffee'
  'engine/screens/setSail.coffee'
  'engine/screens/sailDay.coffee'
  'engine/screens/sailEvent.coffee'
  'engine/screens/hireCrew.coffee'
  'engine/screens/market.coffee'

# Finally the content
  'content/traits/basicStats.coffee'
  'content/traits/professions.coffee'
  'content/items/trade.coffee'
  'content/items/food.coffee'
  'content/items/luxury.coffee'
  'content/misc/update.coffee'
  'content/misc/universalJobs.coffee'

# Specific People
  'content/people/Natalie/_.coffee'
  'content/people/James/_.coffee'
  'content/people/Kat/_.coffee'
  'content/people/Guildmaster/_.coffee'
  'content/people/Meghan/_.coffee'
  'content/people/Nobles/_.coffee'
  'content/people/Cara/_.coffee'
  'content/people/GuardM/_.coffee'
#   'content/people/Judge/_.coffee'

# Generic People
  'content/people/Crew/_.coffee'
  'content/people/Crew2/_.coffee'
#   'content/people/MerchantM/_.coffee'
#   'content/people/MerchantRich/_.coffee'

# Locations
  'content/locations/Ship/_Ship.coffee'
  'content/locations/Ship/_meetShip.coffee'
  'content/locations/Ship/_storm.coffee'
  'content/locations/Ship/_spirit.coffee'
  'content/locations/Vailia/_Vailia.coffee'
  'content/locations/Vailia/_Jobs.coffee'
  'content/locations/Vailia/_GuildWork.coffee'
  'content/locations/VailiaEnvirons/_MtJulia.coffee'
  'content/locations/VailiaEnvirons/_Alkenia.coffee'
  'content/locations/VailiaEnvirons/_Nonkenia.coffee'
  'content/locations/VailiaEnvirons/_IronSands.coffee'

  'content/locations/Kantis/_Tomenoi.coffee'

# Introduction & help
  'content/intro/introCity.coffee'
  'content/intro/introText.coffee'
  'content/intro/firstStorm.coffee'

# Story content
  'content/locations/Kantis/_Intro.coffee'
  'content/people/James/_preRoute.coffee'
  'content/people/Kat/_preRoute.coffee'
]
