marketImage = ->
  if g.weather is 'storm' then g.map.Vailia.images.marketStorm else g.map.Vailia.images.marketDay

Place.Vailia::jobs.library = Job.Library = class Library extends Job
  label: "Visit the Library"
  text: ->"Research sea routes or other useful information at the University. <em>-5β</em>"
  energy: -1
  conditions:
    '|officers|Nat|money': {gte: 5}
  officers:
    worker: {}
  effects:
    money: [-5, 'Visited Library']

Job.Library::next = Page.Library = class Library extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{marketImage()}">
    <text><p>The University – unnamed, beyond its location (Vailia) and its function (university) – was the fourth largest collection of books known in the world. The other three were all owned by nations rather larger than one small island – Kantis and Baufeng had capital cities to rival Vailia, while Jeju lacked a city as major, but possessed lands a thousand miles wide. Still, ten thousand volumes, curated and carefully maintained, was nothing to scoff at, especially when there was specific knowledge to be sought out.</p></text>
  </page>"""
  next: Page.randomMatch
  @next = []

Page.Library.next.push Page.LibraryTravel = class LibraryTravel extends Page
  conditions:
    '|events|LibraryTravel|length': {lt: 2, optional: true}
    worker: {}
  text: ->"""<page bg="#{marketImage()}">
    <text><p>With some careful searching of various travel journals and map fragments, and the (un)help of a thorny librarian, #{@worker} managed to find and copy down the details of a new route. With a detailed chart and location, the Lapis could now travel to another destination.</p></text>
  </page>"""
  next: Page.firstNew
  @next = []

Page.LibraryTravel.next.push Page.LibraryTravelAlkenia = class LibraryTravelAlkenia extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{marketImage()}">
    <text><p>With some careful searching of various travel journals and map fragments, and the (un)help of a thorny librarian, #{@worker} managed to find and copy down the details of a new route. With a detailed chart and location, the Lapis could now travel to another destination.</p>
    <p>Passing through Mt. Julia, one can sail to <strong>Alkenia</strong>, a relatively major and independent city. The closest real settlement to Vailia, it's nominally independent but firmly under Vailia's influence and welcoming of merchants. They'll buy textiles and other Vailian manufactured goods at an excellent price.</p></text>
  </page>"""
  apply: ->
    super()
    g.map.MountJulia.destinations.Alkenia = 7

Page.LibraryTravel.next.push Page.LibraryTravelDirect = class LibraryTravelDirect extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{marketImage()}">
    <text><p>With some careful searching of various travel journals and map fragments, and the (un)help of a thorny librarian, #{@worker} managed to find and copy down the details of a new route. With a detailed chart and location, the Lapis could now travel to another destination.</p>
    <p><strong>A direct route</strong> to Alkenia, bypassing Mount Julia to shave a day off the trip. The open ocean route was <b>more dangerous</b> - worse chance of getting caught in a storm, but possibly worth it.</p></text>
  </page>"""
  apply: ->
    super()
    g.map.Vailia.destinations.Alkenia = 13
    g.map.Alkenia.destinations.Vailia = 17

# Page.LibraryTravel.next.push Page.LibraryTravelNonkenai = class LibraryTravelNonkenai extends Page
#   text: ->"""<page bg="#{marketImage()}">
#     <text><p>After passing through Alkenia, one can reach <strong>Nonkenai</strong>, Alkenia's rival city and spiritual center for the continent. Though they stubbornly maintain their independence, they still welcome Vailian merchants and the quality manufactured goods they bring, with a special interest in weapons and other metalwork.</p></text>
#   </page>"""
#
# Page.LibraryTravel.next.push Page.LibraryTravelBlackSands = class LibraryTravelBlackSands extends Page
#   text: ->"""<page bg="#{marketImage()}">
#     <text><p><strong>Black Sands</strong>, a mining settlement run by Vailia, and a major source of both raw iron and steel goods. They will buy wood, bulk grain and alcohol at excellent prices.</p></text>
#   </page>"""

Page.Library.next.push Page.LibraryNap = class LibraryNap extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{marketImage()}">
    <text><p>Though drawn to the library by the promise of a treasure trove of knowledge, #{@worker} couldn't help but be distracted by the beautiful weather. Really, it was hardly #{his} fault at all that a sunbeam crept across the book #{he} was reading, and who could blame #{him} for feeling a bit drowsy in the comfortable heat? No one at all. An expensive place to nap, but a peaceful one.</p>
    <p><em>#{@worker}: <span class="energy">+2 energy</span></em></p></text>
  </page>"""
  apply: ->
    super()
    @context.worker.add 'energy', 2

Page.Library.next.push Page.LibraryBadBook = class LibraryBadBook extends Page
  conditions:
    worker: {}
  text: ->"""<page bg="#{marketImage()}">
    <text><p>Though it seemed to be a somewhat trashy romance novel at first glance, a careful analysis of this particular book convinced #{@worker} that it was in fact a <em>very</em> trashy romance novel. At least #{he} learned a thing or two about writing – or at the very least what to avoid. <q>His voice is warm and husky like dark melted chocolate fudge caramel… or something...</q></p><p>Or something indeed. #{@worker} closed the book.</p></text>
  </page>"""

Place.Vailia::jobs.defense = Job.Defense = class Defense extends Job
  label: "Combat Training"
  text: ->"Take a lesson from a retired mercenary in the fine art of not-getting-killed. <em>-3β</em>"
  energy: -2
  conditions:
    '|officers|Nat|money': {gte: 3}
  officers:
    worker: {}
  effects:
    money: [-3, 'Self Defense Lesson']
  apply: ->
    super()
    @context.worker.add 'combat', 3
  next: Page.randomMatch
  @next = []

Job.Defense.next.push Page.DefenseNatalie = class DefenseNatalie extends Page
  conditions:
    worker: {is: Officer.Natalie}
  text: ->"""<page bg="#{marketImage()}">
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}Hey! I heard you teach people weapons?</q> Natalie squatted down in front of the man drinking from a clay pitcher. He was rough-faced, at least two meters tall, and wore a broadsword strapped to his back. No denying that this was Torril, one of the more famous mercenaries (now retired) in Vailia.</p></text>
  </page>
  <page>
    <text continue><p><q>I do. I take it you're interested?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}I captain a vessel, and figured it would behoove me to know a thing or two more about this than I do.</q> She popped back to her feet and went over to the rack of wooden practice weapons, browsing through it before settling on a narrow wooden blade.</p></text>
  </page>
  <page>
    <text continue><p>Torril stood up slowly, unfolding his bulky two meters, shaking his head. <q>I have literally never had to tell someone which end of a sword was which before. Here, that's the grip on the other side...</q></p></text>
  </page>

  <page>
    <text><p>Natalie had to admit, she'd never much considered the personal danger inherent in traveling the world. Between James and a loyal crew, the thought that she'd need to fight herself... well, better to give up that thinking now than to be caught off guard sometime in the future.</p></text>
  </page>
  <page bg="#{if g.weather is 'storm' then g.map.Vailia.images.marketStorm else g.map.Vailia.images.marketNight}">
    <text continue><p>She spent the day training with Torril, a retired mercenary captain. Too slight to be any good with a hand-to-hand weapon, he instead decided to train her in the fine art of running away – and catching those pursuing off guard with a variety of objects, ranging in lethality from rocks to the ankle to daggers in the throat. Torril was a good instructor, but not shy about reminding her that she was practicing on dummies now so she could do the same things to living people later.</p></text>
  </page>"""

Job.Defense.next.push Page.DefenseJames = class DefenseJames extends Page
  conditions:
    worker: {is: Officer.James}
  text: ->"""<page bg="#{marketImage()}">
    #{@worker.image 'normal', 'left'}
    <text><p>#{q}I need some help.</q> James presented himself to Torril, a retired mercenary captain.</p></text>
  </page>
  <page>
    <text continue><p><q>What sort of help?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}Help with a sword.</q></p></text>
  </page>

  <page>
    <text><p><q>Why?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}I'll be traveling dangerous places, and I need to protect people.</q></p></text>
  </page>
  <page>
    <text continue><p><q>Good reason. Here, let's see what you know.</q> Torril tossed him a wooden practice blade.</p></text>
  </page>"""

# Job.Defense.next.push Page.DefenseAsara = class DefenseAsara extends Page
#   conditions:
#     worker: {is: Officer.Asara}
#   text: ->"""<page bg="#{marketImage()}">
#     #{@worker.image 'normal', 'left'}
#     <text><p>#{q}I believe you can help me,</q> Asara introduced herself to the mercenary captain without preamble.</p></text>
#   </page>
#   <page>
#     <text continue><p>He stared at her, then slowly shook his head. <q>I don't believe I know any more about the sword than you, miss.</q></p></text>
#   </page>
#   <page>
#     #{@worker.image 'normal', 'left'}
#     <text continue><p>#{q}Not the sword.</q> She tapped her temple, next to her grey eyes.</q></p></text>
#   </page>
#   <page>
#     #{@worker.image 'normal', 'left'}
#     <text continue-inline>#{q}I have heard that you may have some experience with one of my sisters. Teach me what she could do.</q></text>
#   </page>
#   <page>
#     <text continue><p>Torril nodded. <q>I was her captain for six months. No promises, but I'll see what I can do. You can do the strengthing-thing, right?</q></p></text>
#   </page>"""

Job.Defense.next.push Page.DefenseKat = class DefenseKat extends Page
  conditions:
    worker: {is: Officer.Kat}
  text: ->"""<page bg="#{marketImage()}">#{@worker.image 'normal', 'left'}
    <text><p>Kat slumped her way into the courtyard, managing to look as though she was being dragged even though no one was anywhere near her. #{q}I'm supposed to learn how to fight,</q> she addressed the retired mercenary.</p></text>
  </page>
  <page>
    <text continue><p><q>Ah, you must be Kat. Natalie told me about you. I hear you're quick like a demon and lazy like one too.</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}That wasn't very nice of her,</q> Kat stuck out her tongue.</p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue-inline>#{q}Accurate though,</q> she chuckled at her sally.</text>
  </page>

  <page>
    <text><p><q>Well, we'll soon work that out of you. Do you know any weapons work?</q></p></text>
  </page>
  <page>
    #{@worker.image 'normal', 'left'}
    <text continue><p>#{q}I can throw a half-brick pretty well. Usually kill a rat in one hit,</q> she grinned proudly.</p></text>
  </page>
  <page>
    <text continue><p>Torril rubbed his forehead. Today was going to be a long day.</p></text>
  </page>"""

pay = 4

Place.Vailia::jobs.shipyard = Job.Shipyard = class Shipyard extends Job
  label: "Shipyard"
  text: ->"""Work in the shipyard. Not particularly profitable, but can help keep the sailors out of trouble and make a little money at the same time. <em><span class="sailing">+1 sailing</span> for officer, +#{pay}β per sailor</em>"""
  energy: -2
  officers:
    worker: {}
  conditions:
    '|weather': {eq: 'calm'}
  crew: 0

Job.Shipyard::next = Page.Shipyard = class Shipyard extends Page
  conditions:
    worker: {}
    count: '|last|context|length'
  text: ->"""<page bg="#{g.location.images.day}">
    <text><p>Vailia's shipyards ran constantly, taking raw iron and lumber, combining them with back-breaking labor, and turning out the finest ships in the world. Much of the process was carried out behind walls, hidden from public view - and hidden from temporary labor like #{@worker}#{if @count > 1 then (" and " + his + " sailors. They") else (". " + He)} spent the day debarking trees, sawing planks and sorting nails. Repetitive, brutal work, but one of the few jobs available on a day-by-day basis.</p>
    <p><em>+#{@count * pay}β, <span class="sailing">+1 Sailing</span> for #{@worker}</em></p></text>
  </page>"""
  apply: ->
    super()
    g.applyEffects {money: [@context.count * pay, 'Worked at Shipyard']}
    @context.worker.add 'sailing', 1
