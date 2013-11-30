setupGame = (tileCoords) ->
  game = new Game
  game.players.push(new Player)

  for pair in window.tileCoords
    tile = new Tile(pair.x, pair.y)
    game.tiles.push tile

  return game

setupStage = ->
  new Kinetic.Stage {
          container: 'table'
          width: 1200
          height: 1200
        }

drawBoard = (stage) ->
  # Draw the board on its own layer
  boardLayer = new Kinetic.Layer
  boardObj = new Image
  boardObj.onload = =>
    board = new Kinetic.Image {
      x: 0
      y: 0
      image: boardObj
      width: 1200
      height: 1200
    }
    boardLayer.add(board)
    stage.add(boardLayer)
    boardLayer.moveToBottom()
    boardLayer.draw()

  boardObj.src = "/images/game.jpg"

drawTiles = (stage, game) ->
  # Draw the map tiles on their own layer
  tileLayer = new Kinetic.Layer
  for tile in game.tiles
    circle = new Kinetic.Circle {
      x: stage.getWidth() * tile.x
      y: stage.getHeight() * tile.y
      radius: 5
      fill: 'red'
      stroke: 'black'
      strokeWidth: 2
    }
    tileLayer.add(circle)
  stage.add(tileLayer)

drawPlayers = (stage, game) ->
  # Draw the players on their own layer
  playerLayer = new Kinetic.Layer
  for player in game.players
    rect = new Kinetic.Rect {
      x: stage.getWidth()   * game.tiles[player.position].x
      y: stage.getHeight()  * game.tiles[player.position].y
      width: 20
      height: 20
      fill: 'rgb('+player.color[0]+','+player.color[1]+','+player.color[2]+')'
      stroke: 'black'
      strokeWidth: 2
    }
    playerLayer.add(rect)

  stage.add(playerLayer)

  # Draw plotter helper points on their own layer
  window.plotter = new Plotter $("#table"), stage
  stage = setupStage()
  drawBoard(stage)
  drawTiles(stage, game)
  drawPlayers(stage, game)


