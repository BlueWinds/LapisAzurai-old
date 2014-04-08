options =
  'The Guild': """<img src="game/content/locations/Vailia/Market Day.jpg" class="col-xs-4 col-md-6">
    <p>Vailia is a world-renowened jewel of a city. And because its governing body, The Guild, was originally a union of brothel owners and their workers, it remains famously uninhibited. It hasn't been invaded since the last disasterous attempt by a neighbor to annex it a hundred years ago, and so far has never shown imperial ambitions of its own.</p>
    <p class="shorten"><em>The Guild is generally helpful, and will introduce you to the game's mechanics slowly. Recommended for new players.</em></p>"""
  Independent: """<img src="game/content/scenes/CaolinDay.jpg" class="col-xs-4 col-md-6">
    <p>Caolin has seen better days. Once rulers of a mighty empire, the city is now a shell of its former glory. Don't count it out yet though. Ancient secrets, wild forests, untapped resources  - everything points to a rebirth of glory. The merchants of Caolin aren't fabulously rich, but blood is thicker than water, and the Shogun himself has offered support for those seeking wealth on the high seas.</p>
    <p class="shorten"><em>Moderate difficulty and a fast-paced introduction.</em></p>"""
  'The UTC': """<img src="game/content/scenes/WorldMap.jpg" class="col-xs-4 col-md-6">
    <p>The Universal Trading Concern is as much an idea dream as it is an organization. A globe-spanning web of merchants, craftsmen and nobility, members of the UTC have only one thing in common - the knowledge that economics makes the world go round. So far, immense wealth and growing political might seem to bear that out...</p>
    <p class="shorten"><em>The UTC doesn't hold anyone's hand, and it offers no support. A difficult start, jumping straight into the deep end.</em></p>"""
pages = {
  'The Guild': 'GuildIntro'
  Independent: 'IndependentIntro'
  'The UTC': 'UTCIntro'
}

Page.Intro = class Intro extends Page
  next: false
  text: ->"""<img src="game/content/misc/world.png" class="full-background">
    <form class="well full">
      #{@bigOptions options, 'The Guild'}
      <button class="btn btn-default center-block">Select</button>
    </form>"""

  apply: (element)->
    element.addClass 'active'
    animate = [
      {
        top: "-80%"
        left: "-40%"
      }
      {
        top: "-40%"
        left: "-80%"
      }
      {
        top: "-20%"
        left: "-40%"
      }
    ]

    world = $ '.full-background', element
    world.animate animate[0], 30000, 'linear'
    world.animate animate[1], 30000, 'linear'
    world.animate animate[2], 30000, 'linear'

    $('input', element).change ->
      selected = $('input:checked', element).val()
      $('button').html selected
    element.submit (e)->
      e.preventDefault()
      $('#save-game').removeClass 'disabled'
      selected = $('input:checked', element).val()
      page = new Page[pages[selected]]
      page.show()
      Game.gotoPage()
      return false
