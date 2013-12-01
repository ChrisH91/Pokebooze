class @UI
  constructor: ->
    @rollButton = $('#roll-button')
    @playerInput = $('.player-input')
    @startButton = $('#start-game')
    @bindings()

  bindings: ->
    @rollButton.on("click", ->
      _disableButton(@)
    )
    @startButton.on("click", =>
      _startGame(@playerInput)
    )
    # @playerInput.focus(_duplicateInput)

  _disableButton = (button) ->
    $(button).prop('disabled', true)
    $(button).addClass('disabled')
    setTimeout(=>
      _enableButton(button)
    , 2000)

  _enableButton = (button) ->
    $(button).prop('disabled', false)
    $(button).removeClass('disabled')

  _duplicateInput = (event) ->
    console.log @
    if @dirty?
      return
    else
      clone = $(@).clone()
      $(clone).focus(_duplicateInput)
      $('#players-input').append(clone)
      @dirty = true

  _startGame = (playerInputs) ->
    names = []
    for input in playerInputs
      name = $(input).val()
      if name.trim().length > 0
        names.push(name)

    $('.new-game').hide()
    window.pokebooze.start(names)