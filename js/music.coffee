class @Music

  @playClink: ->
    $('#sound-clink').trigger('play')

  @playDice: ->
    $('#sound-dice').trigger('play')

  @bindings: ->
    $('#roll-button').on("click", @playDice)