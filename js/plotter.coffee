class @Plotter
    constructor: (element, stage) ->
        @tiles = []
        @stage = stage
        @element = element

        @plotterLayer = new Kinetic.Layer

    plotPoint: (event) ->
        tile = new Tile event.offsetX / @stage.getWidth(), event.offsetY / @stage.getHeight()
        @tiles.push tile

        # Draw a helper point on the canvas
        rect = new Kinetic.Rect {
          x: (@stage.getWidth() * tile.x) - 5
          y: (@stage.getHeight() * tile.y) - 5
          width: 10
          height: 10
          fill: 'rgb(0, 255, 255)'
          stroke: 'black'
          strokeWidth: 2
        }

        @plotterLayer.add rect
        @stage.add @plotterLayer

    activate: () ->
        _plotter = this

        @element.click (event) ->
            _plotter.plotPoint(event)
