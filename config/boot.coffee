express  = require "express"
partials = require "express-partials"
# routes   = require("#{__dirname}/routes")(app)

# Global paths
views       = "#{__dirname}/../app/views"
static_root = "#{__dirname}/public"
helpers     = "#{__dirname}/../app/helpers"

###
Global configuration
###
module.exports.boot = (app) ->
  app.configure ->

    # -- Define view engine with its options
    app.set "views", views
    app.set "view engine", "ejs"
    app.enable "jsonp callback"

    # -- Set uncompressed html output and disable layout templating
    app.locals
      pretty: true
      layout: false

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
    app.use express.static(static_root)

    # -- Express Partials
    app.use partials()

    # -- Express routing
    app.use app.router
    # require("#{__dirname}/../app/routes")(app)

    # -- App helpers
    app.helpers = require(helpers)
    app.helpers.autoload "#{__dirname}/../lib", app
    app.helpers.autoload "#{__dirname}/../app/controllers", app

    console.log app.helpers

    # -- 500 status
    app.use (err, req, res, next) ->
      console.log err
      res.status(500).send err

    # -- 404 status
    app.use (req, res, next) ->
      console.log "404"
      res.status(404).end()
