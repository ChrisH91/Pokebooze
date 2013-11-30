class @Game
  constructor: () -> 
    @players = []
    @tiles = []


  movePlayer: (player, steps) ->
    player.move()
    tween = new Kinetic.Tween {
      x: @tiles[player.position].x * 1200
      y: @tiles[player.position].y * 1200
      duration: 0.3
    }
    tween.play()
    steps = steps - 1
    movePlayer(player, steps)