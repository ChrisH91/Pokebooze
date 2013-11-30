class @Player
  @PLAYER_COUNT = 0
  constructor: () ->
    @position = 0
    @player_number = Player.PLAYER_COUNT
    @color =  [
                Math.round(Math.random()*255), 
                Math.round(Math.random()*255), 
                Math.round(Math.random()*255)
              ]
    Player.PLAYER_COUNT += 1

  move: () ->
    @position += 1