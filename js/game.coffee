class @Game
  constructor: () -> 
    @players = []
    @tiles = []
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

    $('#roll-button').on("click", @roll)

  movePlayer: (player, steps) ->
    return if steps is 0
    position = player.move()
    console.log position
    tile = @tiles[position]
    playerMove = =>
      tween = new Kinetic.Tween {
        node: player.node
        x: @tiles[player.position].x * @board.edgeLength
        y: @tiles[player.position].y * @board.edgeLength
        duration: 0.3
        onFinish: =>
          steps = steps - 1
          @_movePlayer(player, steps)        
      }
      tween.play()
    @rotateToTile(tile)
    @zoomToTile(tile, playerMove)
    tween = new Kinetic.Tween {
      node: player.node
      x: @tiles[player.position].x * @board.edgeLength
      y: @tiles[player.position].y * @board.edgeLength
      duration: 0.3
      onFinish: =>
        steps = steps - 1
        @movePlayer(player, steps)        
    }
    tween.play()

  rotateToTile: (tile) ->
    originX = 0.5
    originY = 0.5
    angle = Math.atan((tile.x-originX)/(tile.y-originY))
    # Always stay below origin (text upright)
    if originX < tile.x
      angle += Math.PI
    @_tweenBoard({rotation: angle})
  zoomToTile: (tile, callback) ->
    tween = new Kinetic.Tween {
      node: @board.node
      offsetX: tile.x * @board.edgeLength
      offsetY: tile.y * @board.edgeLength
      scaleY: 5
      duration: 0.3
      onFinish: callback
    }
    tween.play()

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
    console.log @currPlayer
    @rollOutput.html(roll)

    @movePlayer(@players[@currPlayer], roll)

    @currPlayer += 1
    if @currPlayer >= @players.length
      @currPlayer = 0