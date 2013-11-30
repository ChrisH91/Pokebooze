class @Player
  @PLAYER_COUNT = 0
  constructor: (name = "") ->
    @position = 0
    @player_number = Player.PLAYER_COUNT
    @color =  [
                Math.round(Math.random()*255)-50, 
                Math.round(Math.random()*255)-50, 
                Math.round(Math.random()*255)-50
              ]
    Player.PLAYER_COUNT += 1
    @name = name

  move: () ->
    @position += 1

  rgbColor: () ->
    'rgb('+@color[0]+','+@color[1]+','+@color[2]+')'