fs = require 'fs'
shell = require('shelljs')

module.exports = (grunt)->
  grunt.registerTask 'dump', ->
    data = dumpObj()
    html = for event, text of data when text.length
      label = event.replace(/([a-z])([A-Z0-9])/g, "$1 $2")
      "<div class='event'><h1 id='#{event}'>#{label}</h1>#{text.join "\n"}</div>"

    html = """<html><head>
      <meta charset="UTF-8">
      <style>page {
        padding-top: 10px;
        padding-bottom: 10px;
        display: block;
        border-bottom: 1px solid;
      }</style>
    </head><body>
      #{html.join "\n"}
    </body></html>"""

    html = html.replace(/<\/?q>/g, '"')
    html = html.replace(/#\{q.*?\}/g, '"')
    fs.writeFileSync 'public/dump.html', html
    return data

dumpObj = ->
  command = '''ag --no-numbers --nogroup -C 0 'class (.+?) extends|"""[\\s\\S\\n]+?"""' src/content/'''
  result = shell.exec command, {silent: true}
  data = {}

  _class = null
  for line in result.output.split("\n") when line
    line = line.replace /"""/g, ''
    line = line.replace 'text: ->', ''
    line = line.replace 'description: ->', ''
    if line.match(/class (.+?) extends/)
      _class = line.match(/class (.+?) extends/)[1]
      data[_class] or= []
    else if line.match(/\|\|/)
      end = if data[_class].length then '</page>' else ''
      data[_class]?.push "#{end}<page><p><em>#{line.match(/\|\|(.*)/)[1]}</em></p>"
    else
      data[_class]?.push "<p>#{line.match(/\.coffee:(.*)/)[1]}</p>"
  return data
