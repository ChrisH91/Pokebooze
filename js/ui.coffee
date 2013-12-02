class @UI
  constructor: ->
    @playerMenuCount = 1

    @rollButton = $('#roll-button')
    @playerInput = $('.player-input')
    @startButton = $('#start-game')
    @flashDiv = $('#flash')
    @flashLength = 3000
    @bindings()

  bindings: ->
    @startButton.on("click", =>
      _startGame()
    )

    @playerInput.on "focus", (event) =>
      _duplicateInput event, @

  populatePlayerSelectMenu: (players) ->
    console.log @
    for player, key in players
      @_addPlayerSelectButton player.name, key
  
  _addPlayerSelectButton: (name, playerNo) ->
    button = $("<button id='player-select-" + playerNo + "' type='button' class='select_player' data-player='" + playerNo + "'
                 style='background-color: " + Player.COLORS[playerNo % Player.COLORS.length] + "'>" + name + "</button>")
    $("#player-select").append button


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

  _disableButton: (button) ->
    $(button).prop('disabled', true)
    $(button).addClass('disabled')

  _enableButton: (button) ->
    $(button).prop('disabled', false)
    $(button).removeClass('disabled')

  _duplicateInput = (event, ui) =>
    el = event.currentTarget
    if el.dirty?
      return
    else
      clone = $(el).clone()
      ++ ui.playerMenuCount
      $(clone).attr("placeholder", "Player " + ui.playerMenuCount + "'s Name")
      clone.on "focus", (event) =>
        _duplicateInput event, ui
      $('#players-input').append(clone)
      el.dirty = true

  _startGame = =>
    names = []
    for input in $(".player-input")
      name = $(input).val()
      if name.trim().length > 0
        names.push(name)

    $('.new-game').hide()
    window.pokebooze.start(names)
