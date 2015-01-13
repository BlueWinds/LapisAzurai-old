window.Mission = class Mission extends GameObject
  @schema:
    type: @
    properties:
      label:
        type: 'string'
      tasks:
        type: 'array'
        items:
          type: 'object'
          properties:
            description:
              type: ['function', 'string']
            conditions: Page.schema.properties.conditions
      blockSailing:
        optional: true
        eq: true
      effects: Page.schema.properties.effects
      removeWhenDone: # This mission finishes automatically, rather than waiting around completed for someone to finish it.
        optional: true
        eq: true

  renderBlock: (key)->
    tasks = for task in @tasks
      context = (new Collection).fill(task.conditions)
      renderTask task, context

    return """<div class="mission page" mission="#{key}">
      <div class="arrow-left"><span class="glyphicon glyphicon-chevron-left"></span></div>
      <div class="block-label">Mission: #{@label}</div>
      <ul class="requirements">#{tasks.join ''}</ul>
      <div class="arrow-right"><span class="glyphicon glyphicon-chevron-right"></span></div>
    </div>"""

  addAs: (key)->
    element = $ @renderBlock key
    $('#game-info').append element
    g.missions[key] = @

  removeAs: (key)->
    $('#game-info [mission="' + key + '"]').remove()
    if @effects then g.applyEffects @effects
    delete g.missions[key]

renderTask = (task, context)->
  match = if task.conditions and context.matches task.conditions
    'ok'
  else if task.conditions
    'remove'
  else
    'filter'
  return """<li>
    <span class="glyphicon glyphicon-#{match}"></span>
    #{task.description.call?(context) or task.description}
  </li>"""

Game::missions = new Collection

$ ->
  $('#game-info').on 'click', '.arrow-right', ->
    $(@).parent().removeClass 'active'
    next = $(@).parent().next()
    key = next.attr 'mission'
    mission = g.missions[key]
    next.replaceWith $(mission.renderBlock key).addClass 'active'

  $('#game-info').on 'click', '.arrow-left', ->
    $(@).parent().removeClass 'active'
    prev = $(@).parent().prev().addClass 'active'
    key = prev.attr 'mission'
    unless key then return

    mission = g.missions[key]
    prev.replaceWith $(mission.renderBlock key).addClass 'active'

  $('.navbar-brand').on 'mouseover dblclick', ->
    element = $('#game-info .active')
    key = element.attr 'mission'
    unless key then return

    mission = g.missions[key]
    element.replaceWith $(mission.renderBlock key).addClass 'active'
