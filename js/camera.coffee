class @Camera
  constructor: (board) ->
    @board = board
    @scaleFactor = 2

  zoomToPoint: (transform, callback) ->
    tween = new Kinetic.Tween {
      node: @board.node
      offsetX: transform.x
      offsetY: transform.y
      scaleX: @scaleFactor
      scaleY: @scaleFactor
      duration: 0.3
      easing: Kinetic.Easings.EaseInOut
      onFinish: callback
    }
    tween.play()

  rotateToPoint: (transform, callback) ->
    tween = new Kinetic.Tween($.extend({}, transform, @board.boardTransform(), {
      node: @board.node
      easing: Kinetic.Easings.EaseInOut
      onFinish: callback
      duration: 0.3
    }))
    tween.play()