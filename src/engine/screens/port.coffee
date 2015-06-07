updateJob = (jobDiv)->
  unless jobDiv.length then return
  job = jobDiv.data('job')
  workers = {}

  index = jobDiv.parent().children().index jobDiv
  divs = jobDiv.add $('.job-tabs li', jobDiv.closest('page')).eq index
  divs.removeClass('ready')
  $('.person-info', jobDiv).each ->
    key = $(@).attr('data-key')
    person = g.crew[key]
    workers[key] = person
  job.updateFromDiv(jobDiv)
  if job.contextReady()
    divs.addClass 'ready'

  newText = job.text.call(job.context).replace(/\n/g, "<br>")
  $('.job-description', jobDiv).html(newText).addTooltips()

ordering =
  plot: 0
  special: 1
  normal: 2

Job.jobSort = (j1, j2)->
  t1 = $(j1).data('job').type
  t2 = $(j2).data('job').type
  return ordering[t1] - ordering[t2]

noSail = ->
  if (for key, mission of g.missions then mission.blockSailing).some(Boolean)
    "You can't sail until you finish one of your missions"
  else if g.weather is 'storm'
    "You can't set sail during a storm"
  else if g.crew.length < 3
    "You can't set sail with fewer than three sailors"
  else
    ""

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
    [jobs, jobLabels] = getJobDivs(@port.jobs)

    jobs = Array::sort.call(jobs, Job.jobSort)
    jobLabels = Array::sort.call(jobLabels, Job.jobSort)

    officers = (person.renderBlock(key) for key, person of g.officers)
    crew = (person.renderBlock(key) for key, person of g.crew)

    form = """<form class="clearfix">
      <div class="col-md-2">
        <ul class="job-tabs list-group"></ul>
      </div>
      <div class="col-lg-4 col-md-5">
        <div class="jobs column-block"></div>
      </div>
      <div class="col-lg-4 col-md-5">
        <div class="crew clearfix column-block">#{officers.join('') + crew.join('')}</div>
      </div>
    </form>""".replace(/\n/g, '')

    page = $.render """|| speed="verySlow" class="screen" bg="day|storm"
      #{form}
      --.
        #{@port.description?() or @port.description}
        #{options ['Work in ' + @port, 'Set Sail'], ["All officers must have an assignment", noSail()]}
    """
    $('.jobs', page).append(jobs)
    $('.job-tabs', page).append(jobLabels)

    applyPort.call @, page
    return page

  next: false

getJobDivs = (jobs)->
  jobDivs = $('')
  jobLabels = $('')

  maybeAddJob = (key, job)->
    job.contextFill()
    unless job.contextMatch() then return

    jobDivs = jobDivs.add job.renderBlock(key)
    jobDivs.last().data 'job', job
    jobLabels = jobLabels.add """<li class="#{job.type or 'normal'} list-group-item #{if job.isNew() then 'new' else ''}">#{job.label}</li>"""
    jobLabels.last().data 'job', job

  for key, job of jobs when job instanceof Job or job.prototype instanceof Job
    if typeof job is 'function'
      job = jobs[key] = new job
    maybeAddJob(key, job)

  for job, key in Job.universal
    maybeAddJob(key, new job)

  return [jobDivs, jobLabels]

applyPort = (element)->

  $('.job', element).first().addClass 'active'
  $('.job-tabs li', element).first().addClass('active')
  $('.job-tabs li', element).click ->
    $('.job, .job-tabs li', element).removeClass 'active'
    $(@).addClass 'active'
    idx = $('.job-tabs li', element).index @
    $('.job', element).eq(idx).addClass 'active'
    setTall.call(element)
  setTimeout setTall.bind(element), 0

  people = $('.person-info', element)
  people.click -> $(@).toggleClass 'active'

  $('.job', element).click (e)->
    # If we click inside a person-div, then activate / deactivate them, but don't move everyone else.
    if $(e.target).closest('.person-info').length then return

    jobDiv = $(@)
    job = jobDiv.data 'job'
    $('.person-info.active', element).each ->
      personDiv = $(@)
      if personDiv.closest(jobDiv).length then return
      assignPersonToJob(personDiv, job, jobDiv)

    $('.job', element).dblclick (e)->
      if $(e.target).closest('.person-info').length
        return
      $('.crew .person-info').addClass 'active'
      $(@).click()
      $('.crew .person-info').removeClass 'active'

    if $('.crew .person-info.officer', element).length is 0
      work.removeClass('dis').tooltip 'disable'
    # Now that all the crew-elements are in the right spot, update the job's context with its new workers, any maybe mark it as ready to go.
    updateJob(jobDiv)

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
      updateJob(jobDiv)

  # The page has been rendered. Once the player clicks "done", start the day.
  work = $('button', element).eq(0).addClass('dis')
  work.click doWorkClick

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

setTall = ->
  if $('.job.active', @).height() < $('.job-tabs', @).height()
    @addClass('tall-tabs')
  else
    @removeClass('tall-tabs')

assignPersonToJob = (personDiv, job, jobDiv)->
  key = personDiv.attr('data-key')
  person = g.officers[key] or g.crew[key]
  if job.energy < 0 and person.energy < -job.energy
    return

  if personDiv.hasClass('injured') and not job.acceptInjured
    return

  # Find an unoccupied slot that the person matches, and put them there.
  slot = person instanceof Officer and Collection::findIndex.call job.officers, (conditions, key)->
    slotDiv = $('li[data-slot="' + key + '"]', jobDiv)
    return $('.person-info', slotDiv).length is 0 and person.matches(conditions)

  slot = if slot
    $('li[data-slot="' + slot + '"]', jobDiv)
  else
    $('.job-crew', jobDiv)

  if slot.length
    prevJobDiv = personDiv.closest '.job'
    updateJob(prevJobDiv)

    personDiv.removeClass('active')
    slot.prepend(personDiv)

doWorkClick = (e)->
  if $(@).hasClass 'dis' then return
  e.preventDefault()
  element = $(e.target).closest 'page'

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
