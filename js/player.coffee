class @Player
  @PLAYER_COUNT = 0
  @COLORS = [
    # "#A8A77A" # General Type (Boring)
    "#EE8130" # Fire Type
    "#6390F0" # Water Type
    "#F7D02C" # Electric Type
    "#7AC74C" # Grass Type
    "#96D9D6" # Ice Type
    "#C22E28" # Fighting Type
    "#A33EA1" # Poison Type
    "#E2BF65" # Ground Type
    "#A98FF3" # Flying Type
    "#F95587" # Psychic Type
    "#A6B91A" # Bug Type
    "#B6A136" # Rock Type
    "#735797" # Ghost Type
    "#6F35FC" # Dragon Type
    "#705746" # Dark Type
    "#B7B7CE" # Steel Type
  ]
  constructor: (name = "") ->
    @position = 0
    @player_number = Player.PLAYER_COUNT
    @color = Player.COLORS[@player_number]
    @dontMove = false
    @pokeFlute = false
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
    @color

  rgbaColor: (a) ->
    color = @_hexToRgb(@color)
    'rgba('+color.r+','+color.g+','+color.b+','+a+')'

  _hexToRgb: (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    {
        r: parseInt(result[1], 16)
        g: parseInt(result[2], 16)
        b: parseInt(result[3], 16)
    }