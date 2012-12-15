# -- Global settings
settings =
  siteName: "yoursitename"
  sessionSecret: "sessionSecret"
  uri: "http://localhost" # Without trailing /
  port: process.env.PORT or 3000
  debug: 0
  profile: 0

  # App settings
  HISTORY_LIMIT_MSG_NUMBER: 50


###
Default configuration manager
Inject app and express reference
###
module.exports = (app, express, env) ->
  require("./environments/development") app, express  if "development" is env
  require("./environments/production") app, express  if "production" is env
  partials = require "express-partials"

  app.set 'views', "#{__dirname}/../app/views"
  app.set 'view engine', 'ejs'

  app.use express.static("#{__dirname}/../public")
  # app.use express.bodyParser()
  # app.use express.methodOverride()
  app.use partials()
  app.use app.router

  # Helpers
  app.helpers = require "#{__dirname}/../app/helpers"
  app.helpers.autoload "#{__dirname}/../lib", app
  app.helpers.autoload "#{__dirname}/../app/controllers", app

module.exports.settings = settings