config = require "config"
assets = require "connect-assets"
# fs            = require("fs")

module.exports = (app, express) ->
  # Turn off Debugging?
  # app.DEBUG_LOG = false
  # app.DEBUG_WARN = false
  # app.DEBUG_ERROR = true
  # app.DEBUG_CLIENT = false

  # app.set "port", port

  # Enable HTML compression
  app.locals.pretty = false

  # log_file = fs.createWriteStream("./log/node.log", {"flags": "a"});
  # Add stream to express.logger(stream: log_file)
  app.disable('quiet')
  app.use express.logger(format: "tiny")

  #Enable dependency based asset loading
  #Setup concatenate and compress build dir
  app.use connect_assets(
    build: true
    compress: true
    buildDir: "./public/build"
    src: assets_path
  )

  app.use express.errorHandler()