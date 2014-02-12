express     = require "express"
ect         = require "ect"
config_path = "#{__dirname}/config"
auto_loader = require "#{__dirname}../../util/auto_loader"

module.exports = (app) ->
  require("#{config_path}/shared")(app, express)

  # -- Load Environment Settings
  if app.ENV is "production" || app.ENV is "testing" || app.ENV is "development"
    require("#{config_path}/#{app.ENV}") app, express
  else
    console.log "environment #{app.ENV} not found"
  # -- Parses x-www-form-urlencoded request bodies (and json)
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()

  # # CORS middleware
  # # see: http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs
  app.use (req, res, next) ->
    res.header "Access-Control-Allow-Origin", "*"
    res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"
    res.header "Access-Control-Allow-Headers", "Content-Type, Authorization"
    res.header "Cache-Control", "private, max-age=0"
    res.header "Expires", new Date().toUTCString()
    if "OPTIONS" is req.method then res.send 200 else next()

  # -- Express Static Resources
  app.use express.static(app.PATH["static"])
  app.use express.favicon("#{app.PATH["static"]}/icons/favicon.ico")

  # -- Express routing
  app.use app.router

   # -- Define view engine with its options, Using ect for backend templates.
  # see: http://ectjs.com/
  ect_engine = ect(watch: true, root: app.PATH["views"], ext: ".ect")

  app.set "views", app.PATH["views"]
  app.set "view engine", "ect"
  app.engine("ect", ect_engine.render)
  app.enable "jsonp callback"

  # -- Booting up App
  auto_loader.autoload(app.PATH["lib"], app)
  auto_loader.autoload(app.PATH["helpers"], app)
  auto_loader.autoload(app.PATH["models"], app)
  auto_loader.autoload(app.PATH["controllers"], app)

  # -- Routes
  require("#{__dirname}/routes") app
