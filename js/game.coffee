class @Game
  constructor: () -> 
    @players = []
    @currPlayer = 0
    @rollOutput = $('#roll-output')
    @board = new Board
    @boardTransform = {
      transform: {
        x: 0
        y: 0
      }
      scale: {
        x: 0
        y: 0
      }
      rotation: 0
    }
    @tableWidth = window.innerWidth
    @tableHeight = window.innerHeight

    $('#roll-button').on("click", @turn)

  movePlayer: (player, steps, callback) ->
    if steps is 0
        callback()
        return    

    tile = @board.tiles[player.position]
    @rotateToTile(tile)
    @zoomToTile(tile, => @_playerMove(player, steps, callback))
    position = player.move()

  _movePlayer: (player, steps, callback) =>

    if steps is 0
        callback()   
        return  
    
    position = player.move()
    tile = @board.tiles[position]
    @_playerMove(player, steps, callback)

    @rotateToTile(tile)
    @zoomToTile(tile)

  _playerMove: (player, steps, callback) ->
    randomness = (Math.random()-0.5) * 2 * @board.playerLength
    tween = new Kinetic.Tween {
      node: player.node
      x: @board.tiles[player.position].x * @board.edgeLength + randomness
      y: @board.tiles[player.position].y * @board.edgeLength + randomness
      duration: 0.3
      onFinish: =>
        if @board.tiles[player.position].stop 
            steps = 0
        else
            steps = steps - 1

        @_movePlayer(player, steps, callback)        
    }
    tween.play()

  rotateToTile: (tile, callback) ->
    originX = 0.5
    originY = 0.5
    angle = Math.atan((tile.x-originX)/(tile.y-originY))
    # Always stay below origin (text upright)
    if originY > tile.y
      angle -= Math.PI

    # angle %= Math.PI
    @_rotateBoard({rotation: angle}, callback)

  zoomToTile: (tile, callback) ->
    @zoomToPoint(tile.x, tile.y, callback)

  zoomToPoint: (x, y, callback) ->
    tween = new Kinetic.Tween {
      node: @board.node
      offsetX: x * @board.edgeLength
      offsetY: y * @board.edgeLength
      scaleX: 5
      scaleY: 5
      duration: 0.3
      easing: Kinetic.Easings.EaseInOut
      onFinish: callback
    }
    tween.play()

  _rotateBoard: (transform, callback) ->
    tween = new Kinetic.Tween {
      node: @board.node
      x: @tableWidth/2
      y: @tableHeight/2
      offsetX: @tableWidth/2
      offsetY: @tableHeight/2
      rotation: transform.rotation
      easing: Kinetic.Easings.EaseInOut
      onFinish: callback
      duration: 0.3
    }
    tween.play()

  roll: =>
    roll = Math.ceil((Math.random())*2)
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
        @currPlayer = 0 ###     
