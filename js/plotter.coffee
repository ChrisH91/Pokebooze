class @Plotter
    constructor: (element, painter) ->
        @tiles = []
        @painter = painter
        @element = element
        _plotter = this

        @element.click (event) ->
            _plotter.plotPoint(event)

    plotPoint: (event) ->
        tile = new Tile event.offsetX / @element.width(), event.offsetY / @element.height()
        @painter.drawTile tile
        @tiles.push tile

        console.log @tiles