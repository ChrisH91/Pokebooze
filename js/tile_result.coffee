class @TileResult
	@rollAgain = false
	@missTurn = false
	@dontMove = false
	@callback = null

	constructor: (rollAgain, missTurn) ->
		@rollAgain = rollAgain
		@missTurn = missTurn