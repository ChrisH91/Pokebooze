class @Game
  @RIGGED_ROLL = null
  constructor: (@ui) -> 
    @players = []
    @currPlayer = 0
    @rollOutput = $('#roll-output')
    @board = new Board
    @camera = new Camera(@board)

    $('#roll-button').on("click", @turn)

  movePlayer: (player, steps, callback) ->
    direction = steps > 0
    position = player.move(direction)
    @camera.rotateToPoint(@board.tileRotation(player.position))
    @camera.zoomToPoint(@board.tilePosition(player.position), => @_playerMove(player, steps, callback))
  
  _movePlayer: (player, steps, callback) =>
    if steps is 0
      return callback()
    
    direction = steps > 0
    position = player.move(direction)
    tile = @board.tiles[position]
    @_playerMove(player, steps, callback)

    @camera.rotateToPoint(@board.tileRotation(player.position))
    @camera.zoomToPoint(@board.tilePosition(player.position))

  _playerMove: (player, steps, callback) ->
    randomness = (Math.random()-0.5) * 2 * @board.playerSize
    tween = new Kinetic.Tween {
      node: player.node
      x: @board.tiles[player.position].x * @board.boardWidth + randomness
      y: @board.tiles[player.position].y * @board.boardWidth + randomness
      duration: 0.3
      onFinish: =>
        if @board.tiles[player.position].stop 
          steps = 0
        else
          steps = if steps > 0 then steps - 1 else steps + 1

        @_movePlayer(player, steps, callback)        
    }
    tween.play()

  playerSelectionDialogue: (callback) ->
    $(".select_player").prop "disabled", false
    $(".select_player").removeClass("disabled")
    $("#player-select-" + @currPlayer).prop "disabled", true
    $("#player-select-" + @currPlayer).addClass("disabled")

    $(".choose-player").show()
    $(".select_player").unbind "click"
    $(".select_player").click (e) ->
      playerNo = $(@).data "player"
      $(".choose-player").hide()
      callback playerNo

  ssAnneDialogue: (callback) ->
    $("#ss-anne").show()
    $(".ssanne").unbind "click"
    $(".ssanne").click (e) ->
      option = $(@).data "option"
      $("#ss-anne").hide()
      callback option

  roll: (callback) =>
    setTimeout(=>
      if Game.RIGGED_ROLL?
        roll = Game.RIGGED_ROLL
        Game.RIGGED_ROLL = null
      else
        roll = Math.ceil((Math.random()) * 6 * @players[@currPlayer].rollMultiplier)
        @players[@currPlayer].rollMultiplier = 1
      @rollOutput.html(roll)

      callback(roll)
    , 1000)

  nextPlayer: =>
    @currPlayer += 1
    if @currPlayer >= @players.length
      @currPlayer = 0   
  
  turn: =>
    @ui.indicatePlayer(@currPlayer)
    @ui._disableButton(@ui.rollButton)

    while @players[@currPlayer].missTurn > 0
      console.log "Skipping player: " + @currPlayer
      @players[@currPlayer].missTurn -= 1
      ++@currPlayer
      if @currPlayer >= @players.length
        @currPlayer = 0 

    @roll (playerRoll) =>
      @board.tiles[@players[@currPlayer].position].logic this, playerRoll
