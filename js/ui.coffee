class @UI
  constructor: ->
    @rollButton = $('#roll-button')
    @playerInput = $('.player-input')
    @startButton = $('#start-game')
    @flashDiv = $('#flash')
    @flashLength = 3000
    @bindings()

  bindings: ->
    @rollButton.on("click", ->
      _disableButton(@)
    )
    @startButton.on("click", =>
      _startGame(@playerInput)
    )
    # @playerInput.focus(_duplicateInput)

  flash: (title, message="") ->
    contents = "<h1>"+title+"</h1>"
    if message.length > 0
      contents += "\n<p>"+message+"</p>"
    @flashDiv.hide()
    @flashDiv.removeClass("hidden")
    @flashDiv.fadeIn(100)
    @flashDiv.html(contents)
    setTimeout(=>
      $(@flashDiv).fadeOut(500)
    , @flashLength)

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

