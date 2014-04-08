
window.Contextual = class Contextual extends Validated
  @schema: $.extend true, {}, Validated.schema,
    type: @
    properties:
      context:
        # Context is a set of rules for filling in additional object properties at run-time (when a page is displayed, when a job is run, etc.)
        type: 'object'
        items:
          type: ['string', 'object']
          # If a condition is a string, then it looks up a path in the global game object.
          # @context.location: 'map|Vailia' -> @location = g.map.Vailia.
          pattern: /^[a-zA-Z0-9\|]+$/

          # See the Person class for more details on what exactly this looks like.
          properties:
            path:
              # The path at which to find the object we're comparing against. {path: 'map|Vailia'} is the "long form" of just 'map|Vailia'
              type: 'string'
              pattern: /^[a-zA-Z0-9\|]+$/
              optional: true
            optional:
              # The context as a whole can still "match" even if this object can't be found / it's conditions don't match.
              optional: true
              eq: true
            base:
              # A class that the object must be an instanceof
              type: 'function'
              optional: true
      images:
        type: 'object'
        # imageName: 'path/to/image.jpg'
        items:
          type: 'string'

  match: (context = {})->
    newContext = {}
    for key, value of @context
      path = if typeof value is 'string' then value else value.path
      target = context[key] or @[key] or g.getItem path
      unless target or value.optional
        return false
      if target
        newContext[key] = target
    return newContext

  lastP = null

  q: (person = lastP)->
    lastP = person
    return "<q style='color: #{person.color.text}' title='#{person}'>"
  @::q.toString = @::q

  bq: (person = lastP)->
    if typeof person is 'string'
      return "<blockquote style='color: #{person}'>"
    lastP = person
    return "<blockquote style='color: #{person.color.text}' title='#{person}'>"
  @::bq.toString = @::bq

  she: (p = lastP)-> lastP = p; if p.gender is 'f' then 'she' else 'he'
  She: (p = lastP)-> lastP = p; if p.gender is 'f' then 'She' else 'He'
  her: (p = lastP)-> lastP = p; if p.gender is 'f' then 'her' else 'his'
  him: (p = lastP)-> lastP = p; if p.gender is 'f' then 'her' else 'him'
  Her: (p = lastP)-> lastP = p; if p.gender is 'f' then 'Her' else 'His'
  girl: (p = lastP)-> lastP = p; if p.gender is 'f' then 'girl' else 'boy'
  woman: (p = lastP)-> lastP = p; if p.gender is 'f' then 'woman' else 'man'
  @::she.toString = @::she
  @::She.toString = @::She
  @::her.toString = @::her
  @::him.toString = @::him
  @::Her.toString = @::Her
  @::girl.toString = @::girl
  @::woman.toString = @::woman

  toggle: (options, selected)->
    options = optionList options, selected
    """<span class="btn-group toggle">#{options.join ''}</span>"""

  bigOptions: (options, selected)->
    options = optionList options, selected
    join = '</div><div class="col-md-4 col-xs-6">'
    """<div class="bigOptions row"><div class="col-md-4 col-xs-6">#{options.join join}</div></div>"""

  dropdown: (options, selected)->
    lis = optionList options, selected
    """<button type="button" class="btn btn-default dropdown-toggle inline">#{options[selected]}</button>
    <span class="dropdown-menu inline">
      <span>#{lis.join '</span><span>'}</span>
    </span>"""

  image: (label, classes = '')->
    return "<div class='#{classes}'><img src='#{@images[label]}'></div>"

optionList = (options, selected)->
  name = 'o-' + Math.random()
  options = for key, option of options
    _id = 'o-' + Math.random()
    checked = if selected is key then 'checked' else ''
    """<input type="radio" id="#{_id}" value="#{key}" #{checked} name="#{name}"><label for="#{_id}">#{option}</label>"""
  return options

$ ->
  $('body').on 'click', '.dropdown-toggle.inline', ->
    if $(@).attr 'disabled'
      return
    if $(@).hasClass 'active'
      $(@).removeClass 'active'
      $(@).next().hide()
      return
    $(@).addClass 'active'
    span = $(@).next()
    {top, left} = $(@).position()
    top -= span.outerHeight() + 1

    span.show().css {top, left}
  $('body').on 'change', '.dropdown-menu.inline input', ->
    # Get the text from the associated label
    text = $(@).next().html()
    # And apply the new value to the dropdown button and hide it
    menu = $(@).parent().parent().hide()
    menu.prev().removeClass('active').html text
