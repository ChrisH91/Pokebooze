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
    @dontMove = false
    @missTurn = 0
    @tileState = 0
    Player.PLAYER_COUNT += 1
    @name = name

  move: (forwards = true) ->
    if forwards
      @position += 1
    else
      @position -= 1

  rgbColor: () ->
    'rgb('+@color[0]+','+@color[1]+','+@color[2]+')'

  rgbaColor: (a) ->
    'rgba('+@color[0]+','+@color[1]+','+@color[2]+','+a+')'
