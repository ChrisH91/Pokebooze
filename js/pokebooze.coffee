class @Pokebooze
  constructor: ->
    @ui = new UI
    @setupGame(@ui)
    @setupStage()
    Music.bindings()

  start: (playerNames) ->
    Logger.log("Starting game for players: #{playerNames}")
    @beginGame()
    for name in playerNames
      @game.players.push(new Player({name: name}))
    @initializePlayers()

    @ui.populatePlayerSelectMenu @game.players

    $('.controls').removeClass('hidden')
    @panToStart()

  ### 
    Expects serialized format of:
    {
      players: {
        name: "Matt"
        position: 4
        ..
        color: "#DEADBEEF"
      }
    }
    All parameters are optional.
  ###
  loadGame: (serializedGame) ->
    Logger.log("Starting serialized game for players: #{serializedGame}")
    @beginGame()
    for player in serializedGame.players
      @game.players.push(new Player(player))
    @initializePlayers({resuming: true})

    @ui.populatePlayerSelectMenu @game.players

    $('.controls').removeClass('hidden')
    $('.new-game').hide()
    first_player = @game.players[0]
    @game.lookAtPlayer(first_player)

  beginGame: () ->
    # @plotTiles()
    @baseGroup = @stage.children[0].children[0]
    @painter = new Painter(@baseGroup)
    @camera = new Camera(@game.board)
    @game.board.node = @baseGroup
    boardTransform = $.extend({},@game.board.boardTransform(), @game.board.boardDimensions())
    @painter.paintBoard(boardTransform)
    @buildTiles()

  setupGame: (ui) ->
    @game = new Game ui

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
    for tileBase in Pokebooze.tileCoords
      tileBase.stop = false unless tileBase.stop?
      tileBase.landLogic = Pokebooze.helpers.defaultLandLogic unless tileBase.landLogic?
      tileBase.logic = Pokebooze.helpers.default unless tileBase.logic?

    @game.board.build(Pokebooze.tileCoords)

  initializePlayers: (opts = {resuming: false}) ->
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
      i += @game.board.playerSize unless opts.resuming
      playersList.append("<li style='background-color: "+player.rgbColor()+"' class='player' id='player-"+player.playerNumber+"'><span class='icon'></span><span class='name'>"+player.name+"</span></li>")
    playersList.children().first().addClass('current')

  panToStart: =>
    @camera.rotateToPoint($.extend({},@game.board.tileRotation(0),{duration: 0.0000001, easing: null}), =>
      @camera.zoomToPoint($.extend({},@game.board.tilePosition(0),{duration: 0.0000001, easing: null})))

  @helpers = 
    # Logic
    default: (game, playerRoll) ->
      game.movePlayer game.currPlayer(), playerRoll, () =>
        game.board.tiles[game.currPlayer().position].landLogic game, playerRoll

    zubat: (game, playerRoll) =>
      if playerRoll isnt 1 and playerRoll isnt 2
        @helpers.default game, playerRoll
      else
        @helpers.doNothing game

    tentacool: (game, playerRoll) =>
      console.log "Tentacool"
      if playerRoll isnt 1 and playerRoll isnt 6
        console.log "Move"
        @helpers.default game
      @helpers.doNothing game

    doNothing: (game) ->
      game.ui.flash "#{game.currPlayer().name} is Stuck!", "", 1000
      game.lookAtPlayer(game.currPlayer())
      game.nextPlayer()
      game.ui.enableRoll()

    # Land Logic
    defaultLandLogic: (game, roll) ->
      game.nextPlayer()
      game.ui.enableRoll()

    rollAgain: (game, roll) ->
      game.ui.flash "Roll Again"
      game.ui.enableRoll()

    missTurn: (game, roll) =>
      game.currPlayer().missTurn = 1
      @helpers.defaultLandLogic game, roll


  @tileCoords = [
    {
        x: 0.45666666666666667
        y: 0.9358333333333333
    }
    # Ratatta
    {
        x: 0.3775
        y: 0.9175
        landLogic: (game, roll) =>
          if roll == 1
            game.currPlayer().tileState = 1
            @helpers.rollAgain game
          else
            @helpers.defaultLandLogic game, roll

        logic: (game, playerRoll) =>
          if game.currPlayer().tileState == 1
            game.currPlayer().tileState = 0
            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    # Caterpie
    {
        x: 0.29333333333333333
        y: 0.8816666666666667
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    #Pidgey
    {
        x: 0.22416666666666665
        y: 0.8425
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    # Weedle
    {
        x: 0.16083333333333333
        y: 0.7808333333333334
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    # Metapod/Kakuna
    {
        x: 0.11416666666666667
        y: 0.7116666666666667
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    {
        x: 0.07916666666666666
        y: 0.635
    }
    {
        x: 0.06
        y: 0.5425
    }
    {
        x: 0.059166666666666666
        y: 0.45666666666666667
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    {
        x: 0.07666666666666666
        y: 0.37
    }
    # Pewter Gym
    {
        x: 0.11333333333333333
        y: 0.2775
        stop: true
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState is 1
            game.currPlayer().tileState = 0
            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    {
        x: 0.15833333333333333
        y: 0.21833333333333332
    }
    # Zubat
    {
        x: 0.21916666666666668
        y: 0.15666666666666668
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat
    }
    {
        x: 0.29083333333333333
        y: 0.11166666666666666        
    }
    # Zubat
    {
        x: 0.37333333333333335
        y: 0.0725
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat            
    }
    {
        x: 0.4558333333333333
        y: 0.058333333333333334
    }
    {
        x: 0.5425
        y: 0.060833333333333336
    }
    {
        x: 0.62
        y: 0.075

    }
    {
        x: 0.7033333333333334
        y: 0.11
    }
    {
        x: 0.7758333333333334
        y: 0.15583333333333332
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
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    # Abra
    {
        x: 0.9166666666666666
        y: 0.3641666666666667
        landLogic: @helpers.rollAgain
        logic: (game, playerRoll) =>
          if playerRoll % 2 == 0
            game.movePlayer game.currPlayer(), 2, () =>
              game.board.tiles[game.currPlayer().position].landLogic game, 2
          else
            game.movePlayer game.currPlayer(), -2, () =>
              game.board.tiles[game.currPlayer().position].landLogic game, -2
    }
    # Oddish
    {
        x: 0.9366666666666666
        y: 0.4533333333333333
        stop: false 
        landLogic: (game, roll) =>
          currentTile = game.currPlayer().position
          playerMoveQueue = []

          for player in game.players
            noSpaces = currentTile - player.position
            if Math.abs(noSpaces) > 0 and Math.abs(noSpaces) <= 2
              game.movePlayer player, noSpaces, () =>
          @helpers.defaultLandLogic game, roll

        logic: @helpers.default
    }
    {
        x: 0.9375
        y: 0.5375
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
    }
    {
        x: 0.835
        y: 0.7816666666666666
    }
    # Mankee
    {
        x: 0.7775
        y: 0.8358333333333333
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    # Farfetch'd
    {
        x: 0.7066666666666667
        y: 0.885
        landLogic: (game, roll) =>
            game.currPlayer().tileState = 1
            @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
            if game.currPlayer().tileState == 1
                game.currPlayer().tileState = 0
                @helpers.defaultLandLogic game, playerRoll
            else
                @helpers.default game, playerRoll
    }
    # Vermillion Gym
    {
        x: 0.6191666666666666
        y: 0.92
        stop: true
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState == 1
            game.currPlayer().tileState = 0

            if playerRoll % 2 == 0
              game.currPlayer().missTurn = 1

            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    {
        x: 0.5425
        y: 0.9366666666666666
    }
    # S.S. Anne
    {
        x: 0.5358333333333334
        y: 0.8875
        landLogic: (game, roll) =>
            game.ssAnneDialogue (option) =>
                if option is 1
                    game.currPlayer().missTurn = 1
                else if option is 2
                    game.currPlayer().missTurn = 2
                @helpers.defaultLandLogic game, roll


        logic: @helpers.default
    }
    {
        x: 0.6091666666666666
        y: 0.8741666666666666
    }
    {
        x: 0.6841666666666667
        y: 0.8408333333333333
    }
    # Diglet
    {
        x: 0.7475
        y: 0.7983333333333333
        landLogic: @helpers.missTurn
        logic: @helpers.default
    }
    {
        x: 0.8008333333333333
        y: 0.7491666666666666
    }
    # Magnemite
    {
        x: 0.845
        y: 0.685
        landLogic: @helpers.rollAgain     
        logic: (game, playerRoll) =>
          noSpaces = playerRoll * -1
          console.log noSpaces
          game.movePlayer game.currPlayer(), noSpaces, () =>
            game.board.tiles[game.currPlayer().position].landLogic game, noSpaces
    }
    {
        x: 0.87
        y: 0.615
    }
    {
        x: 0.8925
        y: 0.5366666666666666
    }
    # Celadon Department Store
    {
        x: 0.8908333333333334
        y: 0.4583333333333333
        landLogic: (game, roll) =>
          game.currPlayer().missTurn = 2
          @helpers.defaultLandLogic game, roll          
        logic: @helpers.default
    }
    {
        x: 0.8725
        y: 0.37666666666666665
    }
    # Game Corner
    {
        x: 0.8466666666666667
        y: 0.3016666666666667
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState == 1
            game.currPlayer().tileState = 0
            if playerRoll isnt 3 and playerRoll isnt 5
              game.currPlayer().missTurn = 2
              @helpers.defaultLandLogic game, playerRoll
          else
              @helpers.default game, playerRoll
    }
    {
        x: 0.8033333333333333
        y: 0.245
                
    }
    # Celadon Gym
    {
        x: 0.7525
        y: 0.18916666666666668
        stop: true
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState == 1
            game.currPlayer().tileState = 0
            
            if playerRoll > 4
              game.currPlayer().missTurn = 1

            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    # Team Rocket Hideout
    {
        x: 0.6825
        y: 0.14583333333333334
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState == 1
            game.currPlayer().tileState = 0

            if playerRoll == 1
              game.currPlayer().missTurn = 3

            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game
    }
    # Rare Candy
    {
        x: 0.6083333333333333
        y: 0.115
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    {
        x: 0.5341666666666667
        y: 0.1025
    }
    {
        x: 0.46166666666666667
        y: 0.1025
    }
    {
        x: 0.38666666666666666
        y: 0.11666666666666667
    }
    # Gastly
    {
        x: 0.31083333333333335
        y: 0.14833333333333334
        landLogic: @helpers.rollAgain
        logic: (game, playerRoll) =>
          noSpaces = playerRoll * -1

          game.movePlayer game.currPlayer(), noSpaces, () =>
            game.board.tiles[game.currPlayer().position].landLogic game, noSpaces
    }
    {
        x: 0.24583333333333332
        y: 0.18916666666666668
    }
    {
        x: 0.19333333333333333
        y: 0.24166666666666667
    }
    {
        x: 0.15083333333333335
        y: 0.30416666666666664
    }
    {
        x: 0.11833333333333333
        y: 0.38083333333333336
    }
    {
        x: 0.10333333333333333
        y: 0.45916666666666667
    }
    # Pokeflute
    {
        x: 0.10666666666666667
        y: 0.54
        landLogic: (game, roll) =>
          game.currPlayer().pokeFlute = true
          @helpers.defaultLandLogic game, roll
        logic: @helpers.default
    }
    {
        x: 0.12166666666666667
        y: 0.6175
    }
    {
        x: 0.15583333333333332
        y: 0.6941666666666667
    }
    {
        x: 0.19583333333333333
        y: 0.7508333333333334
    }
    {
        x: 0.25166666666666665
        y: 0.8058333333333333
    }
    {
        x: 0.31666666666666665
        y: 0.845
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
    }
    {
        x: 0.4675
        y: 0.8341666666666666
    }
    {
        x: 0.4025
        y: 0.8225
    }
    {
        x: 0.33916666666666667
        y: 0.7983333333333333
    }
    # Saffron Gym
    {
        x: 0.2816666666666667
        y: 0.7558333333333334
        stop: true
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState == 1
            game.currPlayer().tileState = 0
            
            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    # Doduo
    {
        x: 0.235
        y: 0.7141666666666666
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    # Snorlax
    {
        x: 0.19666666666666666
        y: 0.6616666666666666
        landLogic: (game, roll) =>
          if not game.currPlayer().pokeFlute
            game.currPlayer().missTurn = 3
          @helpers.defaultLandLogic game, roll

        logic: @helpers.default
    }
    # Weird black and white Ash on bike
    {
        x: 0.1675
        y: 0.5975
        landLogic: @helpers.defaultLandLogic
        logic: (game, playerRoll) =>
          noSpaces = playerRoll * 2

          game.movePlayer game.currPlayer(), noSpaces, () =>
            game.board.tiles[game.currPlayer().position].landLogic game, noSpaces
    }
    # Fearow (Should this mean moves?)
    {
        x: 0.15333333333333332
        y: 0.5308333333333334
    }
    {
        x: 0.15416666666666667
        y: 0.4608333333333333
    }
    {
        x: 0.165
        y: 0.3933333333333333
    }
    # Weepinbell
    {
        x: 0.19583333333333333
        y: 0.325
        landLogic: (game, roll) =>
          game.currPlayer().missTurn = 2
          @helpers.defaultLandLogic game, roll
        logic: @helpers.default
    }
    {
        x: 0.23166666666666666
        y: 0.2733333333333333
    }
    {
        x: 0.28
        y: 0.2275
    }
    {
        x: 0.33916666666666667
        y: 0.1925
    }
    {
        x: 0.4025
        y: 0.16083333333333333
    }
    {
        x: 0.4683333333333333
        y: 0.1475
    }
    {
        x: 0.5333333333333333
        y: 0.15166666666666667
    }
    # Shelldar
    # Slowbro is 38 spaces ahead
    {
        x: 0.5983333333333334
        y: 0.165
        landLogic: (game, roll) =>
          slowBroSpace = game.currPlayer().position + 38
          shouldMove = false

          for player in game.players
            if player.position >= slowBroSpace
              shouldMove = true

          if shouldMove
            tilesToMove = slowBroSpace - game.currPlayer().position
            game.movePlayer game.currPlayer(), tilesToMove, () =>
              game.board.tiles[game.currPlayer().position].landLogic game, tilesToMove
          else
            @helpers.defaultLandLogic game, roll

        logic: @helpers.default
    }
    {
        x: 0.66
        y: 0.19583333333333333
    }
    # Pidgeotto
    {
        x: 0.7166666666666667
        y: 0.23166666666666666
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    {
        x: 0.765
        y: 0.28
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
        landLogic: (game, roll) =>
          game.playerSelectionDialogue (player) =>
            game.players[player].missTurn += 1
            @helpers.defaultLandLogic game, roll
        logic: @helpers.default
    }
    {
        x: 0.8391666666666666
        y: 0.465
    }
    {
        x: 0.835
        y: 0.5316666666666666
    }
    {
        x: 0.8233333333333334
        y: 0.6033333333333334
    }
    # Chansey
    {
        x: 0.7975
        y: 0.6633333333333333
        landLogic: (game, roll) =>          
            game.playerSelectionDialogue (player) =>
                game.players[player].missTurn += 1
                @helpers.defaultLandLogic game, roll  
        logic: @helpers.default
    }
    {
        x: 0.7591666666666667
        y: 0.7141666666666666
    }
    {
        x: 0.7108333333333333
        y: 0.7616666666666667
    }
    # Gold Teeth
    {
        x: 0.6558333333333334
        y: 0.7933333333333333
        landLogic: (game, roll) =>
          game.playerSelectionDialogue (player) =>
            game.players[player].missTurn += 1
            @helpers.defaultLandLogic game, roll            
        logic: @helpers.default
    }
    # Kanghaskan
    {
        x: 0.5958333333333333
        y: 0.8208333333333333
        landLogic: (game, roll) =>
            game.playerSelectionDialogue (player) =>
                game.roll (roll) =>
                    noSpaces = roll * -1
                    game.movePlayer game.players[player], noSpaces, () =>
                        @helpers.defaultLandLogic game, roll 
        logic: @helpers.default
    }
    {
        x: 0.53
        y: 0.835
    }
    # Tentacool
    {
        x: 0.525
        y: 0.7816666666666666
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.tentacool
    }
    # Raticate
    {
        x: 0.5766666666666667
        y: 0.7733333333333333
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    {
        x: 0.6308333333333334
        y: 0.7483333333333333
    }
    # Tentacool
    {
        x: 0.6775
        y: 0.7191666666666666
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.tentacool
    }
    # Tentacruel
    {
        x: 0.7208333333333333
        y: 0.6816666666666666
        landLogic: (game, roll) =>
            # Find out who goes next
            while true
                iterator = (game.currPlayerIndex + 1) % game.players.length

                if game.players[iterator].missTurn <= 0
                    game.players[iterator].roleMultiplier = .5
                    break

                ++iterator
            @helpers.defaultLandLogic game, roll


        logic: @helpers.default
    }
    {
        x: 0.7508333333333334
        y: 0.6408333333333334
    }
    {
        x: 0.775
        y: 0.5875
    }
    {
        x: 0.7841666666666667
        y: 0.5266666666666666
    }
    {
        x: 0.785
        y: 0.4708333333333333
    }
    {
        x: 0.7766666666666666
        y: 0.41083333333333333
    }
    {
        x: 0.7533333333333333
        y: 0.3566666666666667
    }
    # Omastar
    {
        x: 0.7225
        y: 0.3125
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState is 1
            game.currPlayer().tileState = 0
            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game
    }
    {
        x: 0.6841666666666667
        y: 0.27166666666666667
    }
    # Cinnabar Gym
    {
        x: 0.6333333333333333
        y: 0.23833333333333334
        stop: true
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState is 1
              if playerRoll % 2 isnt 0
                game.currPlayer().tileState = 0
                @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    {
        x: 0.5816666666666667
        y: 0.215
    }
    {
        x: 0.5266666666666666
        y: 0.205
    }
    {
        x: 0.4716666666666667
        y: 0.2025
    }
    # Magneton Logic
    {
        x: 0.41833333333333333
        y: 0.21583333333333332
        landLogic: @helpers.rollAgain
        logic: (game, playerRoll) =>
          noSpaces = playerRoll * -2

          game.movePlayer game.currPlayer(), noSpaces, () =>
            game.board.tiles[game.currPlayer().position].landLogic game, noSpaces
    }
    {
        x: 0.3616666666666667
        y: 0.23583333333333334
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.tentacool
    }
    # Golbat
    {
        x: 0.31416666666666665
        y: 0.2683333333333333
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState is 1
            game.currPlayer().tileState = 0
            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    {
        x: 0.2725
        y: 0.3125
    }
    {
        x: 0.24416666666666667
        y: 0.35583333333333333
    }
    {
        x: 0.22083333333333333
        y: 0.41
    }
    {
        x: 0.20916666666666667
        y: 0.4683333333333333
    }
    {
        x: 0.20916666666666667
        y: 0.5233333333333333
    }
    {
        x: 0.225
        y: 0.5875
    }
    {
        x: 0.245
        y: 0.635
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
    }
    # Seaking
    {
        x: 0.365
        y: 0.7466666666666667
        landLogic: @helpers.rollAgain
        logic: (game, playerRoll) =>
          noSpaces = playerRoll * -2

          game.movePlayer game.currPlayer(), noSpaces, () =>
            game.board.tiles[game.currPlayer().position].landLogic game, noSpaces
    }
    {
        x: 0.4191666666666667
        y: 0.7741666666666667
    }
    {
        x: 0.47
        y: 0.7883333333333333
    }
    {
        x: 0.4508333333333333
        y: 0.7325
    }
    # Zubat
    {
        x: 0.3675
        y: 0.6991666666666667
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat
    }
    {
        x: 0.30333333333333334
        y: 0.635
    }
    # Zubat
    {
        x: 0.2658333333333333
        y: 0.5483333333333333
        landLogic: @helpers.defaultLandLogic
        logic: @helpers.zubat
    }
    # Graveler
    {
        x: 0.26416666666666666
        y: 0.4525
        landLogic: (game, roll) =>
          game.currPlayer().tileState = 1
          @helpers.rollAgain game, roll
        logic: (game, playerRoll) =>
          if game.currPlayer().tileState is 1
            game.currPlayer().tileState = 0
            @helpers.defaultLandLogic game, playerRoll
          else
            @helpers.default game, playerRoll
    }
    {
        x: 0.29833333333333334
        y: 0.3625
    }
    # Indigo Plateau
    {
        x: 0.36916666666666664
        y: 0.29583333333333334
    }
    # Lorelei
    {
        x: 0.45416666666666666
        y: 0.26
    }
    # Bruno
    {
        x: 0.5433333333333333
        y: 0.26166666666666666
    }
    # Agatha
    {
        x: 0.6283333333333333
        y: 0.29583333333333334
    }
    # Lance
    {
        x: 0.6958333333333333
        y: 0.3641666666666667
    }
    # Rival
    {
        x: 0.7341666666666666
        y: 0.4475
    }
    {
        x: 0.7333333333333333
        y: 0.5416666666666666
    }
    {
        x: 0.6933333333333334
        y: 0.6316666666666667
    }
    {
        x: 0.6291666666666667
        y: 0.6975
    }
    # Hypno
    {
        x: 0.5491666666666667
        y: 0.7283333333333334
    }
    {
        x: 0.5291666666666667
        y: 0.65
    }
    # Rare Candy
    {
        x: 0.5841666666666666
        y: 0.625
        landLogic: @helpers.rollAgain
        logic: @helpers.default
    }
    {
        x: 0.625
        y: 0.5858333333333333
    }
    {
        x: 0.6558333333333334
        y: 0.5316666666666666
    }
    # Exeggutor
    {
        x: 0.6616666666666666
        y: 0.465
    }
    {
        x: 0.6383333333333333
        y: 0.4025
    }
    # Ninetales
    {
        x: 0.5933333333333334
        y: 0.3525
    }
    {
        x: 0.5333333333333333
        y: 0.3325
    }
    {
        x: 0.4708333333333333
        y: 0.335
    }
    {
        x: 0.4091666666666667
        y: 0.35833333333333334
    }
    {
        x: 0.3675
        y: 0.4008333333333333
    }
    # Full Restore
    {
        x: 0.3358333333333333
        y: 0.46166666666666667
    }
    {
        x: 0.3283333333333333
        y: 0.5341666666666667
    }
    {
        x: 0.35583333333333333
        y: 0.595
    }
    {
        x: 0.4058333333333333
        y: 0.64
    }
    {
        x: 0.4691666666666667
        y: 0.66
        landLogic: (game, roll) =>
          console.log "Last square"
        logic: @helpers.default
    }
  ]