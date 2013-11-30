class @Game
  constructor: () -> 
    @players = []
    @tiles = []
    @currPlayer = 0
    @rollOutput = $('#roll-output')
    @board = new Board

    $('#roll-button').on("click", @roll)

  movePlayer: (player, steps) ->
    return if steps is 0
    player.move()
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

  roll: =>
    roll = Math.ceil((Math.random())*6)
    console.log @currPlayer
    @rollOutput.html(roll)

    @movePlayer(@players[@currPlayer], roll)

    @currPlayer += 1
    if @currPlayer >= @players.length
      @currPlayer = 0