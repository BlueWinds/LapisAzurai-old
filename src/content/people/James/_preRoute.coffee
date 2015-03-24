ShipJob.JamesUpset = class JamesUpset extends ShipJob
  label: "Talk with James"
  type: 'plot'
  text: ->"""James has been avoiding Natalie. Something's bothering him. They should talk."""

ShipJob.JamesUpset::next = Page.JamesUpset = class JamesUpset extends Page
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
  text: ->"""<page bg="Ship.cabinNight">
    #{@Nat.image 'serious', 'right'}
    <text>
      #{q}So, when're you going to say something?</q>
    </text>
  </page>
  <page>
    #{@James.image 'normal', 'left'}
    <text continue>
      #{q}What do you mean?</q> James didn't look in her direction, instead continuing his tallying of numbers.
    </text>
  </page>
  <page>
    #{@Nat.image 'serious', 'right'}
    <text continue>
      #{q}You're kidding me. What ever's got you so knotted up you look me in the eyes. Spit it out.</q>
    </text>
  </page>
  <page>
    #{@James.image 'serious', 'left'}
    <text>
      #{q}I don't want to talk about it. Let's just finish this.</q> He leaned over to check her numbers – they matched, arrived at independently.
    </text>
  </page>
  <page>
    #{@Nat.image 'serious', 'right'}
    <text continue>
      Natalie stole the pen out of his hand before he could use it to mark his paper, set it on the desk out of easy reach. #{q}Let's not. Let's talk.</q>
    </text>
  </page>
  <page>
    #{@James.image 'upset', 'left'}
    <text>
      #{q}I'm keeping my secret for now,</q> he stood and walked out.
    </text>
  </page>
  <page>
    <text continue>
      She considered catching him at the door, chasing him out onto deck, running after him down the plank... he was gone below deck while she still sat at her desk, considering what to do.
    </text>
  </page>"""
  effects:
    remove:
      '|map|Ship|jobs|jamesUpset': ShipJob.JamesUpset
