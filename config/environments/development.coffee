connectAssets = require "connect-assets"

module.exports = (app, express) ->
  app.use express.logger("dev")

  # Enable dependency based asset loading
  # app.use connectAssets
  #   build: true
  #   compress: true
  #   buildDir: "./public/bin"
  #   src: "#{__dirname}/../../app/assets"
  app.use connectAssets(src: "#{__dirname}/../../app/assets")

  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )