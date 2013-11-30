$(document).ready ->
  window.pokebooze = new Pokebooze
  pokebooze.game.zoomToPoint(0.35,0.4)
  setTimeout( -> 
    pokebooze.start(["Matt", "Chris"])
  , 1000)