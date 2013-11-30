tileCoords = [
  [0.1, 0.1],
  [0.2, 0.1],
  [0.3, 0.1],
  [0.4, 0.1],
  [0.5, 0.1],
]

$(document).ready ->

  game = new Game
  game.players.push(new Player)

  for pair in tileCoords
    tile = new Tile(pair[0], pair[1])
    game.tiles.push tile

  stage = new Kinetic.Stage {
          container: 'table'
          width: 1200
          height: 1200
        }

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
  boardObj.src = "/images/game.jpg"
