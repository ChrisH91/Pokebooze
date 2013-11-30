$(document).ready ->
  # Draw plotter helper points on their own layer
  window.plotter = new Plotter $("#table"), stage
  game = setupGame(tileCoords)
  stage = setupStage()
  drawBoard(stage, game)
  drawTiles(stage, game)
  drawPlayers(stage, game)


setupGame = (tileCoords) ->
  game = new Game
  for i in [0..3]
    p = new Player
    game.players.push(p)

  for pair in window.tileCoords
    tile = new Tile(pair.x, pair.y)
    game.tiles.push tile

  return game

setupStage = ->
  new Kinetic.Stage {
          container: 'table'
          width: window.innerWidth
          height: window.innerHeight
        }

drawBoard = (stage, game) ->
  # Draw the board on its own layer
  boardLayer = new Kinetic.Layer
  boardObj = new Image
  boardObj.onload = =>
    board = new Kinetic.Image {
      x: 0
      y: 0
      image: boardObj
      width: game.board.edgeLength
      height: game.board.edgeLength
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
      x: game.board.edgeLength * tile.x
      y: game.board.edgeLength * tile.y
      # radius: 5
      # fill: 'red'
      # stroke: 'black'
      # strokeWidth: 2
    }
    tileLayer.add(circle)
  stage.add(tileLayer)

drawPlayers = (stage, game) ->
  # Draw the players on their own layer
  playerLayer = new Kinetic.Layer
  for player in game.players
    rect = new Kinetic.Rect {
      x: game.board.edgeLength * game.tiles[player.position].x
      y: game.board.edgeLength * game.tiles[player.position].y
      width: game.board.playerLength
      height: game.board.playerLength
      fill: 'rgb('+player.color[0]+','+player.color[1]+','+player.color[2]+')'
      stroke: 'black'
      strokeWidth: 2
    }
    player.node = rect
    playerLayer.add(rect)

  stage.add(playerLayer)

