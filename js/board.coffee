class @Board
  constructor: () ->
    @edgeLength = Math.min(window.innerWidth,window.innerHeight)
    @playerLength = @edgeLength/75