lackingMaterialsRepairSpeed =
  neither: 1
  wood: 0.25
  supplies: 0.25
  both: 0.1

repairPerCrew = 4 / 3
repairPerSailing = 0.03

woodPerRepair = 2 / 3
suppliesPerRepair = 1 / 3

minDamageWithoutOneItem = 4
minDamageWithoutTwoItems = 6

Job.universal.push Job.RepairShip = class RepairShip extends Job
  label: "Repair the Ship"
  type: "special"
  conditions:
    damage: {path: '|map|Ship|damage', gt: 0}
    Ship: '|map|Ship'
    missing: {
      fill: -> switch
        when not g.cargo.Wood and not g.cargo['Naval Supplies'] then 'both'
        when not g.cargo.Wood then 'wood'
        when not g.cargo['Naval Supplies'] then 'supplies'
        else 'neither'
    }
  officers:
    worker: {}
  energy: -2
  crew: 1
  text: ->
    damage = g.map.Ship.damage
    noRepair = switch
      when @missing is 'both' then damage <= minDamageWithoutTwoItems
      when @missing is 'neither' then false
      else damage <= minDamageWithoutOneItem
    lackingMaterials = switch
      when @missing is 'both' then "Missing wood or naval supplies, #{if noRepair then '<b>nothing at all</b>' else 'little'} can be done"
      when @missing is 'neither' then "With both wood and naval supplies, progress will be quick"
      when @missing is 'wood' then "The lack of wood will #{if noRepair then '<b>prevent</b>' else 'slow down'} repairs"
      else "The lack of naval supplies will #{if noRepair then '<b>completely prevent</b>' else 'slow down'} repairs"

    """The ship is <b title="#{@Ship.damageDescription()}">#{@Ship.shortDamage()}</b>, and could use some attention. #{lackingMaterials} #{unless noRepair then ' (' + String.rate lackingMaterialsRepairSpeed[@missing] + ' speed)' else ''}. Send more workers - and workers with higher <span class="sailing">sailing</span> to speed up repairs."""

Job.RepairShip::next = Page.RepairShip = class RepairShip extends Page
  conditions:
    worker: {}
    crew: '|last|context|length'
    missing: {}
    repair: fill: ->
      sailing = Person.sumStat 'sailing', Job.RepairShip::officers, g.last.context

      repair = (1 + g.last.context.length) * repairPerCrew
      repair += sailing * repairPerSailing
      repair *= lackingMaterialsRepairSpeed[g.last.context.missing]
      if g.weather is 'storm' then repair *= 0.25

      minDamage = switch
        when g.last.context.missing is 'neither' then 0
        when g.last.context.missing is 'both' then minDamageWithoutTwoItems
        else minDamageWithoutOneItem
      repair = Math.randomRound Math.min(repair, g.map.Ship.damage - minDamage)
      repair = Math.max 0, repair
      return repair

    sailing:
      fill: -> Person.sumStat 'sailing', Job.RepairShip::officers, g.last.context
  text: ->
    cost =
      Wood: Math.ceil Math.min(g.cargo.Wood, @repair * woodPerRepair)
      'Naval Supplies': Math.ceil Math.min(g.cargo['Naval Supplies'], @repair * suppliesPerRepair)

    missingMaterials = switch
      when @missing is 'both' then "Without proper materials in the hold - neither spare planks nor any of the other necessities to make a ship seaworthy - it was painful and slow work, and some tasks were simply impossible."
      when @missing is 'wood' then "Lacking any way to replace the damaged mast, they settled for binding it tightly and a generouse dose of tar to keep water and rot away from the weakend areas."
      when @missing is 'supplies' then "Without any fresh canvas or ropes, #{@worker} had to settle for patching, stitching and splicing things back into shape. It would work - for now - but the work was painstaking and sluggish."
      else ""
    repair = switch
      when @repair is 0 then "You can't repair the ship any further without the right materials"
      else "Repaired #{@repair} (#{g.map.Ship.damage - @repair} damage left)"

    """<page bg="#{if g.weather is 'storm' then g.location.images.storm else g.location.images.day}">
      <text><p>#{@worker} pitched in along with #{@crew.toWord()} sailors to set the Lapis aright. Torn canvas and snapped ropes they spliced, patched and replaced. Some weakened wood could be made good as new with a binding, while sections too damaged for that had to be taken out and refitted entirely. A well-put together ship was designed with repair in mind, as well as sea-worthiness - every plank in the ship save the spine itself might be taken out and replaced over the course of years of service.</p>
      #{if missingMaterials then "<p>" + missingMaterials + "</p>" else ""}
      <p><em>#{repair}</em></p>
      <p><em>#{Item.costDescription(cost)}</em></p></text>
    </page>"""

  apply: ->
    super()
    g.map.Ship.damage -= @context.repair
    if g.cargo.Wood
      g.cargo.Wood -= @context.repair * woodPerRepair
      g.cargo.Wood = Math.floor Math.max(0, g.cargo.Wood)
      unless g.cargo.Wood then delete g.cargo.Wood
    if g.cargo['Naval Supplies']
      g.cargo['Naval Supplies'] -= @context.repair * suppliesPerRepair
      g.cargo['Naval Supplies'] = Math.floor Math.max(0, g.cargo['Naval Supplies'])
      unless g.cargo['Naval Supplies'] then delete g.cargo['Naval Supplies']

Job.universal.push Job.BedRest = class BedRest extends Job
  label: "Bed Rest"
  type: "special"
  conditions:
    someoneSick:
      fill: ->
        for name, officer of g.officers when officer.sick then return officer
        return false
  officers:
    worker: {sick: {is: true}}
    worker2: {sick: {is: true}, optional: true}
    worker3: {sick: {is: true}, optional: true}
  energy: 3
  acceptInjured: true
  crew: 1
  text: ->"""When someone is injured, the best (and likely only) solution is bed rest, and lots of it. They'll need someone to look after them as well."""
  apply: ->
    super()
    @context.worker.add 'energy', 3
    @context.worker2?.add 'energy', 3
    @context.worker3?.add 'energy', 3

Job.BedRest::next = Page.BedRest = class BedRest extends Page
  text: ->false
