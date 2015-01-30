updateJob = (job, jobDiv)->
  workers = {}

  index = jobDiv.parent().children().index jobDiv
  divs = jobDiv.add $('.job-tabs li', jobDiv.closest('page')).eq index
  divs.removeClass('ready half-ready')
  $('.person-info', jobDiv).each ->
    key = $(@).attr('data-key')
    person = g.crew[key]
    workers[key] = person
  job.updateFromDiv(jobDiv)
  if job.contextReady()
    divs.addClass 'ready'
  else if Object.keys(workers).length
    divs.addClass 'half-ready'

  $('.job-requirements').replaceWith(job.requiresBlock(workers))

ordering =
  plot: 0
  special: 1
  normal: 2

Job.jobSort = (j1, j2)->
  t1 = $(j1).data('job').type
  t2 = $(j2).data('job').type
  return ordering[t1] - ordering[t2]

Page.Port = class Port extends Page
  conditions:
    port: '|location'
  apply: ->
    for key, mission of g.missions
      unless mission.removeWhenDone
        continue
      passes = mission.tasks.filter (task)->
        unless task.conditions then return true
        return (new Collection).fill(task.conditions).matches task.conditions

      if passes.length is mission.tasks.length
        mission.removeAs key
    super()

  text: ->
    jobs = $('')
    jobLabels = $('')
    for key, job of @port.jobs when job instanceof Job or job.prototype instanceof Job
      if typeof job is 'function'
        job = @port.jobs[key] = new job
      job.contextFill()
      unless job.contextMatch()
        continue
      jobs = jobs.add job.renderBlock(key)
      jobs.last().data 'job', job
      jobLabels = jobLabels.add """<li class="#{job.type or 'normal'} list-group-item">#{job.label}</li>"""
      jobLabels.last().data 'job', job

    for job, key in Job.universal
      job = new job
      job.contextFill()
      unless job.contextMatch()
        continue
      jobs = jobs.add job.renderBlock(key)
      jobs.last().data 'job', job
      jobLabels = jobLabels.add """<li class="#{job.type or 'normal'} list-group-item">#{job.label}</li>"""
      jobLabels.last().data 'job', job

    jobs = Array::sort.call(jobs, Job.jobSort)
    jobLabels = Array::sort.call(jobLabels, Job.jobSort)

    officers = (person.renderBlock(key) for key, person of g.officers)
    crew = (person.renderBlock(key) for key, person of g.crew)
    noSail = if (for key, mission of g.missions then mission.blockSailing).some Boolean
      "You can't sail until you finish one of your missions"
    else if g.weather is 'storm'
      "You can't set sail during a storm"
    else if g.crew.length < 3
      "You can't set sail with fewer than three sailors"
    else
      ""

    page = $ """<page verySlow class="screen" bg="#{if g.weather is 'calm' then @port.images.day else @port.images.storm}">
      <form class="clearfix">
        <div class="col-md-2">
          <ul class="job-tabs list-group"></ul>
        </div>
        <div class="col-lg-4 col-md-5">
          <div class="jobs column-block"></div>
        </div>
        <div class="col-lg-4 col-md-5">
          <div class="crew clearfix column-block">#{officers.join('') + crew.join('')}</div>
        </div>
      </form>
      <text class="short">
        #{@port.description?() or @port.description}
        #{options ['Work in ' + @port, 'Set Sail'], ["All officers must have an assignment", noSail]}
      </text>
    </page>"""
    $('.jobs', page).append(jobs)
    $('.job-tabs', page).append(jobLabels)

    applyPort.call @, page
    return page

  next: false


applyPort = (element)->
  port = @port

  setTall = ->
    if $('.job.active', element).height() < $('.job-tabs', element).height()
      element.addClass('tall-tabs')
    else
      element.removeClass('tall-tabs')

  $('.job', element).first().addClass 'active'
  $('.job-tabs li', element).first().addClass('active')
  $('.job-tabs li', element).click ->
    $('.job, .job-tabs li', element).removeClass 'active'
    $(@).addClass 'active'
    idx = $('.job-tabs li', element).index @
    $('.job', element).eq(idx).addClass 'active'
    setTall()
  setTimeout setTall, 0

  people = $('.person-info', element)
  people.click -> $(@).toggleClass 'active'

  $('.job', element).click (e)->
    # If we click inside a person-div, then activate / deactivate them, but don't move everyone else.
    if $(e.target).closest('.person-info').length
      return

    jobDiv = $(@)
    job = jobDiv.data 'job'
    $('.person-info.officer.active', element).each ->
      personDiv = $(@)

      # If this person is already working this job, skip them.
      if personDiv.closest(jobDiv).length
        return

      person = g.officers[personDiv.attr('data-key')]
      if job.energy < 0 and person.energy < -job.energy
        return

      if personDiv.hasClass('injured') and not job.acceptInjured
        return

      prevJobDiv = personDiv.closest '.job'
      # Find an unoccupied slot that the person matches, and put them there.
      for key, conditions of job.officers
        slotDiv = $('li[data-slot="' + key + '"]', jobDiv)
        if $('.person-info', slotDiv).length
          continue
        unless person.matches(conditions)
          continue

        slotDiv.prepend(personDiv)
        personDiv.removeClass('active')
        break
      if prevJobDiv.length
        prevJob = port.jobs[prevJobDiv.attr('data-key')]
        updateJob(prevJob, prevJobDiv)

    $('.person-info.active', element).each ->
      personDiv = $(@)

      # If this person is already working this job, skip them.
      if (not job.crew?) or personDiv.closest(jobDiv).length
        return

      if personDiv.hasClass('injured') and not job.acceptInjured
        return

      key = personDiv.attr('data-key')
      person = g.officers[key] or g.crew[key]
      prevJobDiv = personDiv.closest '.job'

      $('.job-crew', jobDiv).append(personDiv)
      personDiv.removeClass('active')

      if prevJobDiv.length
        prevJob = port.jobs[prevJobDiv.attr('data-key')]
        updateJob(prevJob, prevJobDiv)

    if $('.crew .person-info.officer', element).length is 0
      work.removeClass('dis').tooltip 'disable'
    # Now that all the crew-elements are in the right spot, update the job's context with its new workers, any maybe mark it as ready to go.
    updateJob(job, jobDiv)

  # Move all active crew back into holding, then update the jobs they may have been removed from
  $('.crew', element).click (e)->
    if $(e.target).closest('.person-info').length
      return
    if $('.person-info.active', element).length
      $('button', element).eq(0).addClass('dis').tooltip 'enable'
      $('.person-info.active', element).appendTo @
      .removeClass('active')
    $('.job', element).each ->
      jobDiv = $(@)
      updateJob(jobDiv.data('job'), jobDiv)

  # The page has been rendered. Once the player clicks "done", start the day.
  work = $('button', element).eq(0).addClass('dis')
  work.click (e)->
    if $(@).hasClass 'dis' then return
    e.preventDefault()
    $('.jobs > div', element).each ->
      jobDiv = $(@)
      # Bypass jobs with no one assigned to them
      unless jobDiv.find('.person-info').length
        return
      job = jobDiv.data('job')
      # A job is valid if all of its non-optional slots are filled.
      job.updateFromDiv(jobDiv)
      if job.contextReady()
        # The job is good, shift it into the "upcoming pages" array. This reverses the ordering, so "normal" jobs come first, then special ones, then plot.
        g.queue.unshift(job)
    # All jobs have now been processed. Trigger the first one.
    setTimeout(Game.gotoPage, 0)
    return false

  sail = $('button', element).eq(1)
  if sail.attr('title')
    sail.addClass 'dis'
  sail.click (e)->
    if $(@).hasClass 'dis' then return
    e.preventDefault()

    (new Page.SetSail).show()
    setTimeout(Game.gotoPage, 0)

    return false

  return element
