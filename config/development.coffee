connect_assets = require "connect-assets"
assets_path = "#{__dirname}/../app/assets"

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

  app.mocha_test_route = (req, res) ->
    options = { title: "test of time", view: "mocha_client_test" }
    res.render('mocha/index', options)