$(document).ready ->
  window.pokebooze = new Pokebooze
  ### 
  EXAMPLE OF LOAD GAME:
  ###
  pokebooze.loadGame {
    players: [{
      name: "Matt"
      position: 28
    }
    {
      name: "Kris"
      position: 28
    }]
  }
