zeroHappinessChanceToLeave = 0.75
maxHappinessToLeave = 20
portionOfSkillPassedOn = 1 / 4

Page.checkCrewLeaving = ->
  unless g.location.majorPort
    return

  leavingCount = 0
  leavingEvents = []

  leavingUnhappy = new Collection
  g.crew = g.crew.filter (sailor)->
    if sailor.happiness + Math.random() * maxHappinessToLeave / zeroHappinessChanceToLeave < maxHappinessToLeave
      leavingUnhappy.push sailor
      leavingCount++
      return false
    return true

  if leavingUnhappy.length
    leaving.push(next = if leavingUnhappy.length is 1
      new Page.OneCrewLeaving
    else
      new Page.ManyCrewLeaving
    )
    next.context = leavingUnhappy

  for key, sailor of g.crew.filter when sailor.contract is 0
    leavingCount++
    leavingEvents.push(next = new Page.HappyCrewLeaving)
    next.context = new Collection({
      sailor: sailor
      officer: Math.choice(g.officers)
    })

  if leavingCount
    g.queue.push next = new Page.CrewLeaving
    next.context =  new Collection {leaving: leavingCount}
    g.queue.push.apply(g.queue, leavingEvents)
  return

Page.CrewLeaving = class CrewLeaving extends Page
  text: ->"""|| bg="day|storm" speed="slow"
    -- As the crew dealt with the usual busines of arrival - anchors, ropes, cargo, kissing the dirt - Natalie dealt with the port authorities. A docking fee, letters to her contacts, and spreading the word that she might be looking to bring on more crew. With #{@leaving.toWord()} sailor#{if @leaving > 1 then "s" else ""} departing, she was left with #{g.crew.length.toWord()} hands, #{if g.crew.length >= 3 then "still enough crew they could set sail" else "not crew to man the ship"}.

  ||
    --> James jostled past, rolling an empty water barrel out of the hold for refilling, and finally finishing her business with the dock owner, she turned to those waiting. They couldn't depart without her formal permission.
"""

Page.OneCrewLeaving = class OneCrewLeaving extends Page
  # context[0] will be filled in when this event is triggered
  text: ->"""|| bg="portDay|portStorm"
    #{@[0].image 'sad', 'right'}
    --> #{q}I'm sorry, but I think it's time for me to look for another berth,</q> #{@[0]} maintained a bit of politeness, but not too much.
  ||
    #{g.officers.Nat.image 'serious', 'left'}
    --> #{q}Good luck.</q> Natalie nodded sadly. It was clear that #{@[0]} had been planning to leave for some time, and this was as good a time as any. The Lapis had been having a rough time recently - it was hard to hold it against #{him @[0]}.
  """

Page.ManyCrewLeaving = class ManyCrewLeaving extends Page
  # context[0 -> n] will be filled in when this event is triggered
  text: ->
    names = @asArray()
    names.shift()
    """|| bg="portDay|portStorm"
      #{@[0].image 'sad', 'right'}
      -- #{q}I'm sorry, Natalie, but we've talked it over and we think it's time to go our separate ways.</q> #{@[0]} spoke quietly, glancing over #{his} shoulder at the other#{if @length > 2 then 's who were' else ' who was'} departing. #{names.wordJoin()} nodded in agreement. They were also leavingUnhappy.

    ||
      #{g.officers.Nat.image 'serious', 'left'}
      --> #{q}I'm sorry to see you all go, but if that's what you have to do, then good luck.</q> She nodded sadly. It had been clear that they were already decided, and trying to hold onto them was a losing proposition. The Lapis had been having a rough time recently - it was hard to hold it against them.
    """

Page.HappyCrewLeaving = class HappyCrewLeaving extends Page
  # context[sailor], context[officer] will be filled in when this event is triggered
  text: ->"""|| bg="day|storm"
    #{@sailor.image 'happy', 'right'}
    -- #{@sailor} carried #{his} meager possessions over one shoulder, slung into a single canvas bag. The life of a sailor didn't allow for much in the way of material goods. #{He} did at least have a healthy purse of coin - between room and board paid for by the ship, scant free time with which to spend money and pay commensurate with an occupation that risked life and limb, crewmembers finishing their tours were well set. Those that survived, of that is.

  ||
    #{@sailor.image 'normal', 'right'}
    -- #{q}Take care, #{@officer}.</q> #{He @sailor} shook hands with the officer, then broke into a grin.

  ||
    #{@sailor.image 'happy', 'right'}
    --> #{q}It's been quiet an adventure. Stay safe.</q> #{He} clapped #{@officer.possessive()} back, then turned and strode purposefully along #{g.location}'s wharf. #{He @sailor}'d be missed. They'd learned much about #{@stat} from at #{his} hands.

  ||
    --><em><span class="#{@stat}">+#{@amount} #{@stat}</span> for #{@officer}</em>
"""
  apply: ->
    c = @context
    stats =
      combat: c.sailor.combat
      sailing: c.sailor.sailing
      business: c.sailor.business
    c.stat = Math.weightedChoice(stats)
    c.amount = Math.ceil(c.sailor[c.stat] * portionOfSkillPassedOn)

    super()

    g.crew.remove c.sailor
    c.officer.add c.stat, c.amount
