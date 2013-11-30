class @Board
  constructor: () ->
    @edgeLength = Math.min(window.innerWidth,window.innerHeight)
    @playerLength = @edgeLength/100
    @node = null
    @tiles = []

  build: (tileCoords) ->
    for tileCoord in tileCoords
      @tiles.push new Tile(
        tileCoord.x,
        tileCoord.y,
        tileCoord.stop,
        tileCoord.logic,
      )