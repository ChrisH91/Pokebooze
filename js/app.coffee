tileCoords = [
  [0.1, 0.1],
  [0.2, 0.1],
  [0.3, 0.1],
  [0.4, 0.1],
  [0.5, 0.1],
]

game = new Game
game.players.push(new Player)

for pair in tileCoords
  tile = new Tile(pair[0], pair[1])
  game.tiles.push tile

$(document).ready ->
  painter = new Painter(document.getElementById('table'), game)
  painter.drawBoard("/images/game.jpg", 1200, 1200)

