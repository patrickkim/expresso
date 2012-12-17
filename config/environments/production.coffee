connectAssets = require("connect-assets")
fs            = require("fs")

#gzippo = require('gzippo');
module.exports = (app, express) ->
  # app.use express.logger("dev")

  # log_file = fs.createWriteStream("./log/node.log", {"flags": "a"});
  # Add stream to express.logger(stream: log_file)
  app.disable('quiet')
  app.use express.logger(format: "tiny")

  #Enable dependency based asset loading
  #Setup concatenate and compress build dir
  app.use connectAssets(
    build: true
    compress: true
    buildDir: "./public/bin"
    src: "#{__dirname}/../../app/assets"
  )

  #var duration = 2592000000; // One month
  #app.use(gzippo.staticGzip(__dirname + '/../public_build/', { maxAge: duration }));
  app.use express.errorHandler()