window.featureDetect = ->
  try
    localStorage.setItem 'test', 'testVal'
    unless localStorage.test is 'testVal'
      throw new Error
    localStorage.removeItem 'test'
  catch e
    $('body').append """<div class="col-lg-4 center">
      <h2>Browser Problems</h2>
      <div>Your browser won't currently run the game due to a lack of <em>Local Storage</em>. Depending on your browser, you have a couple of options.</div>
      <ul>
        <li><strong>First</strong> - Check to see if your browser is asking if you want to allow this site to store information on your computer, a popup or a bar along the top of the window. If it is, say yes and refresh the page.</li>
        <li><strong>Firefox</strong> - Options > Advanced - > Network = un-check "Tell me when a website asks to store data for offline use"</li>
        <li><strong>Chrome</strong> - Settings > Show Advanced Settings > Privacy > Content Settings > Cookies > Allow local data to be set.</li>
        <li><strong>Other</strong> - Unsure. You need to enable Local Storage. It's probably somewhere under the privacy settings in your browser.</li>
      </ul>
    </div>"""
    return

  return true
