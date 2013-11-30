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

    $('#roll-button').on("click", @turn)

  movePlayer: (player, steps, callback) ->
    if steps is 0
        callback()   
        return    

    position = player.move()
#    console.log position
    tile = @board.tiles[position]
    @rotateToTile(tile)
    tween = new Kinetic.Tween {
      node: player.node
      x: @board.tiles[player.position].x * @board.edgeLength
      y: @board.tiles[player.position].y * @board.edgeLength
      duration: 0.3
      onFinish: =>
        steps = steps - 1
        @movePlayer(player, steps, callback)
    }
    tween.play()

  rotateToTile: (tile) ->
#    console.log tile.x
    originX = 0.5
    originY = 0.5
    angle = Math.atan((tile.x-originX)/(tile.y-originY))
    # Always stay below origin (text upright)
    if originX < tile.x
      angle += Math.PI
    @_tweenBoard({rotation: angle})

  _tweenBoard: (transform) ->
    tween = new Kinetic.Tween {
      node: @board.node
      x: @board.edgeLength/2
      y: @board.edgeLength/2
      offsetX: @board.edgeLength/2
      offsetY: @board.edgeLength/2
      rotation: transform.rotation
    }
    tween.play()

  roll: =>
    roll = Math.ceil((Math.random())*6)
    @rollOutput.html(roll)

    roll

  turn: =>
    playerRoll = @roll()
    console.log playerRoll
    # TODO: Run player callback from previous turn if it exists
    @movePlayer @players[@currPlayer], playerRoll, () =>
        # TODO: Add miss turn logic to player
        tileResult = @board.tiles[@players[@currPlayer].position];
        console.log tileResult

        @currPlayer += 1
        if @currPlayer >= @players.length
          @currPlayer = 0
