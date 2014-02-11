connect_assets = require "connect-assets"
ect            = require "ect"

module.exports = (app, express) ->
  app.use express.logger("dev")

  # Enable formatted and uncompress html
  app.locals.pretty = true

  # Enable dependency based asset loading
  app.use connect_assets(src: "#{__dirname}/../app/assets")

  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

  app.mocha_test_route = (request, resource) ->
    options = { title: "test of time", view: "mocha_client_test" }
    resource.render('tests/index', options)

  app.get '/mocha', app.mocha_test_route if env is "development"
