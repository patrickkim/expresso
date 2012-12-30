connect_assets = require "connect-assets"
assets_path    = "#{__dirname}/../app/assets"
# fs            = require("fs")

module.exports = (app, express) ->
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