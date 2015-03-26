Page.SailEvent = class SailEvent extends Page
  text: ->
    jobs = $('')
    for job, key in @asArray()
      jobs = jobs.add job.renderBlock(key)
      jobs.last().data 'job', job

    Array::sort.call(jobs, Job.jobSort)

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    page = $.render """|| verySlow="true" class="screen sail" bg="Ship.#{img}"
      <div class="col-xs-8 col-xs-offset-2"></div>
    """
    $('.col-xs-8', page).append jobs
    jobs.wrap('<div class="col-xs-6"></div>')

    return sailClick page

  apply: ->
    for key, job of g.map.Ship.jobs when job instanceof Job or job.prototype instanceof Job
      if typeof job is 'function'
        job = g.map.Ship.jobs[key] = new job
      job.contextFill()
      unless job.contextMatch()
        continue
      if job.type is 'plot'
        while @context.length then @context.pop()
        @context.push job
        break
      @context.push job

    super()
    g.passDay()
  next: false

sailClick = (element)->
  $('.job', element).click (e)->
    e.preventDefault()
    g.queue.unshift $(@).data('job')

    Game.gotoPage()
    return false

  return element
