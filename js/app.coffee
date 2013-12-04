$(document).ready ->
  Logger.LOG_ON = true
  window.pokebooze = new Pokebooze
###  EXAMPLE OF LOAD GAME:
  pokebooze.loadGame {
    players: [{
      name: "Matt"
      position: 98
    }
    {
      name: "Kris"
      position: 98
    }]
  }
###