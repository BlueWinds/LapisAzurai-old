months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

Page.Load = class Load extends Page
  text: ->
    rows = for key in Object.keys(localStorage).sort().reverse()
      date = new Date parseInt(key, 10)
      unless date.getTime() then continue
      try
        game = new Game jsyaml.safeLoad(localStorage[key])
      catch e
        continue

      blob = new Blob [localStorage[key]], {type: 'text/plain'}
      blob = URL.createObjectURL blob

      # game.money might not be defined in older saves. Be boring and just misreport it as 0.
      name = "Day #{game.day} - #{game.location} - #{game.money or 0}β"
      row = [
        name
        "#{months[date.getMonth()]} #{date.getDate()}, #{date.getHours()}:#{date.getMinutes()}"
        """<button class="btn btn-xs btn-primary">Load</button>
          <a class="btn btn-xs btn-link" download="#{name}.yaml" href="#{blob}">Export</a>
          <button class="btn btn-xs btn-link">Delete</button>"""
      ].join('</td><td>')
      "<tr game='#{key}'><td>" + row + '</td></tr>'

    table = """<table class="table table-striped table-hover">
      <tr><td colspan="3"><input type="file"></td></tr>
      #{rows.join("\n")}
    </table>""".replace(/\n/g, '')

    element = $.render """|| class="screen load"
      <div class="col-lg-6 col-lg-offset-3 col-sm-8 col-sm-offset-2 col-xs-12">#{table}</div>
    """

    $('input', element).change ->
      unless file = @files[0]
        return
      reader = new FileReader()
      reader.onload = =>
        $('.import-error', element).remove()
        try
          window.g = new Game jsyaml.safeLoad(reader.result)
          $('#content').empty()
          g.last.show()
          g.setGameInfo()
          Game.gotoPage()
        catch e
          error = $ '<tr class="import-error danger"><td colspan="3">That doesn\'t seem to be a valid save file.</td></tr>'
          $(@).parent().parent().after(error)
          error.css('opacity', 0).animate({opacity: 1}, 1000)
          error.animate {opacity: 0}, 2500
        return

      reader.readAsText file

    $('button', element).click ->
      row = $(@).closest('tr')
      key = row.attr 'game'
      if $(@).html() is 'Delete'
        delete localStorage[key]
        row.remove()
        return
      if $(@).html() is 'Export'
        name = $(@).parent().prev().prev().html()

        link = $("<a class='btn btn-xs btn-link'>Export</a>")
        link.replaceAll(@)
        link.attr('href', blob)
        link.attr('download', name)
        link.click()
        return

      window.g = new Game jsyaml.safeLoad(localStorage[key])
      $('#content').empty()
      g.last.show()
      g.setGameInfo()
      Game.gotoPage()

    return element
  next: false
