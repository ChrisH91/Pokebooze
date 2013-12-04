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
      duration: (transform.duration or 0.3)
      easing: @_easing(transform)
      onFinish: callback
    }
    tween.play()

  rotateToPoint: (transform, callback) ->
    tween = new Kinetic.Tween($.extend({}, transform, @board.boardTransform(), {
      node: @board.node
      easing: @_easing(transform)
      onFinish: callback
      duration: (transform.duration or 0.3)
    }))
    tween.play()

  _easing: (transform) ->
    Kinetic.Easings.EaseInOut unless !transform.duration? or transform.duration < 0.01