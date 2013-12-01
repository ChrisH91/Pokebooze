class @Pokebooze
  constructor: ->
    @setupGame()
    @setupStage()
    # @plotTiles()
    @baseGroup = @stage.children[0].children[0]
    @painter = new Painter(@baseGroup)
    @camera = new Camera(@game.board)
    @ui = new UI
    @game.board.node = @baseGroup
    boardTransform = $.extend({},@game.board.boardTransform(), @game.board.boardDimensions())
    @painter.paintBoard(boardTransform)
    @buildTiles()

  start: (playerNames) ->
    for name in playerNames
      @game.players.push(new Player name)
    @initializePlayers()

    setTimeout( => 
      @panToStart()
    , 1000)

  setupGame: () ->
    @game = new Game

  setupStage: ->
    @stage = new Kinetic.Stage {
            container: 'table'
            width: window.innerWidth
            height: window.innerHeight
          }
    layer = new Kinetic.Layer
    topGroup = new Kinetic.Group
    layer.add(topGroup)
    @stage.add(layer)
    @stage


  plotTiles: ->
    plotter = new Plotter $("#table"), @stage

  buildTiles: ->
    @game.board.build(Pokebooze.tileCoords)

  initializePlayers: ->
    playersList = $('.players')
    i = -2 * @game.board.playerSize
    for player in @game.players
      playerDimensions = @game.board.playerDimensions(player)
      rand = (Math.random()-0.5) * @game.board.playerSize
      @painter.paintPlayer(player,{
        x: playerDimensions.x + i
        y: playerDimensions.y + rand
        radius: playerDimensions.radius
        })
      i += @game.board.playerSize
      playersList.append("<li style='background-color: "+player.rgbColor()+"' class='player' id='player-1'><span class='icon'></span><span class='name'>"+player.name+"</span></li>")

    @baseGroup.draw()

  panToStart: =>
    @camera.rotateToPoint(@game.board.tileRotation(0), =>
      @camera.zoomToPoint(@game.board.tilePosition(0)))

  @helpers = 
    # Logic
    default: (game) ->
      playerRoll = game.roll()
      game.movePlayer game.players[game.currPlayer], playerRoll, () =>
        game.board.tiles[game.players[game.currPlayer].position].landLogic game, playerRoll

    zubat: (game) =>
      playerRoll = game.roll()

      if playerRoll isnt 1 and playerRoll isnt 2
        @helpers.default game
      else
        game.board.tiles[game.players[game.currPlayer].position].landLogic game, playerRoll

    tentacool: (game) =>
      console.log "Tentacool"
      playerRoll = game.roll()

      if playerRoll isnt 1 and playerRoll isnt 6
        console.log "Move"
        @helpers.default game

      @helpers.defaultLandLogic game, playerRoll      

    # Land Logic
    defaultLandLogic: (game, roll) ->
      game.nextPlayer()

    missTurn: (game, roll) =>
      game.players[game.currPlayer].missTurn = 1
      @helpers.defaultLandLogic game, roll



  @tileCoords = [
    {
        x: 0.45666666666666667
        y: 0.9358333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Ratatta
    {
        x: 0.3775
        y: 0.9175
        stop: false
        landLogic: (game, roll) =>
          if roll == 1
            game.players[game.currPlayer].tileState = 1
          else
            @helpers.defaultLandLogic

        logic: (game) =>
          if game.players[game.currPlayer].tileState == 1
            console.log "Re-rolling player " + game.currPlayer
            game.players[game.currPlayer].tileState = 0
            game.roll()
            game.nextPlayer()
          else
            @helpers.default game
    }
    # Caterpie
    {
        x: 0.29333333333333333
        y: 0.8816666666666667
        stop: false
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    #Pidgey
    {
        x: 0.22416666666666665
        y: 0.8425
        stop: false
        landLogic: (game, roll) =>
          # Don't do anything (Roll again)
        logic: @helpers.default
    }
    # Weedle
    {
        x: 0.16083333333333333
        y: 0.7808333333333334
        stop: false
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    # Metapod/Kakuna
    {
        x: 0.11416666666666667
        y: 0.7116666666666667
        stop: false
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    {
        x: 0.07916666666666666
        y: 0.635
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.06
        y: 0.5425
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.059166666666666666
        y: 0.45666666666666667
        stop: false
        landLogic: (game, roll) =>
          # Don't do anything (Roll again)
        logic: @helpers.default
    }
    {
        x: 0.07666666666666666
        y: 0.37
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Pewter Gym
    {
        x: 0.11333333333333333
        y: 0.2775
        stop: true
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.15833333333333333
        y: 0.21833333333333332
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Zubat
    {
        x: 0.21916666666666668
        y: 0.15666666666666668
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat
    }
    {
        x: 0.29083333333333333
        y: 0.11166666666666666        
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Zubat
    {
        x: 0.37333333333333335
        y: 0.0725
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat            
    }
    {
        x: 0.4558333333333333
        y: 0.058333333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.5425
        y: 0.060833333333333336
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.62
        y: 0.075
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default

    }
    {
        x: 0.7033333333333334
        y: 0.11
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7758333333333334
        y: 0.15583333333333332
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Cerulean Gym
    {
        x: 0.8375
        y: 0.21916666666666668
        stop: true
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Bellsprout
    {
        x: 0.8841666666666667
        y: 0.2833333333333333
        stop: false
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    # Abra
    {
        x: 0.9166666666666666
        y: 0.3641666666666667
        stop: false
        landLogic: (game, roll) =>
          # Don't do anything (Roll again)
        logic: (game) =>
          playerRoll = game.roll()
          if playerRoll % 2 == 0
            game.movePlayer game.players[game.currPlayer], 2, () =>
              game.board.tiles[game.players[game.currPlayer].position].landLogic game, 2
          else
            game.movePlayer game.players[game.currPlayer], -2, () =>
              game.board.tiles[game.players[game.currPlayer].position].landLogic game, -2
    }
    # Oddish
    {
        x: 0.9366666666666666
        y: 0.4533333333333333
        stop: false 
        landLogic: (game, roll) =>
          currentTile = game.players[game.currPlayer].position
          playerMoveQueue = []

          for player in game.players
            noSpaces = currentTile - player.position
            if Math.abs(noSpaces) > 0 and Math.abs(noSpaces) <= 2
              game.movePlayer player, noSpaces, () =>
                # Do nothing

        logic: @helpers.default
    }
    {
        x: 0.9375
        y: 0.5375
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Rival
    {
        x: 0.9175
        y: 0.6366666666666667
        stop: true
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.8841666666666667
        y: 0.7091666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.835
        y: 0.7816666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Mankee
    {
        x: 0.7775
        y: 0.8358333333333333
        stop: false
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    {
        x: 0.7066666666666667
        y: 0.885
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Vermillion Gym
    {
        x: 0.6191666666666666
        y: 0.92
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll Again
        logic: (game) =>
          playerRoll = game.roll()

          if game.players[game.currPlayer].tileState == 1
            game.players[game.currPlayer].tileState = 0

            if playerRoll % 2 == 0
              game.players[game.currPlayer].missTurn = 1
          else
            @helpers.default game
    }
    {
        x: 0.5425
        y: 0.9366666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # TODO: S.S. Anne
    {
        x: 0.5358333333333334
        y: 0.8875
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.6091666666666666
        y: 0.8741666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.6841666666666667
        y: 0.8408333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Diglet
    {
        x: 0.7475
        y: 0.7983333333333333
        stop: false
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    {
        x: 0.8008333333333333
        y: 0.7491666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Magnemite
    {
        x: 0.845
        y: 0.685
        stop: false
        landLogic: (game, roll) =>
          # Roll again
        logic: (game) =>
          playerRoll = game.roll()
          noSpaces = playerRoll * -1
          console.log noSpaces
          game.movePlayer game.players[game.currPlayer], noSpaces, () =>
            game.board.tiles[game.players[game.currPlayer].position].landLogic game, noSpaces
    }
    {
        x: 0.87
        y: 0.615
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.8925
        y: 0.5366666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Celadon Department Store
    {
        x: 0.8908333333333334
        y: 0.4583333333333333
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].missTurn = 2
          @helpers.defaultLandLogic game, roll          
        logic: @helpers.default
    }
    {
        x: 0.8725
        y: 0.37666666666666665
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Game Corner
    {
        x: 0.8466666666666667
        y: 0.3016666666666667
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll again
        logic: (game) =>
          if game.players[game.currPlayer].tileState == 1
            playerRoll = game.roll()

            game.players[game.currPlayer].tileState = 0
            if playerRoll isnt 3 and playerRoll isnt 5
              game.players[game.currPlayer].missTurn = 2
              @helpers.defaultLandLogic game, playerRoll
          else
              @helpers.default game
    }
    {
        x: 0.8033333333333333
        y: 0.245
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
                
    }
    # Celadon Gym
    {
        x: 0.7525
        y: 0.18916666666666668
        stop: true
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll Again
        logic: (game) =>
          if game.players[game.currPlayer].tileState == 1
            game.players[game.currPlayer].tileState = 0
            playerRoll = game.roll()
            
            if playerRoll > 4
              game.players[game.currPlayer].missTurn = 1

            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game
    }
    # Team Rocket Hideout
    {
        x: 0.6825
        y: 0.14583333333333334
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll again
        logic: (game) =>
          if game.players[game.currPlayer].tileState == 1
            game.players[game.currPlayer].tileState = 0
            playerRoll = game.roll()

            if playerRoll == 1
              game.players[game.currPlayer].missTurn = 3

            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game
    }
    # Rare Candy
    {
        x: 0.6083333333333333
        y: 0.115
        stop: false
        landLogic: (game, roll) =>
          # Roll again
        logic: @helpers.default
    }
    {
        x: 0.5341666666666667
        y: 0.1025
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.46166666666666667
        y: 0.1025
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.38666666666666666
        y: 0.11666666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Gastly
    {
        x: 0.31083333333333335
        y: 0.14833333333333334
        stop: false
        landLogic: (game, roll) =>
          # Roll again
        logic: (game) =>
          playerRoll = game.roll()
          noSpaces = playerRoll * -1

          game.movePlayer game.players[game.currPlayer], noSpaces, () =>
            game.board.tiles[game.players[game.currPlayer].position].landLogic game, noSpaces
    }
    {
        x: 0.24583333333333332
        y: 0.18916666666666668
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.19333333333333333
        y: 0.24166666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.15083333333333335
        y: 0.30416666666666664
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.11833333333333333
        y: 0.38083333333333336
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.10333333333333333
        y: 0.45916666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Pokeflute
    {
        x: 0.10666666666666667
        y: 0.54
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].pokeFlute = true
          @helpers.defaultLandLogic game, roll
        logic: @helpers.default
    }
    {
        x: 0.12166666666666667
        y: 0.6175
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.15583333333333332
        y: 0.6941666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.19583333333333333
        y: 0.7508333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.25166666666666665
        y: 0.8058333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.31666666666666665
        y: 0.845
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Rival
    {
        x: 0.39
        y: 0.8733333333333333
        stop: true
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4658333333333333
        y: 0.8883333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4675
        y: 0.8341666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4025
        y: 0.8225
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.33916666666666667
        y: 0.7983333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Saffron Gym
    {
        x: 0.2816666666666667
        y: 0.7558333333333334
        stop: true
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll Again
        logic: (game) =>
          if game.players[game.currPlayer].tileState == 1
            game.players[game.currPlayer].tileState = 0
            
            playerRoll = game.roll()
            @helpers.defaultLandLogic
          else
            @helpers.default game
    }
    # Doduo
    {
        x: 0.235
        y: 0.7141666666666666
        stop: false
        landLogic: (game, roll) =>
          # Roll Again
        logic: @helpers.default
    }
    # Snorlax
    {
        x: 0.19666666666666666
        y: 0.6616666666666666
        stop: false
        landLogic: (game, roll) =>
          if not game.players[game.currPlayer].pokeFlute
            game.players[game.currPlayer].missTurn = 3
          @helpers.defaultLandLogic game, roll

        logic: @helpers.default
    }
    # Weird black and white Ash on bike
    {
        x: 0.1675
        y: 0.5975
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: (game) =>
          playerRoll = game.roll()
          noSpaces = playerRoll * 2

          game.movePlayer game.players[game.currPlayer], noSpaces, () =>
            game.board.tiles[game.players[game.currPlayer].position].landLogic game, noSpaces
    }
    # Fearow (Should this mean moves?)
    {
        x: 0.15333333333333332
        y: 0.5308333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.15416666666666667
        y: 0.4608333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.165
        y: 0.3933333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Weepinbell
    {
        x: 0.19583333333333333
        y: 0.325
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].missTurn = 2
          @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.23166666666666666
        y: 0.2733333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.28
        y: 0.2275
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.33916666666666667
        y: 0.1925
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4025
        y: 0.16083333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4683333333333333
        y: 0.1475
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.5333333333333333
        y: 0.15166666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Shelldar
    # Slowbro is 38 spaces ahead
    {
        x: 0.5983333333333334
        y: 0.165
        stop: false
        landLogic: (game, roll) =>
          slowBroSpace = game.players[game.currPlayer].position + 38
          shouldMove = false

          for player in game.players
            if player.position >= slowBroSpace
              shouldMove = true

          if shouldMove
            tilesToMove = slowBroSpace - game.players[game.currPlayer].position
            game.movePlayer game.players[game.currPlayer], tilesToMove, () =>
              game.board.tiles[game.players[game.currPlayer].position].landLogic game, tilesToMove

        logic: @helpers.default
    }
    {
        x: 0.66
        y: 0.19583333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Pidgeotto
    {
        x: 0.7166666666666667
        y: 0.23166666666666666
        stop: false
        landLogic: (game, roll) =>
          # Roll again
        logic: @helpers.default
    }
    {
        x: 0.765
        y: 0.28
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Fuschia Gym
    {
        x: 0.8008333333333333
        y: 0.3383333333333333
        stop: true
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Safari Zone
    {
        x: 0.8258333333333333
        y: 0.3958333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.8391666666666666
        y: 0.465
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.835
        y: 0.5316666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.8233333333333334
        y: 0.6033333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Chansey
    {
        x: 0.7975
        y: 0.6633333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7591666666666667
        y: 0
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7108333333333333
        y: 0.7616666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Gold Teeth
    {
        x: 0.6558333333333334
        y: 0.7933333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Kanghaskan
    {
        x: 0.5958333333333333
        y: 0.8208333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.53
        y: 0.835
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Tentacool
    {
        x: 0.525
        y: 0.7816666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.tentacool
    }
    # Raticate
    {
        x: 0.5766666666666667
        y: 0.7733333333333333
        stop: false
        landLogic: (game, roll) =>
          # Roll again
        logic: @helpers.default
    }
    {
        x: 0.6308333333333334
        y: 0.7483333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Tentacool
    {
        x: 0.6775
        y: 0.7191666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.tentacool
    }
    {
        x: 0.7208333333333333
        y: 0.6816666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7508333333333334
        y: 0.6408333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.775
        y: 0.5875
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7841666666666667
        y: 0.5266666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.785
        y: 0.4708333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7766666666666666
        y: 0.41083333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7533333333333333
        y: 0.3566666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Omastar
    {
        x: 0.7225
        y: 0.3125
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll Again
        logic: (game) =>
          if game.players[game.currPlayer].tileState is 1
            game.players[game.currPlayer].tileState = 0
            @helpers.defaultLandLogic game, roll
          else
            @helpers.default game
    }
    {
        x: 0.6841666666666667
        y: 0.27166666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Cinnabar Gym
    {
        x: 0.6333333333333333
        y: 0.23833333333333334
        stop: true
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll again
        logic: (game) =>
          if game.players[game.currPlayer].tileState is 1
              playerRoll = game.roll()

              if playerRoll % 2 isnt 0
                game.players[game.currPlayer].tileState = 0
                @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game
    }
    {
        x: 0.5816666666666667
        y: 0.215
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.5266666666666666
        y: 0.205
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4716666666666667
        y: 0.2025
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Magneton Logic
    {
        x: 0.41833333333333333
        y: 0.21583333333333332
        stop: false
        landLogic: (game, roll) =>
          # Roll Again
        logic: (game) =>
          playerRoll = game.roll()
          noSpaces = playerRoll * -2

          game.movePlayer game.players[game.currPlayer], noSpaces, () =>
            game.board.tiles[game.players[game.currPlayer].position].landLogic game, noSpaces
    }
    {
        x: 0.3616666666666667
        y: 0.23583333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.tentacool
    }
    # Golbat
    {
        x: 0.31416666666666665
        y: 0.2683333333333333
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlayer].tileState = 1
          # Roll again
        logic: (game) =>
          if game.players[game.currPlayer].tileState is 1
            game.players[game.currPlayer].tileState = 0
            @helpers.defaultLandLogic game, roll
          else
            @helpers.default
    }
    {
        x: 0.2725
        y: 0.3125
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.24416666666666667
        y: 0.35583333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.22083333333333333
        y: 0.41
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.20916666666666667
        y: 0.4683333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.20916666666666667
        y: 0.5233333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.225
        y: 0.5875
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.245
        y: 0.635
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Viridian Gym
    {
        x: 0.2758333333333333
        y: 0.6816666666666666
        stop: true
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.3175
        y: 0.7216666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Seaking
    {
        x: 0.365
        y: 0.7466666666666667
        stop: false
        landLogic: (game, roll) =>
          # Roll again
        logic: (game) =>
          playerRoll = game.roll()
          noSpaces = playerRoll * -2

          game.movePlayer game.players[game.currPlayer], noSpaces, () =>
            game.board.tiles[game.players[game.currPlayer].position].landLogic game, noSpaces
    }
    {
        x: 0.4191666666666667
        y: 0.7741666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.47
        y: 0.7883333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4508333333333333
        y: 0.7325
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Zubat
    {
        x: 0.3675
        y: 0.6991666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat
    }
    {
        x: 0.30333333333333334
        y: 0.635
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Zubat
    {
        x: 0.2658333333333333
        y: 0.5483333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat
    }
    # Graveler
    {
        x: 0.26416666666666666
        y: 0.4525
        stop: false
        landLogic: (game, roll) =>
          game.players[game.currPlay].tileState = 1
          # Roll again
        logic: (game) =>
          if game.players[game.currPlay].tileState is 1
            game.players[game.currPlay].tileState = 0
            @helpers.defaultLandLogic()
          else
            @helpers.default
    }
    {
        x: 0.29833333333333334
        y: 0.3625
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Indigo Plateau
    {
        x: 0.36916666666666664
        y: 0.29583333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Lorelei
    {
        x: 0.45416666666666666
        y: 0.26
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Bruno
    {
        x: 0.5433333333333333
        y: 0.26166666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Agatha
    {
        x: 0.6283333333333333
        y: 0.29583333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Lance
    {
        x: 0.6958333333333333
        y: 0.3641666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Rival
    {
        x: 0.7341666666666666
        y: 0.4475
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.7333333333333333
        y: 0.5416666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.6933333333333334
        y: 0.6316666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.6291666666666667
        y: 0.6975
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Hypno
    {
        x: 0.5491666666666667
        y: 0.7283333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.5291666666666667
        y: 0.65
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Rare Candy
    {
        x: 0.5841666666666666
        y: 0.625
        stop: false
        landLogic: (game, roll) =>
          # Extra turn
        logic: @helpers.default
    }
    {
        x: 0.625
        y: 0.5858333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.6558333333333334
        y: 0.5316666666666666
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Exeggutor
    {
        x: 0.6616666666666666
        y: 0.465
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.6383333333333333
        y: 0.4025
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Ninetales
    {
        x: 0.5933333333333334
        y: 0.3525
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.5333333333333333
        y: 0.3325
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4708333333333333
        y: 0.335
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4091666666666667
        y: 0.35833333333333334
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.3675
        y: 0.4008333333333333
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    # Full Restore
    {
        x: 0.3358333333333333
        y: 0.46166666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.3283333333333333
        y: 0.5341666666666667
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.35583333333333333
        y: 0.595
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4058333333333333
        y: 0.64
        stop: false
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.default
    }
    {
        x: 0.4691666666666667
        y: 0.66
        stop: false
        landLogic: (game, roll) =>
          console.log "Last square"
        logic: @helpers.default
    }
  ]