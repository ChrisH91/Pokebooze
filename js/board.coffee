class @Board
  constructor: () ->
    @boardWidth = 2000
    @boardHeight = 2000
    @playerSize = @boardWidth/100
    @node = null
    @tiles = []
    @tableWidth = window.innerWidth
    @tableHeight = window.innerHeight

  build: (tileCoords) ->
    for tileCoord in tileCoords
      @tiles.push new Tile(
        tileCoord.x,
        tileCoord.y,
        tileCoord.stop,
        tileCoord.logic,
      )

  tileRotation: (tileIndex) ->
    originX = 0.5
    originY = 0.5
    tile = @tiles[tileIndex]
    angle = Math.atan((tile.x-originX)/(tile.y-originY))
    # Always stay below origin (text upright)
    if originY > tile.y
      angle -= Math.PI
    {
      rotation: angle
    }

  tilePosition: (tileIndex) ->
    {
      x: @tiles[tileIndex].x * @boardWidth
      y: @tiles[tileIndex].y * @boardWidth
    }

  boardTransform: ->
    {
      x: @tableWidth/2
      y: @tableHeight/2
      offsetX: @tableWidth/2
      offsetY: @tableHeight/2
    }

  boardDimensions: ->
    {
      width: @boardWidth
      height: @boardWidth
    }

  playerDimensions: (player) ->
    {
      x: @boardWidth * @tiles[player.position].x
      y: @boardWidth * @tiles[player.position].y
      radius: @playerSize
    }

