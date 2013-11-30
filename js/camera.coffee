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
    tween = new Kinetic.Tween {
      node: @board.node
      x: @board.tableWidth/2
      y: @board.tableHeight/2
      offsetX: @board.tableWidth/2
      offsetY: @board.tableHeight/2
      rotation: transform.rotation
      easing: Kinetic.Easings.EaseInOut
      onFinish: callback
      duration: 0.3
    }
    tween.play()