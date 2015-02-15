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
    @game.board.build(Pokebooze.tileCoords, @game)

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

  @tileCoords = [
  	# 0
    {
        x: 0.45666666666666667
        y: 0.9358333333333333
    }
    # 1 - Ratatta
    {
        x: 0.3775
        y: 0.9175 
        klass: RollAgainHereTile
    }
    # 2 - Caterpie
    {
        x: 0.29333333333333333
        y: 0.8816666666666667
        klass: MissTurnTile
    }
    # 3 - Pidgey
    {
        x: 0.22416666666666665
        y: 0.8425
        klass: RollAgainHereTile
    }
    # 4 - Weedle
    {
        x: 0.16083333333333333
        y: 0.7808333333333334
        klass: MissTurnTile
    }
    # 5 - Metapod/Kakuna
    {
        x: 0.11416666666666667
        y: 0.7116666666666667
        klass: MissTurnTile
    }
    # 6 - Nidoran
    {
        x: 0.07916666666666666
        y: 0.635
    }
    # 7 - Beedrill
    {
        x: 0.06
        y: 0.5425
    }
    # 8
    {
        x: 0.059166666666666666
        y: 0.45666666666666667
        klass: RollAgainTile
    }
    # 9
    {
        x: 0.07666666666666666
        y: 0.37
    }
    # 10 Pewter Gym
    {
        x: 0.11333333333333333
        y: 0.2775
        forceStop: true
        klass: RollAgainHereTile
    }
    {
        x: 0.15833333333333333
        y: 0.21833333333333332
    }
    # Zubat
    {
        x: 0.21916666666666668
        y: 0.15666666666666668
        
        klass: ZubatTile
    }
    {
        x: 0.29083333333333333
        y: 0.11166666666666666        
    }
    # Zubat
    {
        x: 0.37333333333333335
        y: 0.0725
        
        klass: ZubatTile            
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
        forceStop: true
    }
    # Bellsprout
    {
        x: 0.8841666666666667
        y: 0.2833333333333333
        klass: MissTurnTile
    }
    # Abra
    {
        x: 0.9166666666666666
        y: 0.3641666666666667
        klass: AbraTile
    }
    # Oddish
    {
        x: 0.9366666666666666
        y: 0.4533333333333333
        klass: OddishTile
    }
    {
        x: 0.9375
        y: 0.5375
    }
    # Rival
    {
        x: 0.9175
        y: 0.6366666666666667
        forceStop: true
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
        klass: MissTurnTile
    }
    # Farfetch'd
    {
        x: 0.7066666666666667
        y: 0.885
        klass: RollAgainHereTile
    }
    # Vermillion Gym
    {
        x: 0.6191666666666666
        y: 0.92
        forceStop: true
        klass: VermillionGymTile
    }
    {
        x: 0.5425
        y: 0.9366666666666666
    }
    # S.S. Anne
    {
        x: 0.5358333333333334
        y: 0.8875
        klass: SSAnneTile
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
        klass: MissTurnTile
    }
    {
        x: 0.8008333333333333
        y: 0.7491666666666666
    }
    # Magnemite
    {
        x: 0.845
        y: 0.685
        klass: MagnemiteTile
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
        klass: CeladonTile
    }
    {
        x: 0.8725
        y: 0.37666666666666665
    }
    # Game Corner
    {
        x: 0.8466666666666667
        y: 0.3016666666666667
        klass: GameCornerTile
    }
    {
        x: 0.8033333333333333
        y: 0.245
                
    }
    # Celadon Gym
    {
        x: 0.7525
        y: 0.18916666666666668
        forceStop: true
        klass: CeladonGymTile
    }
    # Team Rocket Hideout
    {
        x: 0.6825
        y: 0.14583333333333334
        klass: RocketHideoutTile
    }
    # Rare Candy
    {
        x: 0.6083333333333333
        y: 0.115
        klass: RollAgainTile
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
        klass: GastlyTile
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
        klass: PokeFluteTile
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
        forceStop: true
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
        forceStop: true
        klass: RollAgainHereTile
    }
    # Doduo
    {
        x: 0.235
        y: 0.7141666666666666
        klass: RollAgainTile
    }
    # Snorlax
    {
        x: 0.19666666666666666
        y: 0.6616666666666666
        klass: SnorlaxTile       
    }
    # Weird black and white Ash on bike
    {
        x: 0.1675
        y: 0.5975
        klass: BikeTile
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
        klass: WeepingBellTile        
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
    {
        x: 0.5983333333333334
        y: 0.165
        klass: ShelldarTile
    }
    {
        x: 0.66
        y: 0.19583333333333333
    }
    # Pidgeotto
    {
        x: 0.7166666666666667
        y: 0.23166666666666666
        klass: RollAgainTile
    }
    {
        x: 0.765
        y: 0.28
    }
    # 85 - Fuschia Gym
    {
        x: 0.8008333333333333
        y: 0.3383333333333333
        forceStop: true
    }
    # Safari Zone
    {
        x: 0.8258333333333333
        y: 0.3958333333333333
        klass: OtherMissTurnTile        
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
        klass: ChanseyTile
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
        klass: OtherMissTurnTile
    }
    # Kanghaskan
    {
        x: 0.5958333333333333
        y: 0.8208333333333333
        klass: KanghaskanTile        
    }
    {
        x: 0.53
        y: 0.835
    }
    # Tentacool
    {
        x: 0.525
        y: 0.7816666666666666
        klass: TentacoolTile
    }
    # Raticate
    {
        x: 0.5766666666666667
        y: 0.7733333333333333
        klass: RollAgainTile
    }
    {
        x: 0.6308333333333334
        y: 0.7483333333333333
    }
    # Tentacool
    {
        x: 0.6775
        y: 0.7191666666666666
        klass: TentacoolTile
    }
    # Tentacruel
    {
        x: 0.7208333333333333
        y: 0.6816666666666666
        klass: TentacruelTile
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
    # 104 - Kabuto
    {
        x: 0.785
        y: 0.4708333333333333
    }
    # 105 - Omanyte
    {
        x: 0.7766666666666666
        y: 0.41083333333333333
    }
    # 106 - Aerodactyl
    {
        x: 0.7533333333333333
        y: 0.3566666666666667
    }
    # 107 - Omastar
    {
        x: 0.7225
        y: 0.3125
        klass: RollAgainHereTile
    }
    # 108 - Kabutops
    {
        x: 0.6841666666666667
        y: 0.27166666666666667
    }
    # 109 - Cinnabar Gym
    {
        x: 0.6333333333333333
        y: 0.23833333333333334
        forceStop: true
        klass: CinnabarGymTile
    }
    # 110
    {
        x: 0.5816666666666667
        y: 0.215
    }
    # 111
    {
        x: 0.5266666666666666
        y: 0.205
    }
    # 112 - Magneton
    {
        x: 0.4716666666666667
        y: 0.2025
        klass: MoveBackDoubleTile
    }
    # 113
    {
        x: 0.41833333333333333
        y: 0.21583333333333332
    }
    # 114 - Tentacool
    {
        x: 0.3616666666666667
        y: 0.23583333333333334
        klass: TentacoolTile
    }
    # 115 - Golbat
    {
        x: 0.31416666666666665
        y: 0.2683333333333333
        klass: RollAgainHereTile
    }
    # 116
    {
        x: 0.2725
        y: 0.3125
    }
    # 117
    {
        x: 0.24416666666666667
        y: 0.35583333333333333
    }
    # 118
    {
        x: 0.22083333333333333
        y: 0.41
    }
    # 119
    {
        x: 0.20916666666666667
        y: 0.4683333333333333
    }
    # 120
    {
        x: 0.20916666666666667
        y: 0.5233333333333333
    }
    # 121
    {
        x: 0.225
        y: 0.5875
    }
    # 122
    {
        x: 0.245
        y: 0.635
    }
    # 123 - Viridian Gym
    {
        x: 0.2758333333333333
        y: 0.6816666666666666
        forceStop: true
    }
    # 124
    {
        x: 0.3175
        y: 0.7216666666666667
    }
    # 125 - Seaking
    {
        x: 0.365
        y: 0.7466666666666667
        klass: MoveBackDoubleTile
    }
    # 126
    {
        x: 0.4191666666666667
        y: 0.7741666666666667
    }
    # 127
    {
        x: 0.47
        y: 0.7883333333333333
    }
    # 128
    {
        x: 0.4508333333333333
        y: 0.7325
    }
    # 129 - Zubat
    {
        x: 0.3675
        y: 0.6991666666666667
        klass: ZubatTile
    }
    # 130
    {
        x: 0.30333333333333334
        y: 0.635
    }
    # 131 - Zubat
    {
        x: 0.2658333333333333
        y: 0.5483333333333333
        klass: ZubatTile
    }
    # 132 - Graveler
    {
        x: 0.26416666666666666
        y: 0.4525
        klass: RollAgainHereTile
    }
    # 133
    {
        x: 0.29833333333333334
        y: 0.3625
    }
    # 134 - Indigo Plateau
    {
        x: 0.36916666666666664
        y: 0.29583333333333334
    }
    # 135 - Lorelei
    {
        x: 0.45416666666666666
        y: 0.26
        forceStop: true
    }
    # 136 - Bruno
    {
        x: 0.5433333333333333
        y: 0.26166666666666666
        forceStop: true
    }
    # 137 - Agatha
    {
        x: 0.6283333333333333
        y: 0.29583333333333334
        forceStop: true
    }
    # 138 - Lance
    {
        x: 0.6958333333333333
        y: 0.3641666666666667
        forceStop: true
    }
    # 139 - Rival
    {
        x: 0.7341666666666666
        y: 0.4475
        forceStop: true
    }
    # 140 -
    {
        x: 0.7333333333333333
        y: 0.5416666666666666
    }
    # 141 - 
    {
        x: 0.6933333333333334
        y: 0.6316666666666667
    }
    # 142 - 
    {
        x: 0.6291666666666667
        y: 0.6975
    }
    # 143 - Hypno
    {
        x: 0.5491666666666667
        y: 0.7283333333333334
        klass: HypnoTile
    }
    # 144 
    {
        x: 0.5291666666666667
        y: 0.65
    }
    # 145 - Rare Candy
    {
        x: 0.5841666666666666
        y: 0.625
        klass: RollAgainTile
    }
    # 146
    {
        x: 0.625
        y: 0.5858333333333333
    }
    # 147
    {
        x: 0.6558333333333334
        y: 0.5316666666666666
    }
    # 148 - Exeggutor
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
        forceStop: true
        klass: FinalTile        
    }
  ]