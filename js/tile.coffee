class @Tile
  constructor: (@opts, @game) ->
    @x = @opts.x
    @y = @opts.y
    @forceStop = @opts.forceStop

  # Fires when we land on a tile (at the end of our roll)
  landLogic: ->
    @_defaultLandLogic()

  # Fires on every tile we move over (during our roll)
  crossLogic: ->

  # Fires as we leave a tile (at the start of our roll)
  leaveLogic: (playerRoll) ->
    @game.movePlayer @game.currPlayer(), playerRoll, () =>
      @game.currTile().landLogic playerRoll

  feedbackLogic: ->

  _defaultLandLogic: ->
    @game.nextPlayer()
    @game.ui.enableRoll()

  _rollAgain: () ->
    @game.ui.flash "Roll Again"
    @game.ui.enableRoll()

  _drink: () ->
    Music.playClink()

  _doNothing: () ->
    @game.ui.flash "#{@game.currPlayer().name} is Stuck!", "", 1000
    @game.lookAtPlayer(@game.currPlayer())
    @game.nextPlayer()
    @game.ui.enableRoll()

class @MissTurnTile extends @Tile
  landLogic: (roll) ->
    @game.currPlayer().missTurn = 1
    super roll

class @RollAgainTile extends @Tile  
  landLogic: (roll) ->
    @_rollAgain()

class @RollAgainHereTile extends @RollAgainTile
  landLogic: (roll) ->
    @game.currPlayer().tileState = 1
    super roll
  leaveLogic: (playerRoll) =>
    if @game.currPlayer().tileState is 1
      @game.currPlayer().tileState = 0
      @_defaultLandLogic playerRoll
    else
      super playerRoll

class @ZubatTile extends @Tile
  leaveLogic: (playerRoll) =>
    if (playerRoll isnt 1 and playerRoll isnt 2) or @game.currPlayer().stuckFor isnt 0
      @game.currPlayer().stuckFor = 0
      super playerRoll
    else
      @game.currPlayer().stuckFor++
      @_doNothing()

class @TentacoolTile extends @Tile
  leaveLogic: (playerRoll) =>
    console.log "Tentacool"
    if playerRoll isnt 1 and playerRoll isnt 6
      console.log "Move"
      super # Need roll?
    else
      @_doNothing()

class @AbraTile extends @RollAgainTile
  leaveLogic: (playerRoll) =>
    if playerRoll % 2 == 0
      @game.movePlayer @game.currPlayer(), 2, () =>
        @game.currTile().landLogic 2
    else
      @game.movePlayer @game.currPlayer(), -2, () =>
        @game.currTile().landLogic -2

class @OddishTile extends @Tile
  landLogic: (roll) =>
    currentTile = @game.currPlayer().position
    playerMoveQueue = []

    for player in @game.players
      noSpaces = currentTile - player.position
      if Math.abs(noSpaces) > 0 and Math.abs(noSpaces) <= 2
        @game.movePlayer player, noSpaces, () =>
    super roll

class @VermillionGymTile extends @RollAgainTile
  landLogic: (roll) =>
    @game.currPlayer().tileState = 1
    super roll
  leaveLogic: (playerRoll) =>
    if @game.currPlayer().tileState is 1
      @game.currPlayer().tileState = 0

      if playerRoll % 2 is 0
        @game.currPlayer().missTurn = 1

      @_defaultLandLogic playerRoll
    else
      super playerRoll

class @SSAnneTile extends @Tile
  landLogic: (roll) =>
    @game.ssAnneDialogue (option) =>
      if option is 1
        @game.currPlayer().missTurn = 1
      else if option is 2
        @game.currPlayer().missTurn = 2
      super roll

class @MagnemiteTile extends @RollAgainTile
  leaveLogic: (playerRoll) =>
    noSpaces = playerRoll * -1
    console.log noSpaces
    @game.movePlayer @game.currPlayer(), noSpaces, () =>
      @game.currTile().landLogic noSpaces

class @CeladonTile extends @Tile
  landLogic: (roll) =>
    @game.currPlayer().missTurn = 2
    super roll

class @GameCornerTile extends @RollAgainTile
  landLogic: (roll) =>
    @game.currPlayer().tileState = 1
    super roll
  leaveLogic: (playerRoll) =>
    if @game.currPlayer().tileState is 1
      @game.currPlayer().tileState = 0
      if playerRoll isnt 3 and playerRoll isnt 5
        @game.currPlayer().missTurn = 2
      @_defaultLandLogic playerRoll
    else
      super playerRoll

class @CeladonGymTile extends @RollAgainTile
  landLogic: (roll) =>
    @game.currPlayer().tileState = 1
    super roll
  leaveLogic: (playerRoll) =>
    if @game.currPlayer().tileState is 1
      @game.currPlayer().tileState = 0
      if playerRoll > 4
        @game.currPlayer().missTurn = 1
      @_defaultLandLogic playerRoll
    else
      super playerRoll

class @RocketHideoutTile extends @RollAgainTile
  landLogic: (roll) =>
    @game.currPlayer().tileState = 1
    super roll
  leaveLogic: (playerRoll) =>
    if @game.currPlayer().tileState is 1
      @game.currPlayer().tileState = 0
      if playerRoll == 1
        @game.currPlayer().missTurn = 3
      @_defaultLandLogic playerRoll
    else
      super playerRoll

class @GastlyTile extends @RollAgainTile
  leaveLogic: (playerRoll) =>
    noSpaces = playerRoll * -1
    @game.movePlayer @game.currPlayer(), noSpaces, () =>
      @game.currTile().landLogic noSpaces

class @PokeFluteTile extends @Tile
  landLogic: (roll) =>
    @game.currPlayer().pokeFlute = true
    super roll

class @SnorlaxTile extends @Tile
  landLogic: (roll) =>
    if not @game.currPlayer().pokeFlute
      @game.currPlayer().missTurn = 3
    super roll

class @BikeTile extends @Tile
  leaveLogic: (playerRoll) =>
    noSpaces = playerRoll * 2

    @game.movePlayer @game.currPlayer(), noSpaces, () =>
      @game.currTile().landLogic noSpaces

class @WeepingBellTile extends @Tile
  landLogic: (roll) =>
    @game.currPlayer().missTurn = 2
    super roll

class @ShelldarTile extends @Tile
  landLogic: (roll) =>
    slowBroSpace = @game.currPlayer().position + 38
    shouldMove = false

    for player in @game.players
      if player.position >= slowBroSpace
        shouldMove = true

    if shouldMove
      tilesToMove = slowBroSpace - @game.currPlayer().position
      @game.movePlayer @game.currPlayer(), tilesToMove, () =>
        @game.currTile().landLogic tilesToMove
    else
      super roll

# Make another player miss @missTurns turns
class @OtherMissTurnTile extends @Tile
  constructor: (@opts, @game) ->
    super
    @missTurns = 1

  landLogic: (roll) =>
    @game.playerSelectionDialogue (player) =>
      @game.players[player].missTurn += @missTurns
      super roll

class @ChanseyTile extends @OtherMissTurnTile
  constructor: (@opts, @game) ->
    super
    @missTurns = 2

class @KanghaskanTile extends @Tile
  landLogic: (roll) =>
    @game.playerSelectionDialogue (player) =>
      @game.roll (roll) =>
        noSpaces = roll * -1
        @game.movePlayer @game.players[player], noSpaces, () =>
          super roll

class @TentacruelTile extends @Tile
  landLogic: (roll) =>
    # Find out who goes next
    iterator = (@game.currPlayerIndex + 1) % @game.players.length
    while true
      if @game.players[iterator].missTurn <= 0
        @game.players[iterator].roleMultiplier = .5
        break
      ++iterator
    super roll

class @CinnabarGymTile extends @RollAgainTile
  landLogic: (roll) =>
    @game.currPlayer().tileState = 1
    super roll
  leaveLogic: (playerRoll) =>
    if @game.currPlayer().tileState is 1
      if playerRoll % 2 isnt 0
        @game.currPlayer().tileState = 0
        @_defaultLandLogic playerRoll
      else
        super playerRoll
    else
      super playerRoll

class @MoveBackDoubleTile extends @RollAgainTile
  leaveLogic: (playerRoll) =>
    noSpaces = playerRoll * -2
    @game.movePlayer @game.currPlayer(), noSpaces, () =>
      @game.currTile().landLogic noSpaces

class @FinalTile extends @Tile
  landLogic: (game, roll) =>
    @game.currPlayer().missTurn = 100000
    console.log "Last square"