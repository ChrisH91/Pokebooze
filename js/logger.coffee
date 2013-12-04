class @Logger
  @LOG_ON = false

  @log: (message) ->
    console.log("[#{new Date().toLocaleTimeString()}] #{message}") if Logger.LOG_ON