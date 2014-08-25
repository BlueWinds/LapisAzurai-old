updateJob = (job, jobDiv)->
  workers = {}
  $('.person-info', jobDiv).each ->
    key = $(@).attr('data-key')
    person = g.crew[key]
    workers[key] = person
  if job.updateFromDiv(jobDiv)
    jobDiv.addClass('ready')
  else
    jobDiv.removeClass('ready')
  $('.job-requirements').replaceWith(job.requiresBlock(workers))

Page.Port = class Port extends Page
  conditions:
    port: '|location'
  text: ->
    jobs = []
    jobLabels = []
    for key, job of @port.jobs when job instanceof Job or job.prototype instanceof Job
      if typeof job is 'function'
        job = @port.jobs[key] = new job
      unless job.contextMatch()
        continue
      for worker of job.workers
        delete job.context[worker]
      jobs.push job.renderBlock key
      jobLabels.push """<li class="list-group-item">#{job.label}</li>"""
    crew = (person.renderBlock(key) for key, person of g.crew)

    return """<page class="screen" style='background-image: url("#{if g.weather is 'calm' then @port.images.day else @port.images.storm}");'>
      <form>
        <div class="col-sm-2">
          <ul class="job-tabs list-group">#{jobLabels.join ''}</ul>
        </div>
        <div class="col-sm-4">
          <div class="jobs">#{jobs.join ''}</div>
        </div>
        <div class="col-sm-4">
          <div class="crew">#{crew.join ''}</div>
        </div>
        <button class="btn btn-primary center-block" disabled>Done</button>
      </form>
      <text class="short">#{@port.description()}</text>
    </page>"""
  apply: (element)->
    port = @context.port
    $('.job', element).first().addClass 'fish active'
    $('.job-tabs li', element).first().addClass 'active'
    $('.job-tabs li', element).click ->
      $('.job, .job-tabs li', element).removeClass 'active'
      $(@).addClass 'active'
      idx = $('.job-tabs li').index(@)
      $('.job', element).eq(idx).addClass 'active'

    people = $('.person-info', element)
    people.click -> $(@).toggleClass('active')

    $('.job', element).click (e)->
      # If we click inside a person-div, then activate / deactivate them, but don't move everyone else.
      if $(e.target).closest('.person-info').length
        return

      jobDiv = $(@)
      job = port.jobs[jobDiv.attr('data-key')]
      $('.person-info.active', element).each ->
        personDiv = $(@)

        # If this person is already working this job, skip them.
        if personDiv.closest(jobDiv).length
          return

        person = g.crew[personDiv.attr('data-key')]
        # Find an unoccupied slot that the person matches, and put them there.
        for key, conditions of job.workers
          slotDiv = $('li[data-slot="' + key + '"]', jobDiv)
          if $('.person-info', slotDiv).length
            continue
          unless person.matches(conditions)
            continue

          slotDiv.prepend(personDiv)
          personDiv.removeClass('active')
          return
      if $('.crew .person-info', element).length is 0
        $('button', element).removeAttr('disabled')
      # Now that all the crew-elements are in the right spot, update the job's context with its new workers, any maybe mark it as ready to go.
      updateJob(job, jobDiv)

    # Move all active crew back into holding, then update the jobs they may have been removed from
    $('.crew', element).click (e)->
      if $(e.target).closest('.person-info').length
        return
      if $('.person-info.active', element).length
        $('button', element).attr 'disabled', true
        $('.person-info.active', element).appendTo @
        .removeClass('active')
      $('.job', element).each ->
        jobDiv = $(@)
        job = port.jobs[jobDiv.attr('data-key')]
        updateJob(job, jobDiv)

    # The page has been rendered. Once the player clicks "done", start the day.
    $('form', element).submit (e)->
      e.preventDefault()
      # If there is still unassigned crew then stop here.
      if $('.crew .person-info', element).length then return false
      $('.jobs > div', element).each ->
        jobDiv = $(@)
        # Bypass jobs with no one assigned to them
        unless jobDiv.find('.person-info').length
          return
        jobKey = jobDiv.attr('data-key')
        job = port.jobs[jobKey]
        # A job is valid if all of its non-optional slots are filled.
        context = job.updateFromDiv(jobDiv)
        unless context
          return
        # The job is good, push it onto the "upcoming pages" array.
        g.queue.push(job)
      # All jobs have now been processed. Trigger the first one.
      setTimeout((->Game.gotoPage(1, true)), 0)
      return false

  next: false

# At the start of each game day, put the port back at the end of the "todo" list of pages.
Game.passDay.push ->
  @queue.push new Page.Port
