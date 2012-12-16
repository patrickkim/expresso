express  = require "express"

# Global paths
views_path       = "#{__dirname}/../app/views"
static_path      = "#{__dirname}/public"
helpers_path     = "#{__dirname}/../app/helpers"
lib_path         = "#{__dirname}/../lib"
controllers_path = "#{__dirname}/../app/controllers"
routes_path      = "#{__dirname}/../app/routes"

###
Global configuration
###
module.exports.boot = (app) ->
  app.configure ->

    # -- Define view engine with its options
    app.set "views", views_path
    app.set "view engine", "ejs"
    # app.enable "jsonp callback"

    # -- Set uncompressed html output and disable layout templating
    # app.locals( pretty: true, layout: false)

    # -- Parses x-www-form-urlencoded request bodies (and json)
    app.use express.bodyParser()
    app.use express.methodOverride()

    # ## CORS middleware
    # see: http://stackoverflow.com/questions/7067966/how-to-allow-cors-in-express-nodejs
    app.use (req, res, next) ->
      res.header "Access-Control-Allow-Origin", "*"
      res.header "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE"
      res.header "Access-Control-Allow-Headers", "Content-Type, Authorization"
      res.header "Cache-Control", "private, max-age=0"
      res.header "Expires", new Date().toUTCString()
      if "OPTIONS" is req.method
        res.send 200
      else
        next()

    # -- Express Static Resources
    app.use express.static(static_path)

    # -- App helpers
    app.helpers = require(helpers_path)
    app.helpers.autoload(lib_path, app)
    app.helpers.autoload(controllers_path, app)

    # -- Express routing
    app.use app.router
    require(routes_path)(app)

