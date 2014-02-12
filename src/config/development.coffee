config = require "./config"
assets = require "connect-assets"
ect = require "ect"

module.exports = (app, express) ->
  # app.DEBUG_LOG = true
  # app.DEBUG_WARN = true
  # app.DEBUG_ERROR = true
  # app.DEBUG_CLIENT = true
  # app.DB_HOST = 'localhost'
  # app.DB_PORT = "3306"
  # app.DB_NAME = 'mvc_example'
  # app.DB_USER = 'root'
  # app.DB_PASS = 'root'
  app.set "port", config[app.ENV].port

  # Logging
  app.use express.logger("dev")

  # Enable formatted and uncompress html
  app.locals.pretty = true

  # Enable dependency based asset loading
  console.log app.PATH["assets"]
  app.use assets()

  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

  app.mocha_test_route = (request, resource) ->
    options = { title: "test of time", view: "mocha_client_test" }
    resource.render('tests/index', options)
  app.get '/mocha', app.mocha_test_route