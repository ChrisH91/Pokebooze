$(document).ready ->
  window.pokebooze = new Pokebooze
  setTimeout( -> 
    pokebooze.start(["Matt", "Chris"])
  , 1000)