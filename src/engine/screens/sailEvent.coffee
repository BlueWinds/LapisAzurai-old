Page.SailEvent = class SailEvent extends Page
  text: ->
    jobs = $('')
    for job, key in @asArray()
      jobs = jobs.add job.renderBlock(key)
      jobs.last().data 'job', job

    Array::sort.call(jobs, Job.jobSort)

    img = Math.choice ['deckDay', 'deckNight', 'day', 'night']
    page = $("""<page verySlow class="screen sail" bg="#{g.map.Ship.images[img]}">
      <div class="col-xs-8 col-xs-offset-2">
      </div>
    </page>""")
    $('.col-xs-8', page).append jobs
    jobs.wrap('<div class="col-xs-6"></div>')

    return sailClick page

  apply: ->
    plot = false

    for key, job of g.map.Ship.jobs when job instanceof Job or job.prototype instanceof Job
      if typeof job is 'function'
        job = g.map.Ship.jobs[key] = new job
      job.contextFill()
      unless job.contextMatch()
        continue
      if job.type is 'plot'
        plot = true
        unless plot then g.queue.push plot
        continue
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