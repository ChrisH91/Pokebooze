class @Painter
  constructor: (group) ->
    @group = group

  paintTile: (transform) ->
    circle = new Kinetic.Circle($.extend({}, transform, {
      radius: 5
      fill: 'red'
      stroke: 'black'
      strokeWidth: 2
    }))
    @group.add(circle)

  paintBoard: (transform) ->
    # Draw the board on its own layer
    boardObj = new Image
    boardObj.onload = =>
      board = new Kinetic.Image($.extend({},transform, {
        image: boardObj
      }))
      @group.add(board)
      board.moveToBottom()
      @group.draw()

    boardObj.src = "/images/game.jpg"

  paintPlayer: (player, transform) ->
    rect = new Kinetic.Circle($.extend({}, transform, {
      fill: player.rgbaColor(0.6)
      stroke: 'black'
      strokeWidth: 2
    }))
    player.node = rect
    @group.add(rect)


