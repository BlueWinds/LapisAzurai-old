updateJob = (job, jobDiv)->
  workers = {}
  $('.person-info', jobDiv).each ->
    key = $(@).attr('data-key')
    person = g.crew[key] or g.player
    workers[key] = person
  $('.job-requirements').replaceWith job.requiresBlock workers
  if job.updateFromDiv jobDiv
    jobDiv.addClass 'ready'
  else
    jobDiv.removeClass 'ready'

Page.Port = class Port extends Page
  context:
    port: 'location'
  text: ->
    jobs = for key, job of @port.jobs
      if typeof job is 'function'
        job = @port.jobs[key] = new job
      job.renderBlock(@, key)
    crew = (person.renderBlock(@, key) for key, person of g.crew)
    crew.unshift g.player.renderBlock @, ''
    return """<div class="screen" style='background-image: url("#{@port.images.port}");'>
      <form>
        <div class="jobs col-md-4 col-xs-6 col-md-offset-2">#{jobs.join ''}</div>
        <div class="crew col-md-4 col-xs-6">#{crew.join ''}</div>
        <button class="btn btn-primary center-block" disabled>Done</button>
      </form>
      <div class="well short">#{@port.description()}</div>"""
  apply: (element)->
    g.day += 1
    port = @

    people = $ '.person-info', element
    people.click -> $(@).toggleClass 'active'

    $('.job', element).click (e)->
      if $(e.target).closest('.person-info').length
        return
      jobDiv = $(@)
      job = port.port.jobs[jobDiv.attr('data-key')]
      $('.person-info.active', element).each ()->
        personDiv = $(@)
        if personDiv.closest(jobDiv).length
          return
        person = g.crew[personDiv.attr('data-key')] or g.player
        for key, conditions of job.workers
          slotDiv = $('li[data-slot="' + key + '"]', jobDiv)
          if $('.person-info', slotDiv).length
            continue
          unless person.match conditions
            continue

          slotDiv.prepend personDiv
          personDiv.removeClass 'active'
          return
      if $('.crew .person-info', element).length is 0
        $('button', element).removeAttr 'disabled'

      updateJob job, jobDiv
    $('.crew', element).click (e)->
      if $(e.target).closest('.person-info').length
        return
      if $('.person-info.active', element).length
        $('button', element).attr 'disabled', true
        $('.person-info.active', element).appendTo @
        .removeClass 'active'
      $('.job', element).each ->
        jobDiv = $(@)
        job = port.port.jobs[jobDiv.attr('data-key')]
        updateJob job, jobDiv

    # The page has been rendered. Once the player clicks "done", start the day.
    $('form', element).submit (e)->
      e.preventDefault()
      # If there is still unassigned crew then stop here.
      if $('.crew .person-info', element).length then return false
      $('.jobs > div', element).each ->
        jobDiv = $ @
        # Bypass jobs with no one assigned to them
        unless jobDiv.find('.person-info').length
          return
        jobKey = jobDiv.attr 'data-key'
        job = port.port.jobs[jobKey]
        console.log job
        # A job is valid if all of its non-optional slots are filled.
        context = job.updateFromDiv jobDiv
        console.log context
        unless context
          return
        # The job is good, push it onto the "upcoming pages" array.
        $.extend job, context
        g.queue.push job
      # The player comes back to the port screen once all jobs have been resolved.
      g.queue.push port
      # All jobs have now been processed. Trigger the first one.
      setTimeout (-> g.queue.shift().show(); Game.gotoPage()), 0
      return false

  next: false
