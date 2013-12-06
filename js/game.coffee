class @Game
  @RIGGED_ROLL = null
  constructor: (@ui) -> 
    @players = []
    @currPlayerIndex = 0
    @board = new Board
    @camera = new Camera(@board)

    $(window).on "turn", @turn

  currPlayer: ->
    @players[@currPlayerIndex]

  lookAtPlayer: (player, callback) =>
    @camera.rotateToPoint(@board.tileRotation(player.position))
    @camera.zoomToPoint(@board.tilePosition(player.position), callback)

  movePlayer: (player, steps, callback) =>
    direction = steps > 0
    position = player.move(direction)
    @lookAtPlayer(player, => @_playerMove(player, steps, callback))
  
  _movePlayer: (player, steps, callback) =>
    if steps is 0
      return callback()
    
    direction = steps > 0
    position = player.move(direction)
    tile = @board.tiles[position]
    @_playerMove(player, steps, callback)

    @lookAtPlayer(player)

  _playerMove: (player, steps, callback) =>
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

  playerSelectionDialogue: (callback) =>
    $(".select_player").prop "disabled", false
    $(".select_player").removeClass("disabled")
    if @players.length > 1 # otherwise we get stuck!
      $("#player-select-" + @currPlayerIndex).prop "disabled", true
      $("#player-select-" + @currPlayerIndex).addClass("disabled")

    $(".choose-player").show()
    $(".select_player").unbind "click"
    $(".select_player").click (e) ->
      playerNo = $(@).data "player"
      $(".choose-player").hide()
      callback playerNo

  ssAnneDialogue: (callback) =>
    $("#ss-anne").show()
    $(".ssanne").unbind "click"
    $(".ssanne").click (e) ->
      option = $(@).data "option"
      $("#ss-anne").hide()
      callback option

  roll: (callback) =>
    @ui.animateRoll()

    setTimeout( =>
      if Game.RIGGED_ROLL?
        roll = Game.RIGGED_ROLL
        Logger.log("Rolled a #{roll} rigged roll for player #{@currPlayer().name}")
        Game.RIGGED_ROLL = null
      else
        roll = Math.ceil((Math.random()) * 6 * @currPlayer().rollMultiplier)
        Logger.log("Rolled a #{roll} for player #{@currPlayer().name}")
        @currPlayer().rollMultiplier = 1
      @ui.displayRoll(roll)
      callback(roll)
    , 1000)

  nextPlayer: =>
    @currPlayerIndex = (@currPlayerIndex + 1) % @players.length
    Logger.log("Player incremented to #{@currPlayerIndex}")
  
  turn: =>
    @ui.indicatePlayer(@currPlayerIndex)
    @ui.disableRoll()

    Logger.log "Start of turn for #{@currPlayerIndex} - #{@currPlayer().name}"
    if @currPlayer().missTurn > 0
      Logger.log "Skipping player: #{@currPlayerIndex} - #{@currPlayer().name}"
      @ui.flash "Skipped turn!", "Skipping #{@currPlayer().name}'s turn!", 2000
      @currPlayer().missTurn -= 1
      @nextPlayer()
    else
      @roll (playerRoll) =>
        Logger.log "Firing logic for tile #{@currPlayer().position} with roll #{playerRoll}"
        @board.tiles[@currPlayer().position].logic this, playerRoll
