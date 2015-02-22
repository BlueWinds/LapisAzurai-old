fs = require 'fs'
shell = require('shelljs')

module.exports = (grunt)->
  grunt.registerTask 'dump', ->
    data = dumpObj()
    html = for event, text of data when text.length
      "<div class='event'><h1>#{event}</h1>#{text.join "\n"}</div>"

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
  result = shell.exec '''ag --no-numbers --nogroup -C 0 'class (.+?) extends|"""(<page[^~]+?</page>)"""' src/content/''', {silent: true}

  data = {}

  _class = null
  for line in result.output.split("\n") when line
    if line.match(/class (.+?) extends/)
      _class = line.match(/class (.+?) extends/)[1]
      data[_class] or= []
    else if line.match(/"""</)
      data[_class]?.push line.match(/"""(.*)/)[1]
    else if line.match(/>"""/)
      data[_class]?.push line.match(/.+?:#?(.*)"""/)[1]
    else
      data[_class]?.push line.match(/.+?:#?(.*)/)[1]
  return data
