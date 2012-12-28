connectAssets = require "connect-assets"
env           = process.env.NODE_ENV || "development"
db_config     = require "./database"

module.exports = (app, express) ->
  app.use express.logger("dev")

  console.log "ENV: #{env}"
  console.log "#{db_config[env]}"

  # Enable dependency based asset loading
  # app.use connectAssets
  #   build: true
  #   compress: true
  #   buildDir: "./public/bin"
  #   src: "#{__dirname}/../../app/assets"
  app.use connectAssets(src: "#{__dirname}/../app/assets")

  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )