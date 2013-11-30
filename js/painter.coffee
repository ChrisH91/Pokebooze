class @Painter
  constructor: (canvas, game) ->
    @game = game
    @canvas = canvas
    @ctx = canvas.getContext('2d')
    @board = new Image

  drawBoard: (src, width, height) ->
    @board.src = src
    @board.onload = =>
      setInterval(@_draw, 100, width, height)

  _draw: (width, height) =>
    @ctx.drawImage(@board, 0, 0, width, height)
    for tile in @game.tiles
      @drawTile tile

    for player in @game.players
      @drawPlayer player

  drawTile: (tile) ->
    x = @pixelfy tile.x
    y = @pixelfy tile.y
    @ctx.fillStyle = "#F00"
    @ctx.fillRect(x, y, 5, 5)

  drawPlayer: (player) ->
    @ctx.fillStyle = "rgb("+player.color[0]+","+player.color[1]+","+player.color[2]+")"
    currentTile = @game.tiles[player.position]
    @ctx.fillRect(@pixelfy(currentTile.x), @pixelfy(currentTile.y), 20, 20)

  pixelfy: (coord) ->
    coord * 1200