class @Game
  constructor: () -> 
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

  roll: =>
    roll = Math.ceil((Math.random()) * 1)
    @rollOutput.html(roll)

    roll

  nextPlayer: =>
    @currPlayer += 1
    if @currPlayer >= @players.length
      @currPlayer = 0   
  
  turn: =>
    while @players[@currPlayer].missTurn > 0
      console.log "Skipping player: " + @currPlayer
      @players[@currPlayer].missTurn -= 1
      ++@currPlayer
      if @currPlayer >= @players.length
        @currPlayer = 0 

    result = @board.tiles[@players[@currPlayer].position].logic this
 
    ###if not @players[@currPlayer].dontMove
      # TODO: Run player callback from previous turn if it exists
      @movePlayer @players[@currPlayer], playerRoll, () =>
          # TODO: Add miss turn logic to player
          tileResult = @board.tiles[@players[@currPlayer].position].logic playerRoll

          if tileResult.rollAgain
            if tileResult.dontMove 
              @players[@currPlayer].dontMove = true
          else
             if tileResult.missTurn
                @players[@currPlayer].missTurn = true  


    else
      @players[@currPlayer].dontMove = false
      @currPlayer += 1
      if @currPlayer >= @players.length
        @currPlayer = 0
