class @TileResult
	constructor: (rollAgain = false, missTurn = false, dontMove = false, callback = null) ->
		@rollAgain = rollAgain
		@missTurn = missTurn
		@dontMove = dontMove
		@callback = callback