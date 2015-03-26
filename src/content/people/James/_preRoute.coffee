ShipJob.JamesUpset = class JamesUpset extends ShipJob
  label: "Talk with James"
  type: 'plot'
  text: ->"""James has been avoiding Natalie. Something's bothering him. They should talk."""

ShipJob.JamesUpset::next = Page.JamesUpset = class JamesUpset extends Page
  conditions:
    James: '|officers|James'
    Nat: '|officers|Nat'
  text: ->"""|| bg="Ship.cabinNight"
    #{@Nat.image 'serious', 'right'}
    -- #{q}So, when're you going to say something?</q>

  ||
    #{@James.image 'normal', 'left'}
    --> #{q}What do you mean?</q> James didn't look in her direction, instead continuing his tallying of numbers.

  ||
    #{@Nat.image 'serious', 'right'}
    --> #{q}You're kidding me. What ever's got you so knotted up you look me in the eyes. Spit it out.</q>

  ||
    #{@James.image 'serious', 'left'}
    -- #{q}I don't want to talk about it. Let's just finish this.</q> He leaned over to check her numbers – they matched, arrived at independently.

  ||
    #{@Nat.image 'serious', 'right'}
    --> Natalie stole the pen out of his hand before he could use it to mark his paper, set it on the desk out of easy reach. #{q}Let's not. Let's talk.</q>

  ||
    #{@James.image 'upset', 'left'}
    -- #{q}I'm keeping my secret for now,</q> he stood and walked out.

  ||
    --> She considered catching him at the door, chasing him out onto deck, running after him down the plank... he was gone below deck while she still sat at her desk, considering what to do.
"""
  effects:
    remove:
      '|map|Ship|jobs|jamesUpset': ShipJob.JamesUpset
