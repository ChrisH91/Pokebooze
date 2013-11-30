class @UI
  constructor: ->
    @rollButton = $('#roll-button')
    @bindings()

  bindings: ->
    @rollButton.on("click", ->
      _disableButton(@)
    )

  _disableButton = (button) ->
    $(button).prop('disabled', true)
    $(button).addClass('disabled')
    setTimeout(=>
      _enableButton(button)
    , 2000)

  _enableButton = (button) ->
    $(button).prop('disabled', false)
    $(button).removeClass('disabled')