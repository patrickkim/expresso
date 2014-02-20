express     = require "express"
auto_loader = require "#{__dirname}/util/auto_loader"
config      = require "#{__dirname}/config/config"

module.exports = (app) ->
  # -- Shared Settings
  app.settings.app_name = config.shared_settings.app_name
  app.ENV = process.env.NODE_ENV || "development"

  # -- Global paths
  app.PATH = {}
  app.PATH["config"]      = "#{__dirname}/config"
  app.PATH["static"]      = "#{__dirname}/../public"
  app.PATH["assets"]      = "#{__dirname}/../assets"
  app.PATH["lib"]         = "#{__dirname}/lib"
  app.PATH["helpers"]     = "#{__dirname}/helpers"
  app.PATH["models"]      = "#{__dirname}/models"
  app.PATH["views"]       = "#{__dirname}/../views"
  app.PATH["controllers"] = "#{__dirname}/controllers"
  app.PATH["routes"]      = "#{__dirname}/routes"

  # -- Express Static Resources (order matters this takes precendence )
  app.use express.static("#{app.PATH["static"] }")
  app.use express.favicon("#{app.PATH["static"]}/icons/favicon.ico")

  # -- Load Environment Settings
  if app.ENV is "production" || app.ENV is "testing" || app.ENV is "development"
    require("#{app.PATH["config"]}/#{app.ENV}") app, express
  else
    console.log "[ERROR] environment #{app.ENV} not found".red

  # -- Parses x-www-form-urlencoded request bodies (and json)
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.urlencoded()
  app.use express.json()

  # -- CORS middleware
  # # see: http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs
  app.use (req, res, next) ->
    res.header "Access-Control-Allow-Origin", "*"
    res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"
    res.header "Access-Control-Allow-Headers", "Content-Type, Authorization"
    res.header "Cache-Control", "private, max-age=0"
    res.header "Expires", new Date().toUTCString()
    if "OPTIONS" is req.method then res.send 200 else next()

  # -- Express routing
  app.use app.router

  # -- Define view engine with its options, Using ect for backend templates.
  app.set 'view engine', 'jade'

  app.enable "jsonp callback"

  # -- Booting up App
  auto_loader.autoload(app.PATH["lib"], app)
  auto_loader.autoload(app.PATH["helpers"], app)
  auto_loader.autoload(app.PATH["models"], app)
  auto_loader.autoload(app.PATH["controllers"], app)

  # -- Routes for App
  require(app.PATH["routes"]) app
