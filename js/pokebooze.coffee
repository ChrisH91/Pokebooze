class @Pokebooze
  constructor: ->
    # Draw plotter helper points on their own layer
    @setupGame()
    @setupStage()
    # @plotTiles()
    @baseGroup = @stage.children[0].children[0]
    @game.board.node = @baseGroup
    window.game = @game
    @drawBoard()
    @drawTiles()

  start: (playerNames) ->
    for name in playerNames
      @game.players.push(new Player name)
    @drawPlayers()

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

  drawBoard: ->
    # Draw the board on its own layer
    boardObj = new Image
    boardObj.onload = =>
      board = new Kinetic.Image {
        x: @game.board.edgeLength/2
        y: @game.board.edgeLength/2
        offsetX: @game.board.edgeLength/2
        offsetY: @game.board.edgeLength/2
        image: boardObj
        width: @game.board.edgeLength
        height: @game.board.edgeLength
      }
      @baseGroup.add(board)
      board.moveToBottom()
      @baseGroup.draw()

    boardObj.src = "/images/game.jpg"


  plotTiles: ->
    plotter = new Plotter $("#table"), @stage


  drawTiles: ->
    @game.board.build(Pokebooze.tileCoords)
    for tile in @game.board.tiles
      circle = new Kinetic.Circle {
        x: @game.board.edgeLength * tile.x
        y: @game.board.edgeLength * tile.y
        # radius: 5
        # fill: 'red'
        # stroke: 'black'
        # strokeWidth: 2
      }
      @baseGroup.add(circle)
    @baseGroup.draw()

  drawPlayers: ->
    playersList = $('.players')
    for player in @game.players
      rect = new Kinetic.Circle {
        x: @game.board.edgeLength * @game.board.tiles[player.position].x
        y: @game.board.edgeLength * @game.board.tiles[player.position].y
        radius: @game.board.playerLength
        fill: player.rgbColor()
        stroke: 'black'
        strokeWidth: 1
      }
      player.node = rect
      @baseGroup.add(rect)
      playersList.append("<li style='background-color: "+player.rgbColor()+"' class='player' id='player-1'><span class='icon'></span><span class='name'>"+player.name+"</span></li>")

    @baseGroup.draw()

  panToStart: =>
    @game.rotateToTile @game.board.tiles[0], =>
      @game.zoomToTile @game.board.tiles[0]

  @tileCoords = [
    {
        x: 0.45666666666666667
        y: 0.9358333333333333
        stop: false
        logic: (roll) ->

    }
    {
        x: 0.3775
        y: 0.9175
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.29333333333333333
        y: 0.8816666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, true)
    }
    {
        x: 0.22416666666666665
        y: 0.8425
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.16083333333333333
        y: 0.7808333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, true)
    }
    {
        x: 0.11416666666666667
        y: 0.7116666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, true)
    }
    {
        x: 0.07916666666666666
        y: 0.635
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.06
        y: 0.5425
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.059166666666666666
        y: 0.45666666666666667
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.07666666666666666
        y: 0.37
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Pewter Gym
    {
        x: 0.11333333333333333
        y: 0.2775
        stop: true
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.15833333333333333
        y: 0.21833333333333332
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Zubat Logic
    {
        x: 0.21916666666666668
        y: 0.15666666666666668
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.29083333333333333
        y: 0.11166666666666666        
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Zubat Logic
    {
        x: 0.37333333333333335
        y: 0.0725
        stop: false
        logic: (roll) ->
            new TileResult(false, false)            
    }
    {
        x: 0.4558333333333333
        y: 0.058333333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5425
        y: 0.060833333333333336
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.62
        y: 0.075
        stop: false
        logic: (roll) ->
            new TileResult(false, false)

    }
    {
        x: 0.7033333333333334
        y: 0.11
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7758333333333334
        y: 0.15583333333333332
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Cerulean Gym
    {
        x: 0.8375
        y: 0.21916666666666668
        stop: true
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8841666666666667
        y: 0.2833333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, true)
    }
    # TODO: Abra Logic!!
    {
        x: 0.9166666666666666
        y: 0.3641666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Oddish Logic
    {
        x: 0.9366666666666666
        y: 0.4533333333333333
        stop: false 
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.9375
        y: 0.5375
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.9175
        y: 0.6366666666666667
        stop: true
        logic: (roll) ->
            new TileResult(false, false)

    }
    {
        x: 0.8841666666666667
        y: 0.7091666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.835
        y: 0.7816666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7775
        y: 0.8358333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7066666666666667
        y: 0.885
        stop: false
        logic: (roll) ->
            new TileResult(false, true)
    }
    {
        x: 0.6191666666666666
        y: 0.92
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Vermillion Gym
    {
        x: 0.5425
        y: 0.9366666666666666
        logic: (roll) ->
            if roll % 2 == 0
                miss = true
            else
                miss = false

            new TileResult(false, true)
    }
    {
        x: 0.5358333333333334
        y: 0.8875
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: S.S. Anne Logic
    {
        x: 0.6091666666666666
        y: 0.8741666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6841666666666667
        y: 0.8408333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7475
        y: 0.7983333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8008333333333333
        y: 0.7491666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, true)
    }
    {
        x: 0.845
        y: 0.685
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Magnemite Logic
    {
        x: 0.87
        y: 0.615
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8925
        y: 0.5366666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8908333333333334
        y: 0.4583333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8725
        y: 0.37666666666666665
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8466666666666667
        y: 0.3016666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8033333333333333
        y: 0.245
        stop: false
        logic: (roll) ->
            if roll isnt 3 or roll isnt 5
                miss = true
            else
                miss = false

            new TileResult(false, miss)
                
    }
    {
        x: 0.7525
        y: 0.18916666666666668
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Celadan Gym
    # TODO: Celadon Gym Logic
    {
        x: 0.6825
        y: 0.14583333333333334
        stop: true
        logic: (roll) ->
            if roll >= 4
                miss = true
            else miss = false

            new TileResult(false, miss)
    }
    {
        x: 0.6083333333333333
        y: 0.115
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Rocket Hideout logic
    {
        x: 0.5341666666666667
        y: 0.1025
        stop: false
        logic: (roll) ->
            if roll is 1
                miss = true
            else
                miss = false

            new TileResult(false, miss)
    }
    {
        x: 0.46166666666666667
        y: 0.1025
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.38666666666666666
        y: 0.11666666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.31083333333333335
        y: 0.14833333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.24583333333333332
        y: 0.18916666666666668
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Gastly logic
    {
        x: 0.19333333333333333
        y: 0.24166666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.15083333333333335
        y: 0.30416666666666664
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.11833333333333333
        y: 0.38083333333333336
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.10333333333333333
        y: 0.45916666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.10666666666666667
        y: 0.54
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.12166666666666667
        y: 0.6175
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.15583333333333332
        y: 0.6941666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.19583333333333333
        y: 0.7508333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.25166666666666665
        y: 0.8058333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.31666666666666665
        y: 0.845
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.39
        y: 0.8733333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4658333333333333
        y: 0.8883333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4675
        y: 0.8341666666666666
        stop: true
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4025
        y: 0.8225
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.33916666666666667
        y: 0.7983333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.2816666666666667
        y: 0.7558333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.235
        y: 0.7141666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Saffron Gym
    {
        x: 0.19666666666666666
        y: 0.6616666666666666
        stop: true
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.1675
        y: 0.5975
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    # TODO: Snorlax/Pokeflute logic
    {
        x: 0.15333333333333332
        y: 0.5308333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Weird Ash pic logic
    {
        x: 0.15416666666666667
        y: 0.4608333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Fearow logic
    {
        x: 0.165
        y: 0.3933333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.19583333333333333
        y: 0.325
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.23166666666666666
        y: 0.2733333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Weepinbell Logic
    {
        x: 0.28
        y: 0.2275
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.33916666666666667
        y: 0.1925
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4025
        y: 0.16083333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4683333333333333
        y: 0.1475
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5333333333333333
        y: 0.15166666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5983333333333334
        y: 0.165
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.66
        y: 0.19583333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    #TODO: Shelldar Logic
    {
        x: 0.7166666666666667
        y: 0.23166666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.765
        y: 0.28
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8008333333333333
        y: 0.3383333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8258333333333333
        y: 0.3958333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Fuschia Gym
    {
        x: 0.8391666666666666
        y: 0.465
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Safari Zone
    {
        x: 0.835
        y: 0.5316666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.8233333333333334
        y: 0.6033333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7975
        y: 0.6633333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7591666666666667
        y: 0
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Chansey Logic
    {
        x: 0.7108333333333333
        y: 0.7616666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6558333333333334
        y: 0.7933333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5958333333333333
        y: 0.8208333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Gold Teeth Logic
    {
        x: 0.53
        y: 0.835
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Kangaskhan Logic
    {
        x: 0.525
        y: 0.7816666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5766666666666667
        y: 0.7733333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Sewaeed like one logic
    {
        x: 0.6308333333333334
        y: 0.7483333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6775
        y: 0.7191666666666666
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.7208333333333333
        y: 0.6816666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Seaweed like one logic
    {
        x: 0.7508333333333334
        y: 0.6408333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: How the fuck are we gonna do this one
    {
        x: 0.775
        y: 0.5875
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7841666666666667
        y: 0.5266666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.785
        y: 0.4708333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7766666666666666
        y: 0.41083333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7533333333333333
        y: 0.3566666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7225
        y: 0.3125
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6841666666666667
        y: 0.27166666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6333333333333333
        y: 0.23833333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5816666666666667
        y: 0.215
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Cinabar Gym
    # TODO: Cinabar Gym Logic
    {
        x: 0.5266666666666666
        y: 0.205
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4716666666666667
        y: 0.2025
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.41833333333333333
        y: 0.21583333333333332
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Magneton Logic
    {
        x: 0.3616666666666667
        y: 0.23583333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.31416666666666665
        y: 0.2683333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Tentacool logic
    {
        x: 0.2725
        y: 0.3125
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Golbat Logic
    {
        x: 0.24416666666666667
        y: 0.35583333333333333
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.22083333333333333
        y: 0.41
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.20916666666666667
        y: 0.4683333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.20916666666666667
        y: 0.5233333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.225
        y: 0.5875
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.245
        y: 0.635
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.2758333333333333
        y: 0.6816666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.3175
        y: 0.7216666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Viridian Gym
    {
        x: 0.365
        y: 0.7466666666666667
        stop: true
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4191666666666667
        y: 0.7741666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Seaking Logic
    {
        x: 0.47
        y: 0.7883333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4508333333333333
        y: 0.7325
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.3675
        y: 0.6991666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.30333333333333334
        y: 0.635
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Zubat Logic
    {
        x: 0.2658333333333333
        y: 0.5483333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.26416666666666666
        y: 0.4525
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Zubat Logic
    {
        x: 0.29833333333333334
        y: 0.3625
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.36916666666666664
        y: 0.29583333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.45416666666666666
        y: 0.26
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # Indigo Plateau
    {
        x: 0.5433333333333333
        y: 0.26166666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6283333333333333
        y: 0.29583333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6958333333333333
        y: 0.3641666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7341666666666666
        y: 0.4475
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.7333333333333333
        y: 0.5416666666666666
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6933333333333334
        y: 0.6316666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6291666666666667
        y: 0.6975
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5491666666666667
        y: 0.7283333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5291666666666667
        y: 0.65
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Hypno Logic
    {
        x: 0.5841666666666666
        y: 0.625
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.625
        y: 0.5858333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6558333333333334
        y: 0.5316666666666666
        stop: false
        logic: (roll) ->
            new TileResult(true, false)
    }
    {
        x: 0.6616666666666666
        y: 0.465
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.6383333333333333
        y: 0.4025
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Exxegutor Logic
    {
        x: 0.5933333333333334
        y: 0.3525
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.5333333333333333
        y: 0.3325
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4708333333333333
        y: 0.335
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4091666666666667
        y: 0.35833333333333334
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.3675
        y: 0.4008333333333333
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.3358333333333333
        y: 0.46166666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    # TODO: Full Restore Logic
    {
        x: 0.3283333333333333
        y: 0.5341666666666667
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.35583333333333333
        y: 0.595
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4058333333333333
        y: 0.64
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
    {
        x: 0.4691666666666667
        y: 0.66
        stop: false
        logic: (roll) ->
            new TileResult(false, false)
    }
  ]