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
  'engine/screens/sailEvent.coffee'
  'engine/screens/sail.coffee'
  'engine/screens/hireCrew.coffee'
  'engine/screens/market.coffee'

# Finally the content
  'content/traits/basicStats.coffee'
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
#   'content/people/Meghan/_.coffee'
#   'content/people/Nobles/_.coffee'
#   'content/people/Judge/_.coffee'

# Generic People
  'content/people/Crew/_.coffee'
  'content/people/Crew2/_.coffee'
  'content/people/GuardM/_.coffee'
#   'content/people/MerchantM/_.coffee'
#   'content/people/MerchantF/_.coffee'
#   'content/people/MerchantRich/_.coffee'

# Locations
  'content/locations/Ship/_Ship.coffee'
  'content/locations/Ship/_meetShip.coffee'
  'content/locations/Ship/_storm.coffee'
  'content/locations/Ship/_spirit.coffee'
  'content/locations/Vailia/_Vailia.coffee'
  'content/locations/Vailia/_Jobs.coffee'
  'content/locations/Vailia/_GuildWork.coffee'
  'content/locations/Vailia/_MtJulia.coffee'
  'content/locations/Vailia/_Alkenia.coffee'
  'content/locations/Vailia/_Nonkenia.coffee'
#   'content/locations/Kantis/_Kantis.coffee'

# Route content
  'content/people/James/_preRoute.coffee'
  'content/people/Kat/_preRoute.coffee'
#
# # Introduction & help
  'content/intro/introCity.coffee'
  'content/intro/introText.coffee'
  'content/intro/firstStorm.coffee'
]
