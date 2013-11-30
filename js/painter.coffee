class @Painter
  constructor: (group) ->
    @group = group

  paintTile: ->

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

  paintPlayer: ->