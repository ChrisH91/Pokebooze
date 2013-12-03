class @UI
  constructor: ->
    @playerMenuCount = 1

    @_rollButton = $('#roll-button')
    @_playerInput = $('.player-input')
    @_startButton = $('#start-game')
    @_flashDiv = $('#flash')
    @_rollOutput = $('#roll-output')
    @_flashLength = 500
    @bindings()

  bindings: ->
    window.onbeforeunload = ->
      "Woah, if you refresh the page you'll lose all your 'progress'!"
    @_startButton.on("click", =>
      _startGame()
    )

    @_playerInput.on "focus", (event) =>
      _duplicateInput event, @

  animateRoll: ->
    Music.playDice()
    spins = 10
    delay = 50 #ms
    number = 1
    setNumber = =>
      if spins > 0
        setTimeout(setNumber, delay)
        if number == 6
          number = 1
        else 
          number += 1
        @displayRoll(number)
        spins -= 1

    setTimeout(setNumber, 250) 

  displayRoll: (number) ->
    @_rollOutput.html number

  enableRoll: ->
    @_enableButton @_rollButton

  disableRoll: ->
    @_disableButton @ui_rollButton

  populatePlayerSelectMenu: (players) ->
    console.log @
    for player, key in players
      @_addPlayerSelectButton player.name, key

  indicatePlayer: (playerId) ->
    $('.players li').removeClass("current", {duration: 500})
    $('#player-'+playerId).addClass("current", {duration: 500})

  
  _addPlayerSelectButton: (name, playerNo) ->
    button = $("<button id='player-select-" + playerNo + "' type='button' class='select_player' data-player='" + playerNo + "'
                 style='background-color: " + Player.COLORS[playerNo % Player.COLORS.length] + "'>" + name + "</button>")
    $("#player-select").append button


  flash: (title, message="") ->
    contents = "<h1>"+title+"</h1>"
    if message.length > 0
      contents += "\n<p>"+message+"</p>"
    @_flashDiv.hide()
    @_flashDiv.removeClass("hidden")
    @_flashDiv.fadeIn(100)
    @_flashDiv.html(contents)
    setTimeout(=>
      $(@_flashDiv).fadeOut(500)
    , @_flashLength)

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
